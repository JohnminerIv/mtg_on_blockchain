pragma solidity ^0.7.0;

import "./ownable.sol";
import "./SafeMath.sol";

contract LandFactory is Ownable{

    using SafeMath for uint256;

    struct Land {
        string landType;
        uint32 readyTime;
    }

    mapping (uint => address) public landToOwner;
    mapping (address => uint) public landOwnerCount;
    string[5] landNames;
    landNames[0] = 'Red';
    landNames[1] = 'Green';
    landNames[2] = 'Blue';
    landNames[3] = 'Black';
    landNames[4] = 'White';
    Land[] lands;

    function generateRandomLand() external payable {
        require(msg.value == 0.005 ether || landOwnerCount[msg.sender] == 0);
        uint rand = uint(keccak256(abi.encodePacked(lands.length, msg.sender)));
        rand = rand % 5
        uint id = lands.push(Land(landNames[rand], now))
        landToOwner[id] = msg.sender
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        _owner.transfer(address(this).balance);
    }

    function getLandByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](landOwnerCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < lands.length; i++) {
            if (landToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function colletMana(address _owner) private returns(uint[] memory) {
        uint[] memory result = new uint[](5);
        for (uint i = 0; i < lands.length; i++) {
            if (landToOwner[i] == _owner) {
                for (uint j = 0; j < landsNames.length; i==;){
                    if (landNames[j] == lands[i].landType && lands[i].readyTime <= now){
                        result[j]++
                        lands[i].readyTime = now + 6 hours
                    }
                }
            }
        }
        return result;
    }


}
