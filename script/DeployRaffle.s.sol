//SPDX-License-Identifier: MIT  

import {Raffle} from "../src/Raffle.sol"; 
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from  "./HelperConfig.s.sol";


pragma solidity ^0.8.18;

contract DeployRaffle is Script  { 

  function run() external returns (Raffle, HelperConfig ) {
    HelperConfig helperConfig = new HelperConfig();
         (uint256 entranceFee,
         uint256   interval,
          address  vrfCoordinator,
          uint32  gasLane,
          uint64  subscriptionId,
           uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
     Raffle raffle = new Raffle(entranceFee, interval, vrfCoordinator, gasLane, subscriptionId, callbackGasLimit);
        vm.stopBroadcast();
        return (raffle, helperConfig);

  } 
      function getSepoliaEthConfig() public pure returns ( NetworkConfig memory sepoliaNetworkConfig) {
        sepoliaNetworkConfig = NetworkConfig({ubscriptionId: 0, // If left as 0, our scripts will create one!
           gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
           automationUpdateInterval: 30, // 30 seconds
           raffleEntranceFee: 0.01 ether,
           callbackGasLimit: 500000, // 500,000 gas
           vrfCoordinatorV2: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
           link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
           deployerKey: vm.envUint("PRIVATE_KEY")
       });
    

      /* if (subscriptionId == 0) {
        CreateSubscription createSubscription = new createSubscription(); 
        subscriptionId = createSubscription.createSubscription(
          vrfCoordinatorV2,
          deployerKey
        );

        FundSubscription fundSubscription = new FundSubscription();
        fundSubscription.fundSubscription(
          vrfCoordinatorV2,
          deployerKey
        )
       }
       
      }
      */

}

}

