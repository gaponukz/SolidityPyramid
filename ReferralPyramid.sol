// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ReferralPyramid {
    using SafeMath for uint256;

    struct User { address payable inviter; address payable self; }
    mapping(address => User) tree;
    address payable public top;

    constructor() {
        tree[msg.sender] = User(payable(msg.sender), payable(msg.sender));
        top = payable(msg.sender);
    }

    function joinToReferralPyramid(address payable inviter) public payable {
        require(msg.value >= 1 ether, "For joining in game you need pay 1 ether");
        require(tree[msg.sender].inviter == address(0), "You can not invite yourself");
        require(tree[inviter].self == inviter, "Someone has invite you");

        tree[msg.sender] = User(payable(inviter), payable(msg.sender));
        address payable current = inviter;

        uint256 amount = msg.value;

        while(current != top) {
            amount = amount.div(2);
            current.transfer(amount);
            current = tree[current].inviter;
        }

        top.transfer(amount);
    }
}
