// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

contract ZKVerifier {
    uint256 internal immutable HASH_SCALAR_VALUE;
    uint256 internal immutable M_56_PX_VALUE;
    uint256 internal immutable M_56_PY_VALUE;

    constructor(uint256 _hashScalar, uint256 _m56Px, uint256 _m56Py) {
        HASH_SCALAR_VALUE = _hashScalar;
        M_56_PX_VALUE = _m56Px;
        M_56_PY_VALUE = _m56Py;
    }

    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        uint256 length = p1.length * 6;
        uint256[] memory input = new uint256[](length);
        uint256[1] memory result;
        bool ret;

        require(p1.length == p2.length);

        for (uint256 i = 0; i < p1.length; i++) {
            input[0 + i * 6] = p1[i].x;
            input[1 + i * 6] = p1[i].y;
            input[2 + i * 6] = p2[i].x[0];
            input[3 + i * 6] = p2[i].x[1];
            input[4 + i * 6] = p2[i].y[0];
            input[5 + i * 6] = p2[i].y[1];
        }

        assembly {
            ret := staticcall(gas(), 8, add(input, 0x20), mul(length, 0x20), result, 0x20)
        }
        require(ret);
        return result[0] != 0;
    }

    uint256 constant q_mod =
        21888242871839275222246405745257275088548364400416034343698204186575808495617;

    function fr_invert(uint256 a) internal view returns (uint256) {
        return fr_pow(a, q_mod - 2);
    }

    function fr_pow(uint256 a, uint256 power) internal view returns (uint256) {
        uint256[6] memory input;
        uint256[1] memory result;
        bool ret;

        input[0] = 32;
        input[1] = 32;
        input[2] = 32;
        input[3] = a;
        input[4] = power;
        input[5] = q_mod;

        assembly {
            ret := staticcall(gas(), 0x05, input, 0xc0, result, 0x20)
        }
        require(ret);

        return result[0];
    }

    function fr_div(uint256 a, uint256 b) internal view returns (uint256) {
        require(b != 0);
        return mulmod(a, fr_invert(b), q_mod);
    }

    function fr_mul_add(
        uint256 a,
        uint256 b,
        uint256 c
    ) internal pure returns (uint256) {
        return addmod(mulmod(a, b, q_mod), c, q_mod);
    }

    function fr_mul_add_pm(
        uint256[84] memory m,
        uint256[] calldata proof,
        uint256 opcode,
        uint256 t
    ) internal pure returns (uint256) {
        for (uint256 i = 0; i < 32; i += 2) {
            uint256 a = opcode & 0xff;
            if (a != 0xff) {
                opcode >>= 8;
                uint256 b = opcode & 0xff;
                opcode >>= 8;
                t = addmod(mulmod(proof[a], m[b], q_mod), t, q_mod);
            } else {
                break;
            }
        }

        return t;
    }

    function fr_mul_add_mt(
        uint256[84] memory m,
        uint256 base,
        uint256 opcode,
        uint256 t
    ) internal pure returns (uint256) {
        for (uint256 i = 0; i < 32; i += 1) {
            uint256 a = opcode & 0xff;
            if (a != 0xff) {
                opcode >>= 8;
                t = addmod(mulmod(base, t, q_mod), m[a], q_mod);
            } else {
                break;
            }
        }

        return t;
    }

    function fr_reverse(uint256 input) internal pure returns (uint256 v) {
        v = input;

        // swap bytes
        v =
            ((v & 0xFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00) >> 8) |
            ((v & 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) << 8);

        // swap 2-byte long pairs
        v =
            ((v & 0xFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000) >> 16) |
            ((v & 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) << 16);

        // swap 4-byte long pairs
        v =
            ((v & 0xFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000) >> 32) |
            ((v & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) << 32);

        // swap 8-byte long pairs
        v =
            ((v & 0xFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF0000000000000000) >> 64) |
            ((v & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) << 64);

        // swap 16-byte long pairs
        v = (v >> 128) | (v << 128);
    }

    uint256 constant p_mod =
        21888242871839275222246405745257275088696311157297823662689037894645226208583;

    struct G1Point {
        uint256 x;
        uint256 y;
    }

    struct G2Point {
        uint256[2] x;
        uint256[2] y;
    }

    function ecc_from(uint256 x, uint256 y) internal pure returns (G1Point memory r) {
        r.x = x;
        r.y = y;
    }

    function ecc_add(
        uint256 ax,
        uint256 ay,
        uint256 bx,
        uint256 by
    ) internal view returns (uint256, uint256) {
        bool ret = false;
        G1Point memory r;
        uint256[4] memory input_points;

        input_points[0] = ax;
        input_points[1] = ay;
        input_points[2] = bx;
        input_points[3] = by;

        assembly {
            ret := staticcall(gas(), 6, input_points, 0x80, r, 0x40)
        }
        require(ret);

        return (r.x, r.y);
    }

    function ecc_sub(
        uint256 ax,
        uint256 ay,
        uint256 bx,
        uint256 by
    ) internal view returns (uint256, uint256) {
        return ecc_add(ax, ay, bx, p_mod - by);
    }

    function ecc_mul(
        uint256 px,
        uint256 py,
        uint256 s
    ) internal view returns (uint256, uint256) {
        uint256[3] memory input;
        bool ret = false;
        G1Point memory r;

        input[0] = px;
        input[1] = py;
        input[2] = s;

        assembly {
            ret := staticcall(gas(), 7, input, 0x60, r, 0x40)
        }
        require(ret);

        return (r.x, r.y);
    }

    function _ecc_mul_add(uint256[5] memory input) internal view {
        bool ret = false;

        assembly {
            ret := staticcall(gas(), 7, input, 0x60, add(input, 0x20), 0x40)
        }
        require(ret);

        assembly {
            ret := staticcall(gas(), 6, add(input, 0x20), 0x80, add(input, 0x60), 0x40)
        }
        require(ret);
    }

    function ecc_mul_add(
        uint256 px,
        uint256 py,
        uint256 s,
        uint256 qx,
        uint256 qy
    ) internal view returns (uint256, uint256) {
        uint256[5] memory input;
        input[0] = px;
        input[1] = py;
        input[2] = s;
        input[3] = qx;
        input[4] = qy;

        _ecc_mul_add(input);

        return (input[3], input[4]);
    }

    function ecc_mul_add_pm(
        uint256[84] memory m,
        uint256[] calldata proof,
        uint256 opcode,
        uint256 t0,
        uint256 t1
    ) internal view returns (uint256, uint256) {
        uint256[5] memory input;
        input[3] = t0;
        input[4] = t1;
        for (uint256 i = 0; i < 32; i += 2) {
            uint256 a = opcode & 0xff;
            if (a != 0xff) {
                opcode >>= 8;
                uint256 b = opcode & 0xff;
                opcode >>= 8;
                input[0] = proof[a];
                input[1] = proof[a + 1];
                input[2] = m[b];
                _ecc_mul_add(input);
            } else {
                break;
            }
        }

        return (input[3], input[4]);
    }

    function update_hash_scalar(
        uint256 v,
        uint256[144] memory absorbing,
        uint256 pos
    ) internal pure {
        absorbing[pos++] = 0x02;
        absorbing[pos++] = v;
    }

    function update_hash_point(
        uint256 x,
        uint256 y,
        uint256[144] memory absorbing,
        uint256 pos
    ) internal pure {
        absorbing[pos++] = 0x01;
        absorbing[pos++] = x;
        absorbing[pos++] = y;
    }

    function to_scalar(bytes32 r) private pure returns (uint256 v) {
        uint256 tmp = uint256(r);
        tmp = fr_reverse(tmp);
        v = tmp % 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
    }

    function hash(uint256[144] memory absorbing, uint256 length)
        private
        view
        returns (bytes32[1] memory v)
    {
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 2, absorbing, length, v, 32)
            switch success
            case 0 {
                invalid()
            }
        }
        assert(success);
    }

    function squeeze_challenge(uint256[144] memory absorbing, uint32 length)
        internal
        view
        returns (uint256 v)
    {
        absorbing[length] = 0;
        bytes32 res = hash(absorbing, length * 32 + 1)[0];
        v = to_scalar(res);
        absorbing[0] = uint256(res);
        length = 1;
    }

    function get_verify_circuit_g2_s() internal pure returns (G2Point memory s) {
        s.x[0] = uint256(
            19996377281670978687180986182441301914718493784645870391946826878753710639456
        );
        s.x[1] = uint256(
            4287478848095488335912479212753150961411468232106701703291869721868407715111
        );
        s.y[0] = uint256(
            6995741485533723263267942814565501722132921805029874890336635619836737653877
        );
        s.y[1] = uint256(
            11126659726611658836425410744462014686753643655648740844565393330984713428953
        );
    }

    function get_verify_circuit_g2_n() internal pure returns (G2Point memory n) {
        n.x[0] = uint256(
            11559732032986387107991004021392285783925812861821192530917403151452391805634
        );
        n.x[1] = uint256(
            10857046999023057135944570762232829481370756359578518086990519993285655852781
        );
        n.y[0] = uint256(
            17805874995975841540914202342111839520379459829704422454583296818431106115052
        );
        n.y[1] = uint256(
            13392588948715843804641432497768002650278120570034223513918757245338268106653
        );
    }

    function get_target_circuit_g2_s() internal pure returns (G2Point memory s) {
        s.x[0] = uint256(
            19996377281670978687180986182441301914718493784645870391946826878753710639456
        );
        s.x[1] = uint256(
            4287478848095488335912479212753150961411468232106701703291869721868407715111
        );
        s.y[0] = uint256(
            6995741485533723263267942814565501722132921805029874890336635619836737653877
        );
        s.y[1] = uint256(
            11126659726611658836425410744462014686753643655648740844565393330984713428953
        );
    }

    function get_target_circuit_g2_n() internal pure returns (G2Point memory n) {
        n.x[0] = uint256(
            11559732032986387107991004021392285783925812861821192530917403151452391805634
        );
        n.x[1] = uint256(
            10857046999023057135944570762232829481370756359578518086990519993285655852781
        );
        n.y[0] = uint256(
            17805874995975841540914202342111839520379459829704422454583296818431106115052
        );
        n.y[1] = uint256(
            13392588948715843804641432497768002650278120570034223513918757245338268106653
        );
    }

    function get_wx_wg(uint256[] calldata proof, uint256[6] memory instances)
        internal
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256[84] memory m;
        uint256[144] memory absorbing;
        uint256 t0 = 0;
        uint256 t1 = 0;

        (t0, t1) = (
            ecc_mul(
                16273630658577275004922498653030603356133576819117084202553121866583118864964,
                6490159372778831696763963776713702553449715395136256408127406430701013586737,
                instances[0]
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                21465583338900056601761668793508143213048509206826828900542864688378093593107,
                18916078441896187703473496284050716429170517783995157941513585201547834049281,
                instances[1],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                6343857336395576108841088300387244434710621968858839561085778033655098739860,
                8647137667680968494319179221347060255241434220013711910139382436020093396308,
                instances[2],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                17609998990685530094209191702545036897101285294398654477281719279316619940710,
                7891327626892441842954365090016786852185025910332850053066512639794082797200,
                instances[3],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                1271298011119556361067568041994358027954229594187408866479678256322993207430,
                16519855264988006509000373008036578681979317060055767197977112967887569978562,
                instances[4],
                t0,
                t1
            )
        );
        (m[0], m[1]) = (
            ecc_mul_add(
                9106880861932848269529912338578777683259870408474914617967634470292361865683,
                3191458938194545761508145121615374474619318896841102235687991186359560600763,
                instances[5],
                t0,
                t1
            )
        );
        update_hash_scalar(HASH_SCALAR_VALUE, absorbing, 0);
        update_hash_point(m[0], m[1], absorbing, 2);
        for (t0 = 0; t0 <= 4; t0++) {
            update_hash_point(proof[0 + t0 * 2], proof[1 + t0 * 2], absorbing, 5 + t0 * 3);
        }
        m[2] = (squeeze_challenge(absorbing, 20));
        for (t0 = 0; t0 <= 13; t0++) {
            update_hash_point(proof[10 + t0 * 2], proof[11 + t0 * 2], absorbing, 1 + t0 * 3);
        }
        m[3] = (squeeze_challenge(absorbing, 43));
        m[4] = (squeeze_challenge(absorbing, 1));
        for (t0 = 0; t0 <= 9; t0++) {
            update_hash_point(proof[38 + t0 * 2], proof[39 + t0 * 2], absorbing, 1 + t0 * 3);
        }
        m[5] = (squeeze_challenge(absorbing, 31));
        for (t0 = 0; t0 <= 3; t0++) {
            update_hash_point(proof[58 + t0 * 2], proof[59 + t0 * 2], absorbing, 1 + t0 * 3);
        }
        m[6] = (squeeze_challenge(absorbing, 13));
        for (t0 = 0; t0 <= 70; t0++) {
            update_hash_scalar(proof[66 + t0 * 1], absorbing, 1 + t0 * 2);
        }
        m[7] = (squeeze_challenge(absorbing, 143));
        for (t0 = 0; t0 <= 3; t0++) {
            update_hash_point(proof[137 + t0 * 2], proof[138 + t0 * 2], absorbing, 1 + t0 * 3);
        }
        m[8] = (squeeze_challenge(absorbing, 13));
        m[9] = (
            mulmod(
                m[6],
                13446667982376394161563610564587413125564757801019538732601045199901075958935,
                q_mod
            )
        );
        m[10] = (
            mulmod(
                m[6],
                16569469942529664681363945218228869388192121720036659574609237682362097667612,
                q_mod
            )
        );
        m[11] = (
            mulmod(
                m[6],
                14803907026430593724305438564799066516271154714737734572920456128449769927233,
                q_mod
            )
        );
        m[12] = (fr_pow(m[6], 67108864));
        m[13] = (addmod(m[12], q_mod - 1, q_mod));
        m[14] = (
            mulmod(
                21888242545679039938882419398440172875981108180010270949818755658014750055173,
                m[13],
                q_mod
            )
        );
        t0 = (addmod(m[6], q_mod - 1, q_mod));
        m[14] = (fr_div(m[14], t0));
        m[15] = (
            mulmod(
                3495999257316610708652455694658595065970881061159015347599790211259094641512,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    14803907026430593724305438564799066516271154714737734572920456128449769927233,
                q_mod
            )
        );
        m[15] = (fr_div(m[15], t0));
        m[16] = (
            mulmod(
                12851378806584061886934576302961450669946047974813165594039554733293326536714,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    11377606117859914088982205826922132024839443553408109299929510653283289974216,
                q_mod
            )
        );
        m[16] = (fr_div(m[16], t0));
        m[17] = (
            mulmod(
                14638077285440018490948843142723135319134576188472316769433007423695824509066,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    3693565015985198455139889557180396682968596245011005461846595820698933079918,
                q_mod
            )
        );
        m[17] = (fr_div(m[17], t0));
        m[18] = (
            mulmod(
                18027939092386982308810165776478549635922357517986691900813373197616541191289,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    17329448237240114492580865744088056414251735686965494637158808787419781175510,
                q_mod
            )
        );
        m[18] = (fr_div(m[18], t0));
        m[19] = (
            mulmod(
                912591536032578604421866340844550116335029274442283291811906603256731601654,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    6047398202650739717314770882059679662647667807426525133977681644606291529311,
                q_mod
            )
        );
        m[19] = (fr_div(m[19], t0));
        m[20] = (
            mulmod(
                17248638560015646562374089181598815896736916575459528793494921668169819478628,
                m[13],
                q_mod
            )
        );
        t0 = (
            addmod(
                m[6],
                q_mod -
                    16569469942529664681363945218228869388192121720036659574609237682362097667612,
                q_mod
            )
        );
        m[20] = (fr_div(m[20], t0));
        t0 = (addmod(m[15], m[16], q_mod));
        t0 = (addmod(t0, m[17], q_mod));
        t0 = (addmod(t0, m[18], q_mod));
        m[15] = (addmod(t0, m[19], q_mod));
        t0 = (fr_mul_add(proof[74], proof[72], proof[73]));
        t0 = (fr_mul_add(proof[75], proof[67], t0));
        t0 = (fr_mul_add(proof[76], proof[68], t0));
        t0 = (fr_mul_add(proof[77], proof[69], t0));
        t0 = (fr_mul_add(proof[78], proof[70], t0));
        m[16] = (fr_mul_add(proof[79], proof[71], t0));
        t0 = (mulmod(proof[67], proof[68], q_mod));
        m[16] = (fr_mul_add(proof[80], t0, m[16]));
        t0 = (mulmod(proof[69], proof[70], q_mod));
        m[16] = (fr_mul_add(proof[81], t0, m[16]));
        t0 = (addmod(1, q_mod - proof[97], q_mod));
        m[17] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[100], proof[100], q_mod));
        t0 = (addmod(t0, q_mod - proof[100], q_mod));
        m[18] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(proof[100], q_mod - proof[99], q_mod));
        m[19] = (mulmod(t0, m[14], q_mod));
        m[21] = (mulmod(m[3], m[6], q_mod));
        t0 = (addmod(m[20], m[15], q_mod));
        m[15] = (addmod(1, q_mod - t0, q_mod));
        m[22] = (addmod(proof[67], m[4], q_mod));
        t0 = (fr_mul_add(proof[91], m[3], m[22]));
        m[23] = (mulmod(t0, proof[98], q_mod));
        t0 = (addmod(m[22], m[21], q_mod));
        m[22] = (mulmod(t0, proof[97], q_mod));
        m[24] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[21],
                q_mod
            )
        );
        m[25] = (addmod(proof[68], m[4], q_mod));
        t0 = (fr_mul_add(proof[92], m[3], m[25]));
        m[23] = (mulmod(t0, m[23], q_mod));
        t0 = (addmod(m[25], m[24], q_mod));
        m[22] = (mulmod(t0, m[22], q_mod));
        m[24] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[24],
                q_mod
            )
        );
        m[25] = (addmod(proof[69], m[4], q_mod));
        t0 = (fr_mul_add(proof[93], m[3], m[25]));
        m[23] = (mulmod(t0, m[23], q_mod));
        t0 = (addmod(m[25], m[24], q_mod));
        m[22] = (mulmod(t0, m[22], q_mod));
        m[24] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[24],
                q_mod
            )
        );
        t0 = (addmod(m[23], q_mod - m[22], q_mod));
        m[22] = (mulmod(t0, m[15], q_mod));
        m[21] = (
            mulmod(
                m[21],
                11166246659983828508719468090013646171463329086121580628794302409516816350802,
                q_mod
            )
        );
        m[23] = (addmod(proof[70], m[4], q_mod));
        t0 = (fr_mul_add(proof[94], m[3], m[23]));
        m[24] = (mulmod(t0, proof[101], q_mod));
        t0 = (addmod(m[23], m[21], q_mod));
        m[23] = (mulmod(t0, proof[100], q_mod));
        m[21] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[21],
                q_mod
            )
        );
        m[25] = (addmod(proof[71], m[4], q_mod));
        t0 = (fr_mul_add(proof[95], m[3], m[25]));
        m[24] = (mulmod(t0, m[24], q_mod));
        t0 = (addmod(m[25], m[21], q_mod));
        m[23] = (mulmod(t0, m[23], q_mod));
        m[21] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[21],
                q_mod
            )
        );
        m[25] = (addmod(proof[66], m[4], q_mod));
        t0 = (fr_mul_add(proof[96], m[3], m[25]));
        m[24] = (mulmod(t0, m[24], q_mod));
        t0 = (addmod(m[25], m[21], q_mod));
        m[23] = (mulmod(t0, m[23], q_mod));
        m[21] = (
            mulmod(
                4131629893567559867359510883348571134090853742863529169391034518566172092834,
                m[21],
                q_mod
            )
        );
        t0 = (addmod(m[24], q_mod - m[23], q_mod));
        m[21] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[104], m[3], q_mod));
        m[23] = (mulmod(proof[103], t0, q_mod));
        t0 = (addmod(proof[106], m[4], q_mod));
        m[23] = (mulmod(m[23], t0, q_mod));
        m[24] = (mulmod(proof[67], proof[82], q_mod));
        m[2] = (mulmod(0, m[2], q_mod));
        m[24] = (addmod(m[2], m[24], q_mod));
        m[25] = (addmod(m[2], proof[83], q_mod));
        m[26] = (addmod(proof[104], q_mod - proof[106], q_mod));
        t0 = (addmod(1, q_mod - proof[102], q_mod));
        m[27] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[102], proof[102], q_mod));
        t0 = (addmod(t0, q_mod - proof[102], q_mod));
        m[28] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[24], m[3], q_mod));
        m[24] = (mulmod(proof[102], t0, q_mod));
        m[25] = (addmod(m[25], m[4], q_mod));
        t0 = (mulmod(m[24], m[25], q_mod));
        t0 = (addmod(m[23], q_mod - t0, q_mod));
        m[23] = (mulmod(t0, m[15], q_mod));
        m[24] = (mulmod(m[14], m[26], q_mod));
        t0 = (addmod(proof[104], q_mod - proof[105], q_mod));
        t0 = (mulmod(m[26], t0, q_mod));
        m[26] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[109], m[3], q_mod));
        m[29] = (mulmod(proof[108], t0, q_mod));
        t0 = (addmod(proof[111], m[4], q_mod));
        m[29] = (mulmod(m[29], t0, q_mod));
        m[30] = (fr_mul_add(proof[82], proof[68], m[2]));
        m[31] = (addmod(proof[109], q_mod - proof[111], q_mod));
        t0 = (addmod(1, q_mod - proof[107], q_mod));
        m[32] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[107], proof[107], q_mod));
        t0 = (addmod(t0, q_mod - proof[107], q_mod));
        m[33] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[30], m[3], q_mod));
        t0 = (mulmod(proof[107], t0, q_mod));
        t0 = (mulmod(t0, m[25], q_mod));
        t0 = (addmod(m[29], q_mod - t0, q_mod));
        m[29] = (mulmod(t0, m[15], q_mod));
        m[30] = (mulmod(m[14], m[31], q_mod));
        t0 = (addmod(proof[109], q_mod - proof[110], q_mod));
        t0 = (mulmod(m[31], t0, q_mod));
        m[31] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[114], m[3], q_mod));
        m[34] = (mulmod(proof[113], t0, q_mod));
        t0 = (addmod(proof[116], m[4], q_mod));
        m[34] = (mulmod(m[34], t0, q_mod));
        m[35] = (fr_mul_add(proof[82], proof[69], m[2]));
        m[36] = (addmod(proof[114], q_mod - proof[116], q_mod));
        t0 = (addmod(1, q_mod - proof[112], q_mod));
        m[37] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[112], proof[112], q_mod));
        t0 = (addmod(t0, q_mod - proof[112], q_mod));
        m[38] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[35], m[3], q_mod));
        t0 = (mulmod(proof[112], t0, q_mod));
        t0 = (mulmod(t0, m[25], q_mod));
        t0 = (addmod(m[34], q_mod - t0, q_mod));
        m[34] = (mulmod(t0, m[15], q_mod));
        m[35] = (mulmod(m[14], m[36], q_mod));
        t0 = (addmod(proof[114], q_mod - proof[115], q_mod));
        t0 = (mulmod(m[36], t0, q_mod));
        m[36] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[119], m[3], q_mod));
        m[39] = (mulmod(proof[118], t0, q_mod));
        t0 = (addmod(proof[121], m[4], q_mod));
        m[39] = (mulmod(m[39], t0, q_mod));
        m[40] = (fr_mul_add(proof[82], proof[70], m[2]));
        m[41] = (addmod(proof[119], q_mod - proof[121], q_mod));
        t0 = (addmod(1, q_mod - proof[117], q_mod));
        m[42] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[117], proof[117], q_mod));
        t0 = (addmod(t0, q_mod - proof[117], q_mod));
        m[43] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[40], m[3], q_mod));
        t0 = (mulmod(proof[117], t0, q_mod));
        t0 = (mulmod(t0, m[25], q_mod));
        t0 = (addmod(m[39], q_mod - t0, q_mod));
        m[25] = (mulmod(t0, m[15], q_mod));
        m[39] = (mulmod(m[14], m[41], q_mod));
        t0 = (addmod(proof[119], q_mod - proof[120], q_mod));
        t0 = (mulmod(m[41], t0, q_mod));
        m[40] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[124], m[3], q_mod));
        m[41] = (mulmod(proof[123], t0, q_mod));
        t0 = (addmod(proof[126], m[4], q_mod));
        m[41] = (mulmod(m[41], t0, q_mod));
        m[44] = (fr_mul_add(proof[84], proof[67], m[2]));
        m[45] = (addmod(m[2], proof[85], q_mod));
        m[46] = (addmod(proof[124], q_mod - proof[126], q_mod));
        t0 = (addmod(1, q_mod - proof[122], q_mod));
        m[47] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[122], proof[122], q_mod));
        t0 = (addmod(t0, q_mod - proof[122], q_mod));
        m[48] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[44], m[3], q_mod));
        m[44] = (mulmod(proof[122], t0, q_mod));
        t0 = (addmod(m[45], m[4], q_mod));
        t0 = (mulmod(m[44], t0, q_mod));
        t0 = (addmod(m[41], q_mod - t0, q_mod));
        m[41] = (mulmod(t0, m[15], q_mod));
        m[44] = (mulmod(m[14], m[46], q_mod));
        t0 = (addmod(proof[124], q_mod - proof[125], q_mod));
        t0 = (mulmod(m[46], t0, q_mod));
        m[45] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[129], m[3], q_mod));
        m[46] = (mulmod(proof[128], t0, q_mod));
        t0 = (addmod(proof[131], m[4], q_mod));
        m[46] = (mulmod(m[46], t0, q_mod));
        m[49] = (fr_mul_add(proof[86], proof[67], m[2]));
        m[50] = (addmod(m[2], proof[87], q_mod));
        m[51] = (addmod(proof[129], q_mod - proof[131], q_mod));
        t0 = (addmod(1, q_mod - proof[127], q_mod));
        m[52] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[127], proof[127], q_mod));
        t0 = (addmod(t0, q_mod - proof[127], q_mod));
        m[53] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[49], m[3], q_mod));
        m[49] = (mulmod(proof[127], t0, q_mod));
        t0 = (addmod(m[50], m[4], q_mod));
        t0 = (mulmod(m[49], t0, q_mod));
        t0 = (addmod(m[46], q_mod - t0, q_mod));
        m[46] = (mulmod(t0, m[15], q_mod));
        m[49] = (mulmod(m[14], m[51], q_mod));
        t0 = (addmod(proof[129], q_mod - proof[130], q_mod));
        t0 = (mulmod(m[51], t0, q_mod));
        m[50] = (mulmod(t0, m[15], q_mod));
        t0 = (addmod(proof[134], m[3], q_mod));
        m[51] = (mulmod(proof[133], t0, q_mod));
        t0 = (addmod(proof[136], m[4], q_mod));
        m[51] = (mulmod(m[51], t0, q_mod));
        m[54] = (fr_mul_add(proof[88], proof[67], m[2]));
        m[2] = (addmod(m[2], proof[89], q_mod));
        m[55] = (addmod(proof[134], q_mod - proof[136], q_mod));
        t0 = (addmod(1, q_mod - proof[132], q_mod));
        m[56] = (mulmod(m[14], t0, q_mod));
        t0 = (mulmod(proof[132], proof[132], q_mod));
        t0 = (addmod(t0, q_mod - proof[132], q_mod));
        m[20] = (mulmod(m[20], t0, q_mod));
        t0 = (addmod(m[54], m[3], q_mod));
        m[3] = (mulmod(proof[132], t0, q_mod));
        t0 = (addmod(m[2], m[4], q_mod));
        t0 = (mulmod(m[3], t0, q_mod));
        t0 = (addmod(m[51], q_mod - t0, q_mod));
        m[2] = (mulmod(t0, m[15], q_mod));
        m[3] = (mulmod(m[14], m[55], q_mod));
        t0 = (addmod(proof[134], q_mod - proof[135], q_mod));
        t0 = (mulmod(m[55], t0, q_mod));
        m[4] = (mulmod(t0, m[15], q_mod));
        t0 = (fr_mul_add(m[5], 0, m[16]));
        t0 = (
            fr_mul_add_mt(
                m,
                m[5],
                24064768791442479290152634096194013545513974547709823832001394403118888981009,
                t0
            )
        );
        t0 = (fr_mul_add_mt(m, m[5], 4704208815882882920750, t0));
        m[2] = (fr_div(t0, m[13]));
        m[3] = (mulmod(m[8], m[8], q_mod));
        m[4] = (mulmod(m[3], m[8], q_mod));
        (t0, t1) = (ecc_mul(proof[143], proof[144], m[4]));
        (t0, t1) = (ecc_mul_add_pm(m, proof, 281470825071501, t0, t1));
        (m[14], m[15]) = (ecc_add(t0, t1, proof[137], proof[138]));
        m[5] = (mulmod(m[4], m[11], q_mod));
        m[11] = (mulmod(m[4], m[7], q_mod));
        m[13] = (mulmod(m[11], m[7], q_mod));
        m[16] = (mulmod(m[13], m[7], q_mod));
        m[17] = (mulmod(m[16], m[7], q_mod));
        m[18] = (mulmod(m[17], m[7], q_mod));
        m[19] = (mulmod(m[18], m[7], q_mod));
        t0 = (mulmod(m[19], proof[135], q_mod));
        t0 = (fr_mul_add_pm(m, proof, 79227007564587019091207590530, t0));
        m[20] = (fr_mul_add(proof[105], m[4], t0));
        m[10] = (mulmod(m[3], m[10], q_mod));
        m[20] = (fr_mul_add(proof[99], m[3], m[20]));
        m[9] = (mulmod(m[8], m[9], q_mod));
        m[21] = (mulmod(m[8], m[7], q_mod));
        for (t0 = 0; t0 < 8; t0++) {
            m[22 + t0 * 1] = (mulmod(m[21 + t0 * 1], m[7 + t0 * 0], q_mod));
        }
        t0 = (mulmod(m[29], proof[133], q_mod));
        t0 = (fr_mul_add_pm(m, proof, 1461480058012745347196003969984389955172320353408, t0));
        m[20] = (addmod(m[20], t0, q_mod));
        m[3] = (addmod(m[3], m[21], q_mod));
        m[21] = (mulmod(m[7], m[7], q_mod));
        m[30] = (mulmod(m[21], m[7], q_mod));
        for (t0 = 0; t0 < 50; t0++) {
            m[31 + t0 * 1] = (mulmod(m[30 + t0 * 1], m[7 + t0 * 0], q_mod));
        }
        m[81] = (mulmod(m[80], proof[90], q_mod));
        m[82] = (mulmod(m[79], m[12], q_mod));
        m[83] = (mulmod(m[82], m[12], q_mod));
        m[12] = (mulmod(m[83], m[12], q_mod));
        t0 = (fr_mul_add(m[79], m[2], m[81]));
        t0 = (
            fr_mul_add_pm(
                m,
                proof,
                28637501128329066231612878461967933875285131620580756137874852300330784214624,
                t0
            )
        );
        t0 = (
            fr_mul_add_pm(
                m,
                proof,
                21474593857386732646168474467085622855647258609351047587832868301163767676495,
                t0
            )
        );
        t0 = (
            fr_mul_add_pm(
                m,
                proof,
                14145600374170319983429588659751245017860232382696106927048396310641433325177,
                t0
            )
        );
        t0 = (fr_mul_add_pm(m, proof, 18446470583433829957, t0));
        t0 = (addmod(t0, proof[66], q_mod));
        m[2] = (addmod(m[20], t0, q_mod));
        m[19] = (addmod(m[19], m[54], q_mod));
        m[20] = (addmod(m[29], m[53], q_mod));
        m[18] = (addmod(m[18], m[51], q_mod));
        m[28] = (addmod(m[28], m[50], q_mod));
        m[17] = (addmod(m[17], m[48], q_mod));
        m[27] = (addmod(m[27], m[47], q_mod));
        m[16] = (addmod(m[16], m[45], q_mod));
        m[26] = (addmod(m[26], m[44], q_mod));
        m[13] = (addmod(m[13], m[42], q_mod));
        m[25] = (addmod(m[25], m[41], q_mod));
        m[11] = (addmod(m[11], m[39], q_mod));
        m[24] = (addmod(m[24], m[38], q_mod));
        m[4] = (addmod(m[4], m[36], q_mod));
        m[23] = (addmod(m[23], m[35], q_mod));
        m[22] = (addmod(m[22], m[34], q_mod));
        m[3] = (addmod(m[3], m[33], q_mod));
        m[8] = (addmod(m[8], m[32], q_mod));
        (t0, t1) = (ecc_mul(proof[143], proof[144], m[5]));
        (t0, t1) = (
            ecc_mul_add_pm(
                m,
                proof,
                10933423423422768024429730621579321771439401845242250760130969989159573132066,
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add_pm(m, proof, 1461486238301980199876269201563775120819706402602, t0, t1)
        );
        (t0, t1) = (
            ecc_mul_add(
                6142817583611318572656790694718211788114764931516417326618203124458942393512,
                4646821324997622891656299786985648251755771687303265562041594443280268941435,
                m[78],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                1394140441997098469277990129028168392464863717319893157779376066079215205995,
                6479070357060105565230663751309877725893693760785866947291774767445218580725,
                m[77],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                1505982605826495538337084731512603575610962644433829788142952088732637275900,
                15638675134091979370843664702271623759528460495807814967966143101334975019218,
                m[76],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                2920562342430032392513332641702835464035838604893227465222109896344556432781,
                1233200019755399369644963656297879273471574905205481556774126313083620669188,
                m[75],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                4793770747262543221162957134245718273660743968167442305148839925764721384385,
                16491365131910875890473113316915135247069549590998256855917281930732102052146,
                m[74],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                12073029823146420358357755459466510541167929997834912707160306328645716684634,
                7002579881281064115771377119487732340828562242983846592023681036449210169941,
                m[73],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                5422170891120229182360564594866246906567981360038071999127508208070564034524,
                14722029885921976755274052080011416898514630484317773275415621146460924728182,
                m[72],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                9768037088022160987792529895161170380140242871617764963181107834401821842732,
                18832575845000440794371969135482601814248633755836923521592930147295616428911,
                m[71],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                18451207565454686459225553564649439057698581050443267052774483067774590965003,
                4419693978684087696088612463773850574955779922948673330581664932100506990694,
                m[70],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                10955051564000848234174555727796659616779146634502155798906042850270306999028,
                5044157639930088703193160205056600784986917761050014097511294717703335354756,
                m[69],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                5422170891120229182360564594866246906567981360038071999127508208070564034524,
                14722029885921976755274052080011416898514630484317773275415621146460924728182,
                m[68],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                13105550014728729004155036996412783545950841894097753169739134984597847652697,
                770569099300255260688332420518941166628824859946965110511956314794583528694,
                m[67],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                21537162186981550637121053147454964150809482185492418377558290311964245821909,
                2173324946696678910860567153502925685634606622474439126082176533839311460335,
                m[66],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                19260083276107475178966891282754197624211455736673124446998411091227828289553,
                2570537878389498753277218315004771614025811703544923427862807029802660958099,
                m[65],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                8845661238106812206461459197564326952814344666903203623661463593134263896085,
                9199661166487667889188104072051840793570190455147636185909257185981915686939,
                m[64],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                1247301910598036969079443951451711450239021207173438336600746303301923637619,
                12452008890862978663347524597422639287935789259006166244086331584833725627011,
                m[63],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                5604610499897386861255889949519877143182190495525912738313285084277909443823,
                10846093502024381162484878000759356250253658533536005705881187609138195832747,
                m[62],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                21242518271599825569916643188427645420543445585556474469805024475250407545878,
                17465592062378925051184078024251365114151104586351962146267321196670845041213,
                m[61],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                4394779370836082712406958856077566946471251024945837930292850369228732540367,
                14055556608051250377070851641965610024993199964737457704527984709839114705559,
                m[60],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                10819795219762681902376301835590122215694186866378606265080686339562560138385,
                19966781410778348947296831539481353126793783310593348439260795338950610476576,
                m[59],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                21764175739688726125083670197919870409620040219415465823837999071958318298226,
                10674380430548790992549153589666513639625528080118858035634397593415316259864,
                m[58],
                t0,
                t1
            )
        );
        (t0, t1) = (
            ecc_mul_add(
                14305536278729037949733395958634241814626316284509904005683590354628543981750,
                4559470715733364509263937153338912572385508047696014198795854165844220686033,
                m[57],
                t0,
                t1
            )
        );
        (t0, t1) = (ecc_mul_add(M_56_PX_VALUE, M_56_PY_VALUE, m[56], t0, t1));
        (t0, t1) = (
            ecc_mul_add_pm(
                m,
                proof,
                6277008573546246765208814532330797927747086570010716419876,
                t0,
                t1
            )
        );
        (m[0], m[1]) = (ecc_add(t0, t1, m[0], m[1]));
        (t0, t1) = (ecc_mul(1, 2, m[2]));
        (m[0], m[1]) = (ecc_sub(m[0], m[1], t0, t1));
        return (m[14], m[15], m[0], m[1]);
    }

    function verify(
        uint256[] calldata proof,
        uint256[] calldata target_circuit_final_pair,
        bytes32 publicInputHash
    ) public view returns (bool) {
        uint256[6] memory instances;
        instances[0] = target_circuit_final_pair[0] & ((1 << 136) - 1);
        instances[1] =
            (target_circuit_final_pair[0] >> 136) +
            ((target_circuit_final_pair[1] & 1) << 136);
        instances[2] = target_circuit_final_pair[2] & ((1 << 136) - 1);
        instances[3] =
            (target_circuit_final_pair[2] >> 136) +
            ((target_circuit_final_pair[3] & 1) << 136);

        instances[4] = uint256(publicInputHash) >> (8 * 16);
        instances[5] = uint256(publicInputHash) & uint256(2**128 - 1);

        uint256 x0 = 0;
        uint256 x1 = 0;
        uint256 y0 = 0;
        uint256 y1 = 0;

        G1Point[] memory g1_points = new G1Point[](2);
        G2Point[] memory g2_points = new G2Point[](2);

        (x0, y0, x1, y1) = get_wx_wg(proof, instances);
        g1_points[0].x = x0;
        g1_points[0].y = y0;
        g1_points[1].x = x1;
        g1_points[1].y = y1;
        g2_points[0] = get_verify_circuit_g2_s();
        g2_points[1] = get_verify_circuit_g2_n();

        if (!pairing(g1_points, g2_points)) {
            return false;
        }

        g1_points[0].x = target_circuit_final_pair[0];
        g1_points[0].y = target_circuit_final_pair[1];
        g1_points[1].x = target_circuit_final_pair[2];
        g1_points[1].y = target_circuit_final_pair[3];
        g2_points[0] = get_target_circuit_g2_s();
        g2_points[1] = get_target_circuit_g2_n();

        if (!pairing(g1_points, g2_points)) {
            return false;
        }

        return true;
    }
}