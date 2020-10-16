pragma solidity >=0.4.22 <0.7.0;

import "./PlainsWalkerHelper.sol";
import "./CreatureFactory.sol";

interface LandInterface{
    function _collectManaFromLand(address _owner, uint _landId) external returns(uint16[5] memory);
}

/**
 * @dev This contract holds most of the logic witten for MTG on the blockchain.
 */
contract GameLogic is PlainsWalkerHelper, CreatureFactory{

    // The land contract so that plainsWalkers can harvest mana.
    LandInterface landContract;

    /**
     * @dev A function so the owner of the contract can set the address of the land contract.
     */
    function setLandContractAddress(address _address) external onlyOwner {
        landContract = LandInterface(_address);
    }
    
    /**
     * @dev A modifier to require that a plainsWalker is alive before takin any actions.
     */
    modifier isActive(uint _plainsWalkerId) {
        require(plainsWalkers[_plainsWalkerId].isActive == true);
        _;
    }

    /**
     * @dev A function that resets all of a plainsWalkers attributes when they die.
     */
    function _plainsWalkerDied(uint _plainsWalkerId) internal {
        uint16[5] memory mana;
        plainsWalkers[_plainsWalkerId].mana = mana;
        plainsWalkers[_plainsWalkerId].health = 0;
        for (uint i; i < plainsWalkers[_plainsWalkerId].creatureList.length; i++){
            deletedCreatureIds.push(plainsWalkers[_plainsWalkerId].creatureList[i]);
            delete creatures[plainsWalkers[_plainsWalkerId].creatureList[i]];
        }
        uint[] memory creatureList;
        plainsWalkers[_plainsWalkerId].creatureList = creatureList;
        plainsWalkers[_plainsWalkerId].isActive = false;
    }

    /**
     * @dev A function that revives a plainsWalker after it has died.
     */
    function revivePlainsWalker(uint _plainsWalkerId) external payable ownerOfPlainsWalker(_plainsWalkerId){
        require(msg.value >= 0.001 ether);
        require(plainsWalkers[_plainsWalkerId].health == 0);
        plainsWalkers[_plainsWalkerId].health = 100;
        plainsWalkers[_plainsWalkerId].isActive == true;
    }
    
    /**
     * @dev A function that intefaces with the land contract and collects mana from the land.
     */
    function collectManaFromLands(uint _plainsWalkerId, uint _landId) external ownerOfPlainsWalker(_plainsWalkerId) isActive(_plainsWalkerId){
        uint16[5] memory mana = landContract._collectManaFromLand(msg.sender, _landId);
       for (uint i; i < mana.length; i++){
            plainsWalkers[_plainsWalkerId].mana[i] += mana[i];
        }
    }
    
    /**
     * @dev A function that summons a creature with by spending mana and assocciates the id of the creature with the 
     *  plainsWalker that summoned it.
     */
   function summonCreature(uint _plainsWalkerId, uint16 red,  uint16 green, uint16 blue, uint16 black, uint16 white) external ownerOfPlainsWalker(_plainsWalkerId) isActive(_plainsWalkerId){
        // mana should be in this order ['Red', 'Green', 'Blue', 'Black', 'White'].
        uint16[5] memory mana = [red, green, blue, black, white];
        for (uint i; i < mana.length; i++){
            require(plainsWalkers[_plainsWalkerId].mana[i] >= mana[i]);
        }
        for (uint i; i < mana.length; i++){
            plainsWalkers[_plainsWalkerId].mana[i] -= mana[i];
        }
        uint id;
        id = createCreature(mana);
        plainsWalkers[_plainsWalkerId].creatureList.push(id);
    }

    /**
     * @dev Sets a creature to defend 
     */
    function setCreatureToDefend(uint _plainsWalkerId, uint _creatureIndex) external ownerOfPlainsWalker(_plainsWalkerId) isActive(_plainsWalkerId){
        require(creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].isDefending == false);
        require(creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].readyTime <= block.timestamp);
        creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].isDefending = true;
    }
    /**
     * @dev Sets a creature to be able to attack
     */
    function setCreatureToAttack(uint _plainsWalkerId, uint _creatureIndex) external ownerOfPlainsWalker(_plainsWalkerId) isActive(_plainsWalkerId){
        require(creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].isDefending == true);
        creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].isDefending = false;
    }
    /**
     * @dev Removes a creature, normally after it or a plainsWalker has died.
     */
    function delCreature(uint _plainsWalkerId, uint _creatureIndex) internal {
        deletedCreatureIds.push(plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]);
        plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex] = plainsWalkers[_plainsWalkerId].creatureList[plainsWalkers[_plainsWalkerId].creatureList.length - 1];
        plainsWalkers[_plainsWalkerId].creatureList.pop();
    }
    /**
     * @dev A function that allows a plainswalker to command one of it's creatures to attack another plainswalker
     */
    function attackWithCreature(uint _plainsWalkerId, uint _creatureIndex, uint _targetPlainsWalkerId) external ownerOfPlainsWalker(_plainsWalkerId) isActive(_plainsWalkerId){
        require (plainsWalkers[_targetPlainsWalkerId].isActive == true);
        require (_plainsWalkerId != _targetPlainsWalkerId);
        require (creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[_creatureIndex]].readyTime <= block.timestamp);
        creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[_creatureIndex]].readyTime = uint32(block.timestamp + 6 hours);
        //  defender creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[index]]
        // attacker creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]]
        bool foundCreature = false;
        uint index;
        for (uint i = 0; i < plainsWalkers[_targetPlainsWalkerId].creatureList.length; i++) {
            if (creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[i]].isDefending == true) {
                foundCreature = true;
                break;
            }
        index++;
        }
        if (foundCreature == false){
            if (creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].attack >= plainsWalkers[_targetPlainsWalkerId].health){
                _plainsWalkerDied(_targetPlainsWalkerId);
            } else {
                plainsWalkers[_targetPlainsWalkerId].health -= creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].attack;
            }
        } else {
            bool attackerDied = false;
            bool defenderDied = false;
            if (creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].attack >= creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[index]].defence){
                defenderDied = true;
            } else {
                creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[index]].defence -= creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].attack;
            }
            if (creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[index]].attack >= creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].defence){
                attackerDied = true;
            } else {
                creatures[plainsWalkers[_plainsWalkerId].creatureList[_creatureIndex]].defence -= creatures[plainsWalkers[_targetPlainsWalkerId].creatureList[index]].attack;
            }
            if (attackerDied){
                delCreature(_plainsWalkerId, _creatureIndex);
            }
            if (defenderDied){
                delCreature(_targetPlainsWalkerId, index);
            }
        }

    }
}




