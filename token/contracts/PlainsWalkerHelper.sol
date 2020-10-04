pragma solidity ^0.7.0;

import "Land.sol"
import "./PlainsWalkerFactory.sol";

contract PlainsWalkerHelper is PlainsWalkerFactory {

    uint plainsWalkerFee = 0.02 ether;

    modifier ownerOf(uint _plainsWalkerId) {
        require(msg.sender == plainsWalkerToOwner[_plainsWalkerId]);
        _;
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        _owner.transfer(address(this).balance);
    }

    function setPlainsWalkerFee(uint _fee) external onlyOwner {
        plainsWalkerFee = _fee;
    }

    function getPlainsWalkersByOwner(address _owner) external view returns(uint[] memory) {
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

    function collectManaFromLands(uint _plainsWalkerId) external ownerOf(uint _plainsWalkerId){
        uint[] memory mana = colletMana(msg.sender);
        if (plainsWalkers[_plainsWalkerId].health > 0){
            plainsWalkers[_plainsWalkerId].redMana += mana[0]
            plainsWalkers[_plainsWalkerId].greenMana += mana[1]
            plainsWalkers[_plainsWalkerId].blueMana += mana[2]
            plainsWalkers[_plainsWalkerId].blackMana += mana[3]
            plainsWalkers[_plainsWalkerId].whiteMana += mana[4]
        }
    }

    function purchasePlainsWalker(string _name) payable {

    }

    function summonCreature(uint _plainsWalkerId, uint red, uint blue, uint green, uint black, uint white) external ownerOf(uint _plainsWalkerId){

    }

}