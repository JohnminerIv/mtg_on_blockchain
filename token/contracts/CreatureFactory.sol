pragma solidity ^0.7.0;

import "./SafeMath.sol";

contract CreatureFactory{

    // using SafeMath for uint256;

    struct Creature{
        uint id;
        uint16 attack;
        uint16 defence;
        uint32 readyTime;
        string special;
        bool isDefending;
    }
    
    uint[] deletedCreatureIds;
    uint nextId;
    

    function createCreature(uint[5] memory mana) internal returns (Creature memory) {
        uint totalCost;
        uint greatest;
        uint indexOfGreatest;
        for (uint i = 0; i < mana.length; i++) {
            totalCost += mana[i];
            if (mana[i] > greatest){
                greatest = mana[i];
                indexOfGreatest = i;
            }
        }
        require(totalCost > 0);
        uint attack = totalCost/2;
        uint defence = attack;
        attack += mana[0]/2;
        defence += mana[0]/2;
        attack += mana[1];
        defence += mana[2];
        attack += mana[3]/3;
        defence += mana[3]/3;
        defence += mana[4];
        if (defence == 0){
            defence ++;
        }
        uint rand = uint(keccak256(abi.encodePacked(mana))) % 10;
        string memory special = 'None';
        if (rand > 7){
            if (indexOfGreatest == 0){
                special = 'generate mana';
            }
            if (indexOfGreatest == 1){
                special = 'Zap';
            }
            if (indexOfGreatest == 2){
                special = 'Unblockable';
            }
            if (indexOfGreatest == 3){
                special = 'life drain';
            }
            if (indexOfGreatest == 4){
                special = 'Heal';
            }
        }
        uint id;
        if (deletedCreatureIds.length == 0){
            id = nextId;
            nextId ++;
        } else {
            id = deletedCreatureIds[deletedCreatureIds.length - 1];
            delete deletedCreatureIds[deletedCreatureIds.length - 1];
        }
        return Creature(id, uint16(attack), uint16(defence), uint32(block.timestamp + 6 hours), special, false);
    }

}