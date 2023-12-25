// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 𝚙𝚘𝚜𝚜𝚒𝚋𝚒𝚕𝚒𝚝𝚒𝚎𝚜
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΦ΅΅΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΡ΅΄΄;ίψχ΄΄΄ΫΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΝ΅΄΄΄ιί;ρΪ΄΄χΪχ;΄΄΅ΨΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΦ΅΅΄΄;ί;χΦΪΪΓ΄΄΄ΪΪψχ;Ϊχ;΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΡ΅΄΄;ί΄χΦΦΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪώχ;ψχ΄΄΄ΫΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΝ΅΄΄΄ιί;ρΦΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪψχΪχ;΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪώ΅΅΄΄;ί;χΦΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;Ϊχ;΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΡ΅΄΄;ί΄χΦΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪώχ;ψχ΄΄΅ΫΦΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΫ΅΄΄΄;ί;ωΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχΪχ;΄΄΅ΨΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓψχ΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΜ΅΄΄΄ιίΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄ίΪχ;΄΄΅ΨΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪβ΅΅΄΄;ί;;΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄;Ϊψχ;ώχ;΄΄ΫΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΦΡ΅΄΄;ί΄χΦΪΪ΄΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄;ΪΪΪΪΪψω;ψω΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΦ΅΄΄΄ί;χώΦΪΪΪΪΪ΄΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄;ΪΪΪΪΪΪΝ΅΄΄΄ιί;ΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪχ;΄΄΅ΨΪΪΪΪΪΪΪ΄΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄;ΪΪΦΡ΅΄΄;ί;χΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;ώχ;΄΄΅ΦΪΪΪ΄΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄΄Ϋ΅΄΄;ί;χΦΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;ώχ΄΄΅Ϋ΄΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΓ΄Γ΄ιί;ρΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψψ;Ϊψ΄Ϋ΄΄ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪχ;ψχ΄΄΅ΫψΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΜ΅΄΄΄ί΄;ΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪψψ;Ϊχ;΄΄΅ΨΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΫ΅΅΄΄;ί;ρΦΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪώχ;ώχ;΄΄ΫΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΦΡ΅΄΄;ϊ΄χΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;ψχ΄΄΅ΫΪΪΪΪΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΪΪΪΪΜ΅΄΄;ί΄;ώΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;Ϊχ;΄΄΅ΨΪΪΪΪΪΪΪΓ΄΄΄ΪΪΪΪΪΪΪΫ΅΅΄΄;ί;ρΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ;ώχ;΄΄ΫΦΪΪΪΓ΄΄΄ΪΪΪΦΡ΅΄΄;ϊ΄χΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψχ΄ψχ΄΄΅ΫΓ΄΄΄Μ΅΄΄΄ί;;ώΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪψψ;Ϊχ;;΄΄Γ΄;ί;ρΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪώχ;΄΄΄χΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΦΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//        ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ victojoy ΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪΪ    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract possibilities is ERC721Creator {
    constructor() ERC721Creator(unicode"𝚙𝚘𝚜𝚜𝚒𝚋𝚒𝚕𝚒𝚝𝚒𝚎𝚜", "possibilities") {}
}