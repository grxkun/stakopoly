// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./StakingPool.sol";

contract StakingPoolFactory {
    address[] public allPools;

    event PoolCreated(
        address indexed poolAddress,
        address indexed creator,
        address indexed nftCollection,
        address rewardToken
    );

    function createPool(
        address _nftCollection,
        address _rewardToken,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _emissionRatePerDay
    ) external returns (address poolAddress) {
        require(_nftCollection != address(0), "Invalid NFT collection address");
        require(_rewardToken != address(0), "Invalid reward token address");
        require(_startTime < _endTime, "Start time must be before end time");
        require(_startTime >= block.timestamp, "Start time must be in the future");

        StakingPool newPool = new StakingPool(
            _nftCollection,
            _rewardToken,
            _startTime,
            _endTime,
            _emissionRatePerDay
        );
        
        poolAddress = address(newPool);
        allPools.push(poolAddress);
        
        newPool.transferOwnership(msg.sender);

        emit PoolCreated(poolAddress, msg.sender, _nftCollection, _rewardToken);
    }

    function getAllPools() external view returns (address[] memory) {
        return allPools;
    }

    function totalPools() external view returns (uint256) {
        return allPools.length;
    }
}
