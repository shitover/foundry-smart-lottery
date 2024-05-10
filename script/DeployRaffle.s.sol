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


}