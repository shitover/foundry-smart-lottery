//SPDX-LICENSE-IDENTIFIER: MIT


// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Raffle is VRFConsumerBaseV2 {

    error Raffle__NotEnoughEthSent();
     error Raffle__TransferFailed();
     error Raffle__RaffleNotOpen();
     error Raffle__UpkeepNotNeeded(uint256 currentBalance, uint256 numPlayers, uint256 raffleState);


     enum RaffleState {
        OPEN,
        CALCULATING
     }


    uint16 private constant REQUEST_CONFIRMATIONS = 3;
     uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;

    uint256 private immutable i_interval;
VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
          bytes32 private immutable i_gasLane;

          uint64 private immutable i_subscriptionId;
          uint32 private immutable i_callbackGasLimit;

   
    address payable[] private s_players;

    uint256 private s_lastTimeStamp;
    RaffleState private s_raffleState;


    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);


    constructor(uint256 entranceFee, 
    uint256 interval,
     address vrfCoordinator,
      bytes32 gasLane,
      uint64 subscriptionId,
      uint32 callbackGasLimit) VRFConsumerBaseV2(vrfCoordinator) {


        i_entranceFee = entranceFee;
        i_entranceFee = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit; 
        s_raffleState = RaffleState.OPEN; 
        s_lastTimeStamp = block.timestamp;
    }

    modifier raffleEntered()  { 
        vm.prank(PLAYER);
        raffle.enterRaffle{value: raffleEntranceFee}();
        raffle.performUpkeep("");
        vm.expectRevert(Raffle.Raffle__RaffleNotOpen.selector);
        vm.warp(block.timestamp + automationUpdateInterval + 1);
        vm.roll(block.number + 1);
        _;
        
    }


    function enterRaffle()  public payable {

        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
        
    }
 
        function checkUpkeep (bool upkeepNeeded, bytes memory) public {
            bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
            bool isOpen = RaffleState.OPEN == s_raffleState;
            bool hasBalance  = address(this).balance > 0;
            bool hasPlayers = s_players.length > 0;
            upkeepNeeded = timeHasPassed && isOpen && hasBalance && hasPlayers;
            return (upkeepNeeded, "0x0");
        }
      

    function performUpkeep(bytes calldata) external {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded( 
                address(this).balance, 
                s_players.length,
                uint256(s_raffleState)
            ); 
        } 

        if ((block.timestamp - s_lastTimeStamp) < i_interval)
        revert();

        s_raffleState = RaffleState.CALCULATING;
   

    i_vrfCoordinator.requestRandomWords(
        i_gasLane,
        
        i_subscriptionId,
        REQUEST_CONFIRMATIONS,
        i_callbackGasLimit,
        NUM_WORDS
);

} 

function fulfillRandomWords(
    uint256 requestId,
    uint256[] memory randomWords
) internal override {

    uint256 indexOfWinner = randomWords[0] % s_players.length;
    address payable winner = s_players[indexOfWinner];
    s_recentWinner = winner;
    s_raffleState = RaffleState.OPEN; 
    s_players = new address payable[](0);   
    s_lastTimeStamp = block.timestamp;
    emit PickedWinner(winner);



    {bool success, } = winner.call{value: address(this).balance}("");

    if (!success) {
        revert Raffle__TransferFailed();
    }  
    
}



    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexedOfPlayer)  external view returns (address) {
    return s_players[indexedOfPlayer];
    } 
}