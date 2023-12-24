// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Absurdities
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                    //
//                                                                                                                                                    //
//                                                                                                                                                    //
//                                                                         --                                                                         //
//                                                        .               .66.               .                                                        //
//                                                        *R_             O99O             _R*                                                        //
//                                                        *99r.          ^9999^          .r99*                                                        //
//                                                        *9996*  ..._= -999999- =_...  *6999*                                                        //
//                                                        *99999B=_R99O.39966993.O99R_=B99999*                                                        //
//                                         =O+,         ,.*9996999b_^B.b999^^999b.B^_b9996999*.,         ,+O=                                         //
//                                          O99Ro-   -r39-+999oo9999* =9996..6999= *9999oo999+-93r-   -oR99O                                          //
//                                           B99996b*+oO6-+999O +699O..b99o  o99b..O996+ O999+-6Oo+*b69999B                                           //
//                                           _99999996O^*.=3996  ,R99= ^99_  _99^ =99R,  6993=.*^O69999999_                                           //
//                                            *999B^B9999+  B99=  ,9O   ,b6**6b,   O9,  =99B  +9999B^B999*                                            //
//                                         .oB b999r -b699O ,+bBR^R3      -33-      3RoRBb+, O996b- r999b Bo.                                         //
//                              -=_..     ,O99R 3999b   +69.   .-o6o.  ._-*33*-_.  .o6o-.   .93+   b9993 O99O,     .._=-                              //
//                              ,r9963BObro^**^,.ob99B_. b9      _33r+rRr*+--+*rRr+r33_      9b ._B99bo.,^**^orbOB3699r,                              //
//                                _O999999999996=. *rOORO36_.,=*++_ ,r+.        .+r, _++*=,._63OROOr* .=699999999999O_                                //
//                                  =B9996boO39999O     . r9R^-.   ,R_            _R,   .-^R9r .     O99993Oob6999B=                                  //
//                                   .*6996b-  _=o9o     -b*.      ^*  .,_,__,_,.  *^      .*b-     o9o=_  -b6996*.                                   //
//                                  ,3r-r9999R=   r9=  ,o^.        ro+*++-^RR^-++*+or        .^o,  =9r   =R9999r-r3,                                  //
//                                  O96O,,rrb99BRROOOOBb_       .+^*B-   =b..b=   -B*^+.       _bBOOOORRB99brr,,O69O                                  //
//                                ._***^rr_..,,,.    3O        *o=  _r+.*o    o*.+r_  =o*        O3    .,,,.._rr^***_.                                //
//                        _*rbORB369999999999R_     _r       ,b+      =OO+=--=+OO=      +b,       r_     _R999999999963BRObr*_                        //
//                        .=oB9999999Rb^***^*r3r,  .b,      _R_       bR*o*==*o*Rb       _R_      ,b.  ,r3r*^***^bR9999999Bo=.                        //
//                            .=rB9999Bb^-.   +96^O6^       R_      .Rb,        ,bR.      _R       ^6O^69+   .-^bB9999Br=.                            //
//                                =*b3999999BBO^_,r6,      +^      _B=  absurdist =B_      ^+      ,6r,_^OBB9999993b*=                                //
//                                BBr*=^*=*o=.     r.     .r*--_, -Br    runtime   rB- ,_--*r.     .r     .=o*=*^=*rBB                                //
//                                33b*-*+-+^-      o.  .+^+O*_-=+ORr^      art     ^rRO+=-_*O+^+.  .o      -^+-+*-*b33                                //
//                                =*r3999999BBO*,,o6, =b=. +^   ^^,^3_      .     _3^,^^   *+ .=b= ,6o,,*OBB9999993r*=                                //
//                             -oB69993O^=,   *96^R9+_O.   .R. r+   _3+.        .+3_   +r .R.   .O_+9R^69*   ,=^O39996Bo-                             //
//                        .-^R9999999Rr^*++++^3b,  ,rO_     -Ob^,__-,bOrb^=--=^brOb,-__,^bO-     _Or,  ,b3^++++*^rR9999999R^-.                        //
//                        -^bORB3699999999999B-     _3.      -B*--==-b*_++====++_*b-==--*B-      .3_     -B9999999999963BROb^-                        //
//                               .,-***obb-.,,..     3R       .^^,  _b            b_  ,^^.       R3     ..,,.-bbo***-,.                               //
//                                  O63O,,oor99BRRbbbR3O=       ,*ooO,            ,Ooo*,       =O3RbbbRRB99roo,,O36O                                  //
//                                  ,6b-r9999B*   r9+  _OR*--_--=*^+=**+=-_____=+**=+^*=--_--*RO_  +9r   *B9999r-b6,                                  //
//                                   .+3996b-  ,-^9o     =b^_____.    .,_--==--_,.    ._____^b=     o9^-,  -b6993+.                                   //
//                                  =R9996bobB6999R       r9b=,                          ,=b9r       R9996Bbob6999R=                                  //
//                                ,b999999999999+, +obOOO36_,_+*+-.                  .-+*+_,_63OOObo+ ,+999999999999b,                                //
//                              ,r99963ROrr^**^_.^r99B-, O9     .-BR^=--_,,..,,_--=^RB-.     9O ,-B99r^._^**^rrOR36999r,                              //
//                              -+-,.     ,O69R B999O   =39.    _^6r,.,_-=+BB+=-_,.,r6^_    .93=   O999B R96O,     .,-+-                              //
//                                         .r3.r999b _r399R .=rBRoBB      _66_      BBoRBr=. R993r_ b999r.3r.                                         //
//                                            +999B^R9999+  R99+  ,9O   ,r6^^6r,   O9,  +99R  +9999R^B999+                                            //
//                                           ,99999999Ro*.-B996. ,O99= *69-  -96* =99O, .699B-.*oR99999999,                                           //
//                                           B99996O^*ob3-+999R =699O. b99^  ^99b .O996= R999+-3bo*^O69999B                                           //
//                                          b99Br=.  -b69=+999^^9999^ =9996..6999= ^9999^^999+=96b-  .=rB99b                                          //
//                                         =O*_         _.*9996999O-*R O999**999O R*-O9996999*._         ,*O=                                         //
//                                                        *999993+_R99O.69966996.O99R_+399999*                                                        //
//                                                        *9996^  .,,_+ -999999- +_,,.  ^6999*                                                        //
//                                                        *99b,          o9999o          ,b99*                                                        //
//                                                        *B-             R99R             -B^                                                        //
//                                                        ,               .66.               ,                                                        //
//                                                                         ==                                                                         //
//                                                                                                                                                    //
//                                                                                                                                                    //
//                                                                                                                                                    //
//                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ABSRD is ERC1155Creator {
    constructor() ERC1155Creator("Absurdities", "ABSRD") {}
}
