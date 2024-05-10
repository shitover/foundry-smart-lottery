//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";   

contract RaffleTest is Test {

Raffle raffle;
HelperConfig helperConhfig;


uint256 entranceFee;
         uint256   interval;
          address  vrfCoordinator;
          uint32  gasLane;
          uint64  subscriptionId;
           uint32 callbackGasLimit;

address public PLAYER = makeAddr("player");
uint256 public constant STARTING_USER_BALANCE = 10 ether;


       function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
     (  
        entranceFee,
         interval,
         vrfCoordinator,
           gasLane,
            subscriptionId,
         callbackGasLimit

     ) = helperConfig.activeNetworkConfig();
       }
    
    
    function testRaffleInitializesInOpenState() public view {
        assert(raffle.s_raffleState() == Raffle.RaffleState.OPEN);
    }



    function testRevertsWhenYouDontPayEnough() public {
        vm.prank(PLAYER);
        vm.expectRevert(Raffle.Raffle__NotEnoughEthSent.selector);
            raffle.enterRaffle();
        }

        function testRaffleRecordsPlayerWhenTheyEnter() public {

        
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        address playerRecorded = raffle.s_player(0);
        assert(playerRecorded == PLAYER);   
    }
        function testEmitsEventOnEnterance() public {
            vm.prank(PLAYER);
            vm.expectEmit(true, false, false, false, address(raffle));
            emit EnteredRaffle(PLAYER);
            raffle.enterRaffle{value: entranceFee}();
        }

}