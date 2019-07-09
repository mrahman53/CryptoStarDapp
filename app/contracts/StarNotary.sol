pragma solidity >=0.4.10 <0.6.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementation
contract StarNotary is ERC721 {

    event starRegistered(address registrant);

    struct Star { 
        string name;
        string starStory;
        string ra;
        string dec;
        string mag;
        // bool isRegistered;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo; 
    mapping(uint256 => uint256) public starsForSale;
    // below mapping must be private or cause error: 'Accessors for mapping with dynamically-sized keys not yet implemented.'
    mapping(string => bool) private starRegistry;


    function createStar(string memory _name, string memory _starStory, string memory _ra, string memory _dec, string memory _mag, uint256  _tokenId) public { 
        
        // check if this star is available to register
        // note: if it does not exist, it will return 0, which is equal to 'false'
        require(!this.isStarRegistered(_ra, _dec, _mag), "This star is already registerd!");

        // create a new star object; for now store it in memory
        Star memory newStar = Star(_name, _starStory, _ra, _dec, _mag);

        // register the new star information as a token
        tokenIdToStarInfo[_tokenId] = newStar;
        // register the new star into the starRegistery to prevent duplicated register request
        starRegistry[this.append(_ra, _dec, _mag)] = true;

        // mint: making a new special token. Remember each star is a unique ERC721 token
        // https://openzeppelin.org/api/docs/1.6.0/token_ERC721_ERC721Token.html#_mint
        _mint(msg.sender, _tokenId);

        emit starRegistered(msg.sender);
    }

    function putStarUpForSale(uint256 _tokenId, uint256 _price) public { 
        require(this.ownerOf(_tokenId) == msg.sender, "Only the owner of this star has the right to sale it.");

        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public payable { 
        require(starsForSale[_tokenId] > 0, "Not a valid start to buy.");

        uint256 starCost = starsForSale[_tokenId];
        address starOwner = this.ownerOf(_tokenId);
        
        require(msg.value >= starCost, "You don't have enough ETH to purchase this star.");

        _removeTokenFrom(starOwner, _tokenId);
        _addTokenTo(msg.sender, _tokenId);

        starOwner.transfer(starCost);

        if(msg.value > starCost) { 
            msg.sender.transfer(msg.value - starCost);
        }
    }

    function tokenIDToStarInfo(uint256 _tokenId) public view returns (string memory name, string memory starStory, string memory ra, string memory dec, string memory mag) {
        return (tokenIdToStarInfo[_tokenId].name,
            tokenIdToStarInfo[_tokenId].starStory,
            tokenIdToStarInfo[_tokenId].ra,
            tokenIdToStarInfo[_tokenId].dec,
            tokenIdToStarInfo[_tokenId].mag);
    }

    // method borrowed from https://ethereum.stackexchange.com/questions/729/how-to-concatenate-strings-in-solidity
    // Using ABI encoding functions to append star coordinates into one long string
    function append(string memory _ra, string memory _dec, string memory _mag) public pure returns (string memory) {

        return string(abi.encodePacked(_ra, _dec, _mag));
    }

    function isStarRegistered(string memory _ra, string memory _dec, string memory _mag) public view returns (bool) {
        return starRegistry[this.append(_ra, _dec, _mag)];
    }
}
