pragma solidity ^0.7.0;

import "./Ownable.sol";
import "./SafeMath.sol";

contract LandFactory is Ownable{

    // using SafeMath for uint256;

    struct Land {
        string landType;
        uint32 readyTime;
    }

    mapping (uint => address) public landToOwner;
    mapping (address => uint) public landOwnerCount;
    string[5] public landNames;
    constructor() {
        landNames[0] = 'Red';
        landNames[1] = 'Green';
        landNames[2] = 'Blue';
        landNames[3] = 'Black';
        landNames[4] = 'White';
    }
    Land[] lands;

    function generateRandomLand() external payable {
        require(msg.value == 0.005 ether || landOwnerCount[msg.sender] == 0);
        uint rand = uint(keccak256(abi.encodePacked(lands.length, msg.sender)));
        rand = rand % 5;
        lands.push(Land(landNames[rand], uint32(block.timestamp)));
        uint id = lands.length -1;
        landToOwner[id] = msg.sender;
        landOwnerCount[msg.sender] ++;
    }

    function withdraw() external onlyOwner {
        address payable _owner = owner();
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

    function collectMana(address _owner) internal returns(uint16[] memory) {
        uint16[] memory result = new uint16[](5);
        for (uint i = 0; i < lands.length; i++) {
            if (landToOwner[i] == _owner) {
                for (uint j = 0; j < landNames.length; i++){
                    if (keccak256(abi.encodePacked(landNames[j])) == keccak256(abi.encodePacked(lands[i].landType)) && lands[i].readyTime <= block.timestamp){
                        result[j]++;
                        lands[i].readyTime = uint32(block.timestamp + 6 hours);
                    }
                }
            }
        }
        return result;
    }


}
