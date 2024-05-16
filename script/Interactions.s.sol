//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {HelperConfig} from "./HelperConfig.s.sol";

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;

    function FundSubscriptionConfig() public {
        
    HelperConfig helperConfig = new HelperConfig();

    ( uint64 subId, 
    ,
    ,
    ,
    ,
    address vrfCoordinatorV2,
    address link,
    uint256 deployerKey 
    ) = helperConfig.activeNetworkConfig();

    if (subscriptionId == 0) {
        CreateSubscription createSubscription = new createSubscription(
            subscriptionId = createSubscription.createSubscription(
                vrfCoordinatorV2,
                deployerKey
            );

            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                vrfCoordinatorV2,

                subscriptionId,
                link,
                deployerKey
            );
        )
    }

    }

function createSubscription( address vrfCoordinatorV2, uint256 deployKey) public returns(uint64) {
    console.log("Creating subscription on chainId: ",  block.chainid);
    vm.startBroadcast();
    uint64 subId = VRFCoordinatorV2Mock(vrfCoordinatorV2)
    .createSubscription();
    vm.stopBroadcast();
    console.log("Your subscription Id is: ", subId);
    console.log("Please update the subscriptionId in HelperConfig.sol");
    return subId;
} 

} 


contract AddConsumer is Script {
    function addConsumer(
        address contractToAddToVrf,
        address vrfCoordinator,
        uint64 subId,
        uint256 deployerKey
    ) public {
        console.log("Adding consumeer contract: ", contractToAddToVrf);
        console.log("Using vrfCoordinator: ", vrfCoordinator);
        vm.startBroadcast();
        VRFCoordinatorV2Mock(vrfCoordinator).addConsumer(
            subId,
            contractToAddToVrf,
        );
        vm.stopBroadcast();
    } 

    function addConsumer(address mostRecentDeployed) public {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint64 subId,
            ,
            ,
            ,
            ,
             address vrfCoordinator,
             ,
             uint256 deployerKey 
        ) = heloerConfig.activeNetworkConfig();
        addConsumer(mostRecentDeployed, vrfCoordinator, subId, deployerKey);
    }
}
