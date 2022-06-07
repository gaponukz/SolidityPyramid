// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Pyramid {
    uint256 currentIndex = 0;
    mapping (uint256 => address) addresses;
    uint256 constant public userCircleNumber = 3;

    function joinToPyramid() payable public returns(uint256) {
        require (msg.value == 1 ether, "For joining in game you need pay 1 ether");

        currentIndex += 1;
        addresses[currentIndex] = msg.sender;

        if (currentIndex > userCircleNumber) {
            address payable selectedAddress = payable(addresses[currentIndex-userCircleNumber]);
            selectedAddress.transfer(1.5 ether);
        }

        return currentIndex;
    }
}
