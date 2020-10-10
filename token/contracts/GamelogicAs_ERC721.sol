pragma solidity >=0.4.22 <0.7.0;

import "./GameLogic.sol";

contract GameLogicAs_ERC721 is GameLogic{
    mapping (uint => address) plainsWalkerApprovals;

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );
 
 
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerPlainsWalkerCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return plainsWalkerToOwner[_tokenId];
    }
    
    function _transfer(address _from, address _to, uint256 _tokenId) private{
        ownerPlainsWalkerCount[_to] = ownerPlainsWalkerCount[_to].add(1);
        ownerPlainsWalkerCount[msg.sender] = ownerPlainsWalkerCount[msg.sender].sub(1);
        plainsWalkerToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
      
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
        require (plainsWalkerToOwner[_tokenId] == msg.sender || plainsWalkerApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable ownerOfPlainsWalker(_tokenId){
        plainsWalkerApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}