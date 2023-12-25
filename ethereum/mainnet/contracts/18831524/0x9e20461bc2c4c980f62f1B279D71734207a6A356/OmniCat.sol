//                                                       @@@@                                     
//                      @@@@@                         @@%##*%@                                    
//                     @@+*+*%@@                    @@#+=+--=%@                                   
//                     @*--=+--*%@@ @@@@@@@@@@@@@@@%#=-+*=---%@                                   
//                    @@+--=+*---=#%#*++===========---+*==---*@@                                  
//                    @@=---===--------------:---------------=@@                                  
//                    @@=--------------:.:--:.::-----------=+=%@        ~lmeow~                          
//                    @@+-+------------:..:-:..:--------------=%@@                                
//                    @@*-------------:..........:--------------=#@@                              
//                  @@%=---------=*++=...........*@#=%%++---------+%@                             
//                  @#=-------=#%%%#%@*.........:%#@@@%*------------%@@                           
//                 @#=----------*%@@@#-...-+=+:...-=---=======-------#@@                          
//                @@=------====-::::........*........:--====+++=------#@@                         
//               @@+--------==--:...........+:............:---=-----:.=%@                         
//               @%::-------:........+-...-#-+#=::=#+:.....:--------:..*@                         
//              @@*..------:........::::-+=----+-::..........:---:.....=%@                        
//             @@%=..:::--:................::::........................-+#@@                      
//            @%**-.....:.............................................:---=%@@                    
//          @@#+==--.................................................:------#@@                   
//         @@#=------:......:::.........................::.........:---------#@                   
//        @@*==-------:.......::::::...............:::::..........:-----------%@                  
//       @@#+=-----------.........::---------------::...........:---:..:------=%@                 
//       @%+==------:.::---:..........:::::::::::.............::::::-----------*@@                
//      @@#+==---------::......................................:---------------=@@                
//      @@*==--------------:................................:-++----------------%@@               
//     @@#+==-------------=+-:............................:=*=------------------=%@               
//     @%+====--------------++-:.........................-*+---------------------*@@              
//    @@+=======-------------=#=:.......................-*+-------------==-------=%@              
//    @#=======+=--------------%+:......................-%*----------=+*=---------*@@             
//   @@+=======+++=------------=%-:.....................-*#*+-=--==+##+=----------+@@             
//   @%==========+##+=-------===%-:.....................:-+%###*###===------::...:+%@             
//  @@#============++#*+======#%=::......................:::-----:::.::::::......:=%@             
//  @@*==-------===----+###%%#+-::..........................::::................:=*%@             
//  @@#++----------------------::..........................................:::---+#@@             
//   @%+++----------------::::........................................:----------+#@@             
//   @%+++===---------::..............................................:----------+%@              
//   @@=========------:.........................................................:=%@              
//   @@+==-------------:........................................................-=@@@             
//    @#==--------------:......................................................:-#%#%@@           
//    @@+==--------------:.........................................:........::-=+%*--+@@          
//     @%++=---------------:..............................................:---=+%#=---*@@         
//     @@*+++===-------------:..............................::--:.......:----=+%%+----=@@         
//      @%*+++=====--------------:......................::--------------===++*%%++----+@@         
//       @%+==+=====--------------------::::::::::-------------------------=+%#+++=--=%@          
//        @@*====--------------------------------------------------------==*%#=+++===%@@          
//         @@%+====-------------------------------------------=====---===+%%#+=++++*%@            
//           @@%*+==+*#######*=---------------------------=+#######%*==*%%***++*#%%@@             
//             @@@%%#********#%+===--------------------===*#*#**#*#*#%@@%%%%%%@@@@                
//                 @%##*%**#*#%@%%%%###****++++++***#%%%%@@%#%####%#%@@  @@@                      
//                   @@@@@@@@@       @@@@@@@@@@@@@@         @@@@@@@@ 
// Name: OmniCat 
// Ticker: OMNI
// 
// PRE-RICH

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./ERC20.sol";
import "./Ownable.sol";

contract OmniCat is ERC20, Ownable {

    uint256 public maxHolding;
    address public uniswapV2Pair;
    address public meowketMakerWallet;
    mapping (address => bool) public noMeowList;

    constructor(address _meowketMaker) ERC20("OmniCat", "OMNI") Ownable(msg.sender) {
        meowketMakerWallet = _meowketMaker;
        maxHolding = 399000000000000000000000000000000;
        _mint(msg.sender, 399000000000000000000000000000000);
        _mint(meowketMakerWallet, 21000000000000000000000000000000); // 5% of total supply goes to future meowket maker
    }

    // @notice  Initialize the pair and the max holding amount
    // @dev     Tokens cannot be transferred before first meow
    function firstMeow(address _uniswapV2Pair, uint256 _maxHolding) external onlyOwner {
        uniswapV2Pair = _uniswapV2Pair;
        maxHolding = _maxHolding;
    }

    // @notice  Can't trade if on noMeowList or if pair not set
    // @dev     Override update to check for noMeowList and maxHolding
    function _update(address from, address to, uint256 value) override internal {

        require(!noMeowList[from] || !noMeowList[to], "OMNI: No ~meow~ list!");

        if (uniswapV2Pair == address(0)) {
            require(from == owner() || to == owner() || to == meowketMakerWallet, "OMNI: You can't transfer before first meow");
        }

        require(super.balanceOf(to) + value <= maxHolding, "OMNI: Exceed max holding");
        
        super._update(from, to, value);
    }

    function addToNoMeowList(address _address) external onlyOwner {
        noMeowList[_address] = true;
    }
}