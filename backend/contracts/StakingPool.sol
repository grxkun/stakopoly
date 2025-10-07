// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingPool is Ownable, ReentrancyGuard {
    IERC721 public immutable nftCollection;
    IERC20 public immutable rewardToken;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public emissionRate; // Tokens per second

    struct Staker {
        uint256 amountStaked;
        uint256 rewards;
        uint256 lastUpdateTime;
    }

    mapping(address => Staker) public stakers;
    mapping(uint256 => address) public tokenIdToOwner;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256[] tokenIds);
    event Unstaked(address indexed user, uint256[] tokenIds);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(
        address _nftCollection,
        address _rewardToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _emissionRatePerDay
    ) {
        nftCollection = IERC721(_nftCollection);
        rewardToken = IERC20(_rewardToken);
        startTime = _startTime;
        endTime = _endTime;
        emissionRate = _emissionRatePerDay / (24 * 60 * 60); // Convert daily rate to per second
    }

    function _updateRewards(address _user) internal {
        Staker storage staker = stakers[_user];
        if (staker.amountStaked > 0) {
            uint256 timePassed = block.timestamp - staker.lastUpdateTime;
            if (timePassed > 0) {
                uint256 currentPoolTime = block.timestamp > endTime ? endTime : block.timestamp;
                uint256 rewardPeriod = currentPoolTime - staker.lastUpdateTime;
                uint256 newRewards = (rewardPeriod * emissionRate * staker.amountStaked) / totalStaked;
                staker.rewards += newRewards;
            }
        }
        staker.lastUpdateTime = block.timestamp;
    }

    function stake(uint256[] calldata _tokenIds) external nonReentrant {
        require(block.timestamp >= startTime, "Staking has not started yet");
        require(block.timestamp <= endTime, "Staking has already ended");
        require(_tokenIds.length > 0, "No token IDs provided");

        _updateRewards(msg.sender);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            require(nftCollection.ownerOf(tokenId) == msg.sender, "You do not own this NFT");
            require(tokenIdToOwner[tokenId] == address(0), "NFT already staked");

            nftCollection.transferFrom(msg.sender, address(this), tokenId);
            tokenIdToOwner[tokenId] = msg.sender;
        }

        stakers[msg.sender].amountStaked += _tokenIds.length;
        totalStaked += _tokenIds.length;

        emit Staked(msg.sender, _tokenIds);
    }

    function unstake(uint256[] calldata _tokenIds) external nonReentrant {
        require(_tokenIds.length > 0, "No token IDs provided");

        _updateRewards(msg.sender);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            require(tokenIdToOwner[tokenId] == msg.sender, "You did not stake this NFT");

            nftCollection.transferFrom(address(this), msg.sender, tokenId);
            delete tokenIdToOwner[tokenId];
        }

        stakers[msg.sender].amountStaked -= _tokenIds.length;
        totalStaked -= _tokenIds.length;

        emit Unstaked(msg.sender, _tokenIds);
    }

    function claimRewards() external nonReentrant {
        _updateRewards(msg.sender);

        uint256 rewardsToClaim = stakers[msg.sender].rewards;
        require(rewardsToClaim > 0, "No rewards to claim");

        stakers[msg.sender].rewards = 0;
        
        require(rewardToken.balanceOf(address(this)) >= rewardsToClaim, "Not enough reward tokens in pool");
        rewardToken.transfer(msg.sender, rewardsToClaim);

        emit RewardsClaimed(msg.sender, rewardsToClaim);
    }
    
    function addRewards(uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        rewardToken.transferFrom(msg.sender, address(this), _amount);
    }

    function viewRewards(address _user) external view returns (uint256) {
        Staker memory staker = stakers[_user];
        uint256 pendingRewards = staker.rewards;
        if (staker.amountStaked > 0 && block.timestamp > staker.lastUpdateTime) {
            uint256 currentPoolTime = block.timestamp > endTime ? endTime : block.timestamp;
            uint256 rewardPeriod = currentPoolTime - staker.lastUpdateTime;
            pendingRewards += (rewardPeriod * emissionRate * staker.amountStaked) / totalStaked;
        }
        return pendingRewards;
    }
}
