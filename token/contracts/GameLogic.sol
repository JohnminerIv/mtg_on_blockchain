pragma solidity ^0.7.0;

import "./LandFactory.sol";
import "./PlainsWalkerHelper.sol";

contract GameLogic is PlainsWalkerHelper{

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
        plainsWalkers[_plainsWalkerId].creatures = Creatures[];
    }

    function revivePlainsWalker(uint _plainsWalkerId) external payable ownerOf(_plainsWalkerId){
        require(msg.value >= 0.001);
        require(plainsWalkers[_plainsWalkerId].health == 0);
        plainsWalkers[_plainsWalkerId].health = 100;
    }

    function collectManaFromLands(uint _plainsWalkerId) external ownerOf(_plainsWalkerId) isAlive(_plainsWalkerId){
        uint[] memory mana = colletMana(msg.sender);
        plainsWalkers[_plainsWalkerId].redMana += mana[0];
        plainsWalkers[_plainsWalkerId].greenMana += mana[1];
        plainsWalkers[_plainsWalkerId].blueMana += mana[2];
        plainsWalkers[_plainsWalkerId].blackMana += mana[3];
        plainsWalkers[_plainsWalkerId].whiteMana += mana[4];
    }
   function summonCreature(uint memory _plainsWalkerId, uint memory red,  uint memory green, uint memory blue, uint memory black, uint memory white) external ownerOf(_plainsWalkerId) isAlive(_plainsWalkerId){
       uint[5] memory mana;
       mana[0] = red;
       mana[1] = green;
       mana[2] = blue;
       mana[3] = black;
       mana[4] = white;
       plainsWalkers[_plainsWalkerId].creatures.push(createCreature(_plainsWalkerId, mana));
    }
    function setCreatureToDefend(uint memory _plainsWalkerId, uint memory _creatureId) external ownerOf(_plainsWalkerId){
        plainsWalkers[_plainsWalkerId].creatures[_creatureId].isDefending = true;
    }
    function setCreatureToAttack(uint memory _plainsWalkerId, uint memory _creatureId) external ownerOf(_plainsWalkerId){
        plainsWalkers[_plainsWalkerId].creatures[_creatureId].isDefending = false;
    }
    function delCreature(uint memory _plainswalkerId, uint memory _creatureId) internal {
        plainsWalkers[_plainsWalkerId].creatures[_creatureId] = plainsWalkers[_plainsWalkerId].creatures[plainsWalkers[_plainsWalkerId].creatures.length - 1];
        delete plainsWalkers[_plainsWalkerId].creatures[plainsWalkers[_plainsWalkerId].creatures.length - 1];

    }
    function attackWithCreature(uint memory _plainsWalkerId, uint memory _creatureId, uint memory _targetPlainswalkerId){
        require (_plainsWalkerId != _targetPlainswalkerId);
        Creature memory attacker = plainsWalkers[_PlainswalkerId].creatures[_creatureId];
        Creature memory defender;
        bool foundCreature = false;
        for (uint i = 0; i < plainsWalkers[_targetPlainswalkerId].creatures.length; i++) {
            if (plainsWalkers[_targetPlainswalkerId].creatures[i].isDefending == true) {
                foundCreature = true;
                defender = plainsWalkers[_targetPlainswalkerId].creatures[i];
                break;
            }
        }
        if (foundCreature == false){
            if (attacker.attack >= plainsWalkers[_targetPlainswalkerId].health){
                plainsWalkerDied(_targetPlainswalkerId);
            } else {
                plainsWalkers[_targetPlainswalkerId].health -= attacker.attack;
            }
        } else {
            bool memory attackerDied = false;
            bool memory defenderDied = false;
            if (attacker.attack >= defender.defence){
                defenderDied = true;
            } else {
                plainsWalkers[_targetPlainswalkerId].creatures[i].defence -= attacker.attack;
            }
            if (defender.attack >= attacker.defence){
                attackerDied = true;
            } else {
                plainsWalkers[_PlainswalkerId].creatures[_creatureId].defence -= defender.attack;
            }
            if (attackerDied){
                delCreature(_plainsWalkerId, _creatureId);
            }
            if (defenderDied){
                delCreature(_targetPlainsWalkerId, i);
            }
        }

    }
    function defendWithCreatures(uint memory _plainsWalkerId, Creature attacker) internal{

    }
}
