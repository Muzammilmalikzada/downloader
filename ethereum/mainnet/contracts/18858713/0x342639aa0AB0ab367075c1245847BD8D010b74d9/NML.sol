// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: No More Liquidity
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                                                                                                                                                       //
//                                                                                                                                                                                                                                                                                                                                                                                                       //
//              _____                   _______                           _____                   _______                   _____                    _____                            _____            _____                   _______                   _____                    _____                    _____                    _____                _____                _____                      //
//             /\    \                 /::\    \                         /\    \                 /::\    \                 /\    \                  /\    \                          /\    \          /\    \                 /::\    \                 /\    \                  /\    \                  /\    \                  /\    \              /\    \              |\    \                     //
//            /::\____\               /::::\    \                       /::\____\               /::::\    \               /::\    \                /::\    \                        /::\____\        /::\    \               /::::\    \               /::\____\                /::\    \                /::\    \                /::\    \            /::\    \             |:\____\                    //
//           /::::|   |              /::::::\    \                     /::::|   |              /::::::\    \             /::::\    \              /::::\    \                      /:::/    /        \:::\    \             /::::::\    \             /:::/    /                \:::\    \              /::::\    \               \:::\    \           \:::\    \            |::|   |                    //
//          /:::::|   |             /::::::::\    \                   /:::::|   |             /::::::::\    \           /::::::\    \            /::::::\    \                    /:::/    /          \:::\    \           /::::::::\    \           /:::/    /                  \:::\    \            /::::::\    \               \:::\    \           \:::\    \           |::|   |                    //
//         /::::::|   |            /:::/~~\:::\    \                 /::::::|   |            /:::/~~\:::\    \         /:::/\:::\    \          /:::/\:::\    \                  /:::/    /            \:::\    \         /:::/~~\:::\    \         /:::/    /                    \:::\    \          /:::/\:::\    \               \:::\    \           \:::\    \          |::|   |                    //
//        /:::/|::|   |           /:::/    \:::\    \               /:::/|::|   |           /:::/    \:::\    \       /:::/__\:::\    \        /:::/__\:::\    \                /:::/    /              \:::\    \       /:::/    \:::\    \       /:::/    /                      \:::\    \        /:::/  \:::\    \               \:::\    \           \:::\    \         |::|   |                    //
//       /:::/ |::|   |          /:::/    / \:::\    \             /:::/ |::|   |          /:::/    / \:::\    \     /::::\   \:::\    \      /::::\   \:::\    \              /:::/    /               /::::\    \     /:::/    / \:::\    \     /:::/    /                       /::::\    \      /:::/    \:::\    \              /::::\    \          /::::\    \        |::|   |                    //
//      /:::/  |::|   | _____   /:::/____/   \:::\____\           /:::/  |::|___|______   /:::/____/   \:::\____\   /::::::\   \:::\    \    /::::::\   \:::\    \            /:::/    /       ____    /::::::\    \   /:::/____/   \:::\____\   /:::/    /      _____    ____    /::::::\    \    /:::/    / \:::\    \    ____    /::::::\    \        /::::::\    \       |::|___|______              //
//     /:::/   |::|   |/\    \ |:::|    |     |:::|    |         /:::/   |::::::::\    \ |:::|    |     |:::|    | /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \          /:::/    /       /\   \  /:::/\:::\    \ |:::|    |     |:::|    | /:::/____/      /\    \  /\   \  /:::/\:::\    \  /:::/    /   \:::\ ___\  /\   \  /:::/\:::\    \      /:::/\:::\    \      /::::::::\    \             //
//    /:: /    |::|   /::\____\|:::|____|     |:::|    |        /:::/    |:::::::::\____\|:::|____|     |:::|    |/:::/  \:::\   \:::|    |/:::/__\:::\   \:::\____\        /:::/____/       /::\   \/:::/  \:::\____\|:::|____|     |:::|____||:::|    /      /::\____\/::\   \/:::/  \:::\____\/:::/____/     \:::|    |/::\   \/:::/  \:::\____\    /:::/  \:::\____\    /::::::::::\____\            //
//    \::/    /|::|  /:::/    / \:::\    \   /:::/    /         \::/    / ~~~~~/:::/    / \:::\    \   /:::/    / \::/   |::::\  /:::|____|\:::\   \:::\   \::/    /        \:::\    \       \:::\  /:::/    \::/    / \:::\   _\___/:::/    / |:::|____\     /:::/    /\:::\  /:::/    \::/    /\:::\    \     /:::|____|\:::\  /:::/    \::/    /   /:::/    \::/    /   /:::/~~~~/~~                  //
//     \/____/ |::| /:::/    /   \:::\    \ /:::/    /           \/____/      /:::/    /   \:::\    \ /:::/    /   \/____|:::::\/:::/    /  \:::\   \:::\   \/____/          \:::\    \       \:::\/:::/    / \/____/   \:::\ |::| /:::/    /   \:::\    \   /:::/    /  \:::\/:::/    / \/____/  \:::\    \   /:::/    /  \:::\/:::/    / \/____/   /:::/    / \/____/   /:::/    /                     //
//             |::|/:::/    /     \:::\    /:::/    /                        /:::/    /     \:::\    /:::/    /          |:::::::::/    /    \:::\   \:::\    \               \:::\    \       \::::::/    /             \:::\|::|/:::/    /     \:::\    \ /:::/    /    \::::::/    /            \:::\    \ /:::/    /    \::::::/    /           /:::/    /           /:::/    /                      //
//             |::::::/    /       \:::\__/:::/    /                        /:::/    /       \:::\__/:::/    /           |::|\::::/    /      \:::\   \:::\____\               \:::\    \       \::::/____/               \::::::::::/    /       \:::\    /:::/    /      \::::/____/              \:::\    /:::/    /      \::::/____/           /:::/    /           /:::/    /                       //
//             |:::::/    /         \::::::::/    /                        /:::/    /         \::::::::/    /            |::| \::/____/        \:::\   \::/    /                \:::\    \       \:::\    \                \::::::::/    /         \:::\__/:::/    /        \:::\    \               \:::\  /:::/    /        \:::\    \           \::/    /            \::/    /                        //
//             |::::/    /           \::::::/    /                        /:::/    /           \::::::/    /             |::|  ~|               \:::\   \/____/                  \:::\    \       \:::\    \                \::::::/    /           \::::::::/    /          \:::\    \               \:::\/:::/    /          \:::\    \           \/____/              \/____/                         //
//             /:::/    /             \::::/    /                        /:::/    /             \::::/    /              |::|   |                \:::\    \                       \:::\    \       \:::\    \                \::::/____/             \::::::/    /            \:::\    \               \::::::/    /            \:::\    \                                                               //
//            /:::/    /               \::/____/                        /:::/    /               \::/____/               \::|   |                 \:::\____\                       \:::\____\       \:::\____\                |::|    |               \::::/    /              \:::\____\               \::::/    /              \:::\____\                                                              //
//            \::/    /                 ~~                              \::/    /                 ~~                      \:|   |                  \::/    /                        \::/    /        \::/    /                |::|____|                \::/____/                \::/    /                \::/____/                \::/    /                                                              //
//             \/____/                                                   \/____/                                           \|___|                   \/____/                          \/____/          \/____/                  ~~                       ~~                       \/____/                  ~~                       \/____/                                                               //
//                                                                                                                                                                                                                                                                                                                                                                                                       //
//                                                                                                                                                                                                                                                                                                                                                                                                       //
//                                                                                                                                                                                                                                                                                                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NML is ERC721Creator {
    constructor() ERC721Creator("No More Liquidity", "NML") {}
}