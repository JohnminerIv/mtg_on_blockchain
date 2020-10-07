pragma solidity ^0.7.0;

import "./PlainsWalkerHelper.sol";

interface LandInterface{
    function collectMana(address _owner) external returns(uint16[] memory);
}

contract GameLogic is PlainsWalkerHelper{

    LandInterface landContract;

    function setLandContractAddress(address _address) external onlyOwner {
        landContract = LandInterface(_address);
    }

    modifier isAlive(uint _plainsWalkerId) {
        require(plainsWalkers[_plainsWalkerId].health > 0);
        _;
    }

    function plainsWalkerDied(uint _plainsWalkerId) internal {
        plainsWalkers[_plainsWalkerId].greenMana = 0;
        plainsWalkers[_plainsWalkerId].redMana = 0;
        plainsWalkers[_plainsWalkerId].blackMana = 0;
        plainsWalkers[_plainsWalkerId].blueMana = 0;
        plainsWalkers[_plainsWalkerId].whiteMana = 0;
        plainsWalkers[_plainsWalkerId].health = 0;
        for (uint i; i < plainsWalkers[_plainsWalkerId].creatures.length; i++){
            deletedCreatureIds.push(plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[i]].id);
            delete plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[i]];
        }
        uint[] memory creatures;
        plainsWalkers[_plainsWalkerId].creatures = creatures;
    }

    function revivePlainsWalker(uint _plainsWalkerId) external payable ownerOf(_plainsWalkerId){
        require(msg.value >= 0.001 ether);
        require(plainsWalkers[_plainsWalkerId].health == 0);
        plainsWalkers[_plainsWalkerId].health = 100;
    }

    function collectManaFromLands(uint _plainsWalkerId) external ownerOf(_plainsWalkerId) isAlive(_plainsWalkerId){
        uint16[] memory mana = landContract.collectMana(msg.sender);
        plainsWalkers[_plainsWalkerId].redMana += mana[0];
        plainsWalkers[_plainsWalkerId].greenMana += mana[1];
        plainsWalkers[_plainsWalkerId].blueMana += mana[2];
        plainsWalkers[_plainsWalkerId].blackMana += mana[3];
        plainsWalkers[_plainsWalkerId].whiteMana += mana[4];
    }
   function summonCreature(uint _plainsWalkerId, uint red,  uint green, uint blue, uint black, uint white) external ownerOf(_plainsWalkerId) isAlive(_plainsWalkerId){
        require( plainsWalkers[_plainsWalkerId].redMana >= red);
        require( plainsWalkers[_plainsWalkerId].blueMana >= blue);
        require( plainsWalkers[_plainsWalkerId].greenMana >= green);
        require( plainsWalkers[_plainsWalkerId].blackMana >= black);
        require( plainsWalkers[_plainsWalkerId].whiteMana >= white);
        plainsWalkers[_plainsWalkerId].redMana -= uint16(red);
        plainsWalkers[_plainsWalkerId].blueMana -= uint16(blue);
        plainsWalkers[_plainsWalkerId].greenMana -= uint16(green);
        plainsWalkers[_plainsWalkerId].blackMana -= uint16(black);
        plainsWalkers[_plainsWalkerId].whiteMana -= uint16(white);
        uint[5] memory mana;
        mana[0] = red;
        mana[1] = green;
        mana[2] = blue;
        mana[3] = black;
        mana[4] = white;
        Creature memory creature;
        creature = createCreature(mana);
        plainsWalkersToCreature[creature.id] = creature;
        plainsWalkers[_plainsWalkerId].creatures.push(uint(creature.id));
    }
    function setCreatureToDefend(uint _plainsWalkerId, uint _creatureIndex) external ownerOf(_plainsWalkerId){
        plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].isDefending = true;
    }
    function setCreatureToAttack(uint _plainsWalkerId, uint _creatureIndex) external ownerOf(_plainsWalkerId){
        plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].isDefending = false;
    }
    function delCreature(uint _plainsWalkerId, uint _creatureIndex) internal {
        deletedCreatureIds.push(plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].id);
        plainsWalkers[_plainsWalkerId].creatures[_creatureIndex] = plainsWalkers[_plainsWalkerId].creatures[plainsWalkers[_plainsWalkerId].creatures.length - 1];
        delete plainsWalkers[_plainsWalkerId].creatures[plainsWalkers[_plainsWalkerId].creatures.length - 1];

    }
    function attackWithCreature(uint _plainsWalkerId, uint _creatureIndex, uint _targetPlainsWalkerId) external ownerOf(_plainsWalkerId){
        // plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[index]]
        // plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]]
        require (_plainsWalkerId != _targetPlainsWalkerId);
        bool foundCreature = false;
        uint index;
        for (uint i = 0; i < plainsWalkers[_targetPlainsWalkerId].creatures.length; i++) {
            if (plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[i]].isDefending == true) {
                foundCreature = true;
                break;
            }
        index++;
        }
        if (foundCreature == false){
            if (plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].attack >= plainsWalkers[_targetPlainsWalkerId].health){
                plainsWalkerDied(_targetPlainsWalkerId);
            } else {
                plainsWalkers[_targetPlainsWalkerId].health -= plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].attack;
            }
        } else {
            bool attackerDied = false;
            bool defenderDied = false;
            if (plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].attack >= plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[index]].defence){
                defenderDied = true;
            } else {
                plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[index]].defence -= plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].attack;
            }
            if (plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[index]].attack >= plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].defence){
                attackerDied = true;
            } else {
                plainsWalkersToCreature[plainsWalkers[_plainsWalkerId].creatures[_creatureIndex]].defence -= plainsWalkersToCreature[plainsWalkers[_targetPlainsWalkerId].creatures[index]].attack;
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