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

    // payable signifies that we are going to send some cryptocurrency with the function call
    function donateToCampaign(uint256 _id) public payable {
        // this is what we are trying to send from out front end
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        // we want to push the address of the person who is donating to the donators array
        campaign.donators.push(msg.sender);
        // we want to push the amount of the donation to the donationsAmount array
        campaign.donationsAmount.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    // view means it's only going to read data from the blockchain
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        // we are returning two arrays which are the donators and the donationsAmount
        return (campaigns[_id].donators, campaigns[_id].donationsAmount);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        // we are returning an array of campaigns
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        // we are looping through the campaigns and storing them in the allCampaigns array
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}
