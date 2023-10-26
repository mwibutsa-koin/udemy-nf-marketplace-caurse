// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) _OwnedTokensCount;
    mapping(uint256 => address) private _tokenApprovals;

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Owner query for non-existent token.");
        return _OwnedTokensCount[owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return _tokenOwner[_tokenId];
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return isValid(owner);
    }

    function _mint(
        address to,
        uint256 tokenId
    ) internal virtual isValidAddress(to) {
        require(!_exists(tokenId), "ERC721: token already minted");
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to] += 1;
        emit Transfer(address(this), to, tokenId);
    }

    function isValid(address addr) internal pure returns (bool) {
        return addr != address(0);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(isValid(_from), "Sender address is invalid");
        require(isValid(_to), "Receiver address is invalid");
        require(ownerOf(_tokenId) == _from, "You don't own this token");

        _tokenOwner[_tokenId] = _to;
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(isApprovedOrOwner(msg.sender, _tokenId), "Not approved");
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, "Error - approval to current owner");
        require(
            msg.sender == owner,
            "Current caller is not the owner of the token"
        );
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }

    modifier isValidAddress(address to) {
        require(isValid(to), "Can not mint to zero address");
        _;
    }
}
