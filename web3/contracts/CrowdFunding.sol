// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 targetAmount;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donationsAmount;
    }
    // This declares a public mapping named "campaigns" that maps an unsigned integer key to a custom data type "Campaign". The mapping can be accessed from outside the smart contract, and it allows users or applications to read the value associated with a key by calling a public function that reads the mapping.
    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _targetAmount,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        // This line creates a new Campaign instance by looking up the value stored in the "campaigns" mapping at the index of "numberOfCampaigns". The "storage" keyword specifies that the instance of the Campaign struct returned by the mapping should be stored in memory.
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // require campaign deadline should be greater than block timestamp
        require(
            campaign.deadline > block.timestamp,
            "The deadline must be a date in the future"
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.targetAmount = _targetAmount;
        campaign.deadline = _deadline;
        campaign.image = _image;

        numberOfCampaigns++;

        // index of the campaign
        return numberOfCampaigns - 1;
    }
}
