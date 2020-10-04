pragma solidity ^0.7.0;

import "./ownable.sol";
import "./SafeMath.sol";

contract PlainsWalkerFactory is Ownable{

    using SafeMath for uint256;

    uint modulus = 10000000000;

    event NewPlainswalker(uint PlainsWalkerId, string name, uint dna);

    struct PlainsWalker {
        string name;
        uint64 dna;
        uint16 hitpoints;
        uint16 redMana;
        uint16 blueMana;
        uint16 greenMana;
        uint16 blackMana;
        uint16 whiteMana;
    }

    Plainswalker[] plainsWalkers;

    mapping (uint => address) public plainsWalkerToOwner;
    mapping (address => uint) public ownerPlainsWalkerCount;
    mapping (address => bool) firstOwnerBool;

    function _createPlainswalker(string memory _name, uint64 _dna, uint _health) internal{
        uint id = plainsWalkers.push(PlainsWalker(_name, _dna, _health, 0,0,0,0,0)) - 1;
        plainsWalkerToOwner[id] = msg.sender;
        firstBool[msg.sender] = true;
        ownerPlainsWalkerCount[msg.sender]++;
        emit NewPlainswalker(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str, address memory _address) private veiw returns (uint){
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        uint rand2 = uint(keccak256(abi.encodePacked(_address)));
        return (rand + rand2) % modulus
    }

    function createRandomPlainsWalker(string memory _name) public {
        require(firstOwnerBool[msg.sender] != true);
        uint64 randDna = uint64(_generateRandomDna(_name, msg.sender));
        _createPlainswalker(_name, randDna);
    }

    function changeName(uint _plainsWalkerId, string calldata _newName) external {
        require(msg.sender == plainsWalkerToOwner[_plainsWalkerId]);
        plainsWalkers[_plainsWalkerId].name = _newName;
    }
}