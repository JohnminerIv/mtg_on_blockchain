pragma solidity ^0.7.0;

import "./SafeMath.sol";

contract Creatures{

    using SafeMath for uint256;

    struct Creature{
        uint16 attack;
        uint16 defence;
        string special;
    }

    mapping (uint => uint) creatureToPlainsWalker;
    mapping (uint => uint) plainsWalkerCreatureCount;
    
    Creature[] creatures;

}