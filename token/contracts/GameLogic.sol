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
        plainsWalkers[_plainsWalkerId].creatures[_creatureId].isDefending = true 
    }
    function setCreatureToAttack(uint memory _plainsWalkerId, uint memory _creatureId) external ownerOf(_plainsWalkerId){
        plainsWalkers[_plainsWalkerId].creatures[_creatureId].isDefending = false
    }
    function attackWithCreature(uint memory _plainsWalkerId, uint memory _creatureId, uint memory _targetPlainswalker){

    }
    function defendWithCreatures(uint memory _plainsWalkerId, uint _attakerDamage, uint _attackerHealth) internal{
        Creature defendingCreature;
        bool foundCreature = false;
        for (uint i = 0; i < plainsWalkers[_plainsWalkerId].creatures.length; i++) {
            if (plainsWalkers[_plainsWalkerId].creatures[i].isDefending == true) {
                
            }
        }

    }
}
