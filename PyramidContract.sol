// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Pyramid {
    using SafeMath for uint256;

    uint256 currentGameIndex = 0;
    uint256 currentUserIdIndex = 1;

    struct User {
        uint256 UserId;
        address payable userAdsress;
        uint256 invitedId;
    }

    mapping (address => User) public registeredUsers;
    mapping (uint256 => mapping (uint8 => uint256)) currentUserIndex;
    mapping (uint256 => mapping (uint8 => mapping (uint256 => User))) pools;

    modifier onlyRegistered {
        require(registeredUsers[msg.sender].userAdsress != address(0));
        _;
    }

    function registerUserToGame(uint256 inviterId) payable public returns(uint256) {
        require (msg.value == 1 ether, "For joining in game you need pay 1 bnb");

        registeredUsers[msg.sender] = User(currentUserIdIndex, payable(msg.sender), inviterId);
        currentUserIdIndex += 1;

        return currentUserIdIndex - 1;
    }

    function joinToGame(uint8 gameId) payable public onlyRegistered {
        uint256 index = currentUserIndex[currentGameIndex][gameId];

        pools[currentGameIndex][gameId][index] = registeredUsers[msg.sender];
        currentUserIndex[currentGameIndex][gameId] += 1;
    }
}
