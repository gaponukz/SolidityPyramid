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

    struct Game {
        uint256 userCount;
        uint256 circleCount;
        uint256 amountToPay;
        uint256 sendWinnerAmount;
    }
    mapping (uint8 => Game) levels;
    mapping (uint256 => address) usersId;
    mapping (address => User) public registeredUsers;
    mapping (uint256 => mapping (uint8 => uint256)) currentUserIndex;
    mapping (uint256 => mapping (uint8 => mapping (uint256 => User))) pools;

    modifier onlyRegistered {
        require(registeredUsers[msg.sender].userAdsress != address(0));
        _;
    }

    constructor () {
        levels[0] = Game({
            userCount: 100,
            circleCount: 3,
            amountToPay: 1 ether,
            sendWinnerAmount: 1.5 ether
        });

        levels[1] = Game({
            userCount: 100,
            circleCount: 40,
            amountToPay: 1.5 ether,
            sendWinnerAmount: 2.0 ether
        });
    }

    function registerUserToGame(uint256 inviterId) payable public returns(uint256) {
        require (msg.value == 1 ether, "For joining in game you need pay 1 ether");

        registeredUsers[msg.sender] = User(currentUserIdIndex, payable(msg.sender), inviterId);
        usersId[currentUserIdIndex] = msg.sender;
        currentUserIdIndex += 1;

        return currentUserIdIndex - 1;
    }

    function joinToGame(uint8 gameId) payable public onlyRegistered {
        require (msg.value == levels[gameId].amountToPay, "Insufficient amount of contribution");

        uint256 index = currentUserIndex[currentGameIndex][gameId];

        pools[currentGameIndex][gameId][index] = registeredUsers[msg.sender];
        currentUserIndex[currentGameIndex][gameId] += 1;

        if (index > levels[gameId].circleCount) {
            uint256 winnerIndex = index - levels[gameId].circleCount;
            address payable selectedAddress = pools[currentGameIndex][gameId][winnerIndex].userAdsress;

            selectedAddress.transfer(levels[gameId].sendWinnerAmount);
        }
        if (index > levels[gameId].userCount) {
            // TODO: end of the game, new game, new game circle...
        }
    }
}
