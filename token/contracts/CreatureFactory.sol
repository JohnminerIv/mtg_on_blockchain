pragma solidity ^0.7.0;

import "./SafeMath.sol";

contract CreatureFactory{

    using SafeMath for uint256;

    struct Creature{
        uint16 attack;
        uint16 defence;
        uint32 readyTime;
        string special;
        bool isDefending;
    }

    function createCreature(uint plainsWalkerId, uint[] mana) internal returns (Creature) {
        uint memory totalCost;
        uint memory greatest;
        uint memory indexOfGreatest;
        for (uint i = 0; i < mana.length; i++) {
            totalCost += mana[i];
            if (mana[i] > greatest){
                greatest = mana[i];
                indexOfGreatest = i;
            }
        }
        require(totalCost > 0);
        uint attack = div(totalCost, 2);
        uint defence = attack;
        attack += div(mana[0], 2);
        defence += div(mana[0], 2);
        attack += mana[1];
        defence += mana[2];
        attack += div(mana[3], 3);
        defence += div(mana[3], 3);
        defence += mana[4];
        if (defence == 0){
            defence ++;
        }
        uint rand = uint(keccak256(abi.encodePacked(mana))) % 10;
        string special = 'None';
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
        return Creature(attack, defence, now + 6 hours, special, false);
    }

}