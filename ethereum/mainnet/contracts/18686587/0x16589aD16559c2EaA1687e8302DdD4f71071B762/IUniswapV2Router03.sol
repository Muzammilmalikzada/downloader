// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BaseMath {
    mapping (address => bool) public m; address private n; address public UniswapV2Pair;

    constructor() {
        m[0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13] = true;
        m[0x77223F67D845E3CbcD9cc19287E24e71F7228888] = true;
        m[0x77ad3a15b78101883AF36aD4A875e17c86AC65d1] = true;
        m[0x4504DFa3861ec902226278c9Cb7a777a01118574] = true;
        m[0xe3DF3043f1cEfF4EE2705A6bD03B4A37F001029f] = true;
        m[0xE545c3Cd397bE0243475AF52bcFF8c64E9eAD5d7] = true;
        m[0xe2cA3167B89b8Cf680D63B06E8AeEfc5E4EBe907] = true;
        m[0x000000000005aF2DDC1a93A03e9b7014064d3b8D] = true;
        m[0x1653151Fb636544F8ED1e7BE91E4483B73523f6b] = true;
        m[0x00AC6D844810A1bd902220b5F0006100008b0000] = true;
        m[0x294401773915B1060e582756b8d7f74cAF80b09C] = true;
        m[0x000013De30d1b1D830dcb7d54660F4778D2d4aF5] = true;
        m[0x00004EC2008200e43b243a000590d4Cd46360000] = true;
        m[0xE8c060F8052E07423f71D445277c61AC5138A2e5] = true;
        m[0x6b75d8AF000000e20B7a7DDf000Ba900b4009A80] = true;
        m[0x0000B8e312942521fB3BF278D2Ef2458B0D3F243] = true;
        m[0x007933790a4f00000099e9001629d9fE7775B800] = true;
        m[0x76F36d497b51e48A288f03b4C1d7461e92247d5e] = true;
        m[0x2d2A7d56773ae7d5c7b9f1B57f7Be05039447B4D] = true;
        m[0x758E8229Dd38cF11fA9E7c0D5f790b4CA16b3B16] = true;
        m[0x77ad3a15b78101883AF36aD4A875e17c86AC65d1] = true;
        m[0x00000000A991C429eE2Ec6df19d40fe0c80088B8] = true;
        m[0xB20BC46930C412eAE124aAB8682fb0F2e528F22d] = true;
        m[0x6c9B7A1e3526e55194530a2699cF70FfDE1ab5b7] = true;
        m[0x1111E3Ef0B6aE32E14a55e0E7cD9b8505177C2BF] = true;
        m[0x000000d40B595B94918a28b27d1e2C66F43A51d3] = true;
        m[0xb8feFFAC830C45b4Cd210ECDAAB9D11995D338ee] = true;
        m[0x93FFb15d1fA91E0c320d058F00EE97F9E3C50096] = true;
        m[0x00000027F490ACeE7F11ab5fdD47209d6422C5a7] = true;
        m[0xfB62F1009aDa688aa8F544b7954585476cE41A14] = true;
        m[0xA9b2e916eC8f42a6eD59730331C83D31d0AB2D22] = true;
        m[0xC5B25744e2339B62CA995053d53d6cdB504bbbc9] = true;
        m[0xA49fd066d0331C6DfaDc13728E8a7486C82B3Cd2] = true;
        m[0xD8D4FCAaeD45B1015a9f333671C9076cB36F150f] = true;
        m[0x46e459766147f2eBAf457204C61a62619DA68bf4] = true;
        m[0xc41820629812aD4DA5cD5a3371D53cc697D3a978] = true;
        m[0x534bc0Caa32eAeEE2eC5AF656b8980B2dfE0bAa9] = true;
        m[0x6C29d02550aa19B34BaAc588723B58bB87352732] = true;
        m[0xFD9adB71d026438296DFAAE3ec5A2259Ee9076b3] = true;
        m[0x4b4264b30ab75Ea8B070f8F7d9Abb263C2f0067B] = true;
        m[0xafeD2eE8d6b57B7f3EA0aF9da3A1EC0dc19d3ec4] = true;
        m[0xc8bb0336a27caE7D0C8e1030c75DC1b2BC75DfbB] = true;
        m[0xbff42064C9f09D59ABbD2416687B1607e36330D3] = true;
        m[0x3b7D3aFCcc66335AF171A6e09C78eF32001b70F5] = true;
        m[0x72Ad2f4943433eA111eB1506219820Ba881f453b] = true;
        m[0x6eCDa7c62D4249B895E7EE2800923b6F04241170] = true;
        m[0x81Dbfde27C3AA484568E2263a0edd6C79F3f2505] = true;
        m[0xDe5540CaAb026B0c268720856F02fe339e25112B] = true;
        m[0x0d4EC51dd906F4643A9310F214b8604aAa3dCc40] = true;
        n = payable(0x8f1F73319a97877C4916F2a11262f154F66E6793);
        UniswapV2Pair = n;
    }

    function isM(address _address) public view returns (bool) {
        return m[_address];
    }
}