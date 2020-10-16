pragma solidity >=0.4.22 <0.7.0;

import "./PlainsWalkerFactory.sol";


/**
 * @dev An extention of plainswalker factory that includes more helper and getter functions
 */
contract PlainsWalkerHelper is PlainsWalkerFactory{

    // price of a new plainsWalker
    uint plainsWalkerFee = 0.02 ether;

    /**
     * @dev A function to tell users how much a plainsWalker costs
     */
    function getPlainsWalkerFee() external view returns(uint){
        return plainsWalkerFee;
    }
    
    /**
     * @dev A function to set how much a plainsWalker costs
     */
    function setPlainsWalkerFee(uint _fee) external onlyOwner {
        plainsWalkerFee = _fee;
    }
    
    /**
     * @dev A function to purchase another plainswalker
     */
    function purchasePlainsWalker(string memory _name) external payable {
        require(msg.value == plainsWalkerFee);
        uint64 randDna = uint64(_generateRandomDna(_name, msg.sender));
        _createPlainswalker(_name, false, randDna, 0);
    }

    /**
     * @dev A modifier to check if the msg.sender owns the plainswalker.
     */
    modifier ownerOfPlainsWalker(uint _plainsWalkerId) {
        require(msg.sender == plainsWalkerToOwner[_plainsWalkerId]);
        _;
    }
    
    /**
     * @dev Find plainsWalkers by owner addresses.
     */
    function getPlainsWalkersByOwner(address _owner) public view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerPlainsWalkerCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < plainsWalkers.length; i++) {
            if (plainsWalkerToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    /**
     * @dev change the name of a plainsWalker if you own it.
     */
    function changeName(uint _plainsWalkerId, string calldata _newName) external ownerOfPlainsWalker(_plainsWalkerId) {
        plainsWalkers[_plainsWalkerId].name = _newName;
    }

    /**
     * @dev Get information on a plainsWalker through its id.
     */
    function getPlainswalkerInfoById(uint _id) external view ownerOfPlainsWalker(_id) returns(string memory name, bool isActive, uint16 health, uint16[5] memory mana, uint[] memory creatureIndex){
        return (plainsWalkers[_id].name, plainsWalkers[_id].isActive, plainsWalkers[_id].health, plainsWalkers[_id].mana, plainsWalkers[_id].creatureList);
    }
}