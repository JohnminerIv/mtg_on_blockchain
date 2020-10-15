pragma solidity >=0.4.22 <0.7.0;

// import "./ERC721.sol";
import "./LandFactory.sol";

contract LandFactoryAsERC721 is LandFactory{
    mapping (uint => address) landApprovals;

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
        return landOwnerCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return landToOwner[_tokenId];
    }
    
    function _transfer(address _from, address _to, uint256 _tokenId) private{
        landOwnerCount[_to] = landOwnerCount[_to].add(1);
        landOwnerCount[msg.sender] = landOwnerCount[msg.sender].sub(1);
        landToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }
      
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
        require (landToOwner[_tokenId] == msg.sender || landApprovals[_tokenId] == msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable ownerOfLand(_tokenId){
        landApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
