pragma solidity >=0.4.22 <0.7.0;

import "./Ownable.sol";
import "./SafeMath.sol";

/**
 * @dev Plains Walkers are the main way of interacting with this contract.
 *  They can Harvest mana from lands, 
 *  summon creatures,
 *  direct creatures in combat
 *  {cast spells} yet to be developed
 *  {activate creature abilities} yet to be developed
 */
contract PlainsWalkerFactory is Ownable{

    using SafeMath for uint256;
    
    // used to ensure that the dna is 99999 or less.
    uint modulus = 100000;

    // Is emitted whenever a new plainswalker is created.
    event NewPlainswalker(uint PlainsWalkerId, string name, uint dna);

    // PlainsWalker struct
    struct PlainsWalker {
        // Name of plainswalker
        string name;
        // We only want one active plainsWalker per address.
        bool isActive;
        // {plainsWalker dna (will be used when determining certain modifiers.)} modifiers not implemented.
        uint64 dna;
        // How much health does a given PlainsWalker have.
        uint16 health;
        // mana should be in this order ['Red', 'Green', 'Blue', 'Black', 'White'].
        uint16[5] mana;
        // A list of creature id's that map to this plainswalker.
        uint[] creatureList;
    }
    
    // The list of PlainsWalkers
    PlainsWalker[] plainsWalkers;
    // Maps plainswalkers to owners
    mapping (uint => address) public plainsWalkerToOwner;
    // Keeps count of how many plainswalkers each owner has.
    mapping (address => uint) public ownerPlainsWalkerCount;
    // Keeps track of if an owner already got their first free plainswalker.
    mapping (address => bool) firstOwnerBool;

    /**
     * @dev Create a new plainswalker based on a name health and dna. 
     * Then accosiate it with the msg.sender
     */
    function _createPlainswalker(string memory _name, bool _isActive, uint64 _dna, uint16 _health) internal{
        uint16[5] memory _mana;
        uint[] memory _creatureList;
        plainsWalkers.push(PlainsWalker(_name, _isActive, _dna, _health, _mana, _creatureList));
        uint id = plainsWalkers.length - 1;
        plainsWalkerToOwner[id] = msg.sender;
        firstOwnerBool[msg.sender] = true;
        ownerPlainsWalkerCount[msg.sender]++;
        emit NewPlainswalker(id, _name, _dna);
    }

    /**
     * @dev Generate the random dna for a plainsWalker
     */
    function _generateRandomDna(string memory _str, address _address) internal view returns (uint){
        uint rand = uint(keccak256(abi.encodePacked(_str, _address, plainsWalkers.length)));
        return rand % modulus;
    }

    /**
     * @dev External function to create a persons first plainsWalker
     */
    function createRandomPlainsWalker(string calldata _name) external {
        require(firstOwnerBool[msg.sender] != true);
        uint64 randDna = uint64(_generateRandomDna(_name, msg.sender));
        _createPlainswalker(_name, true, randDna, 100);
    }
}