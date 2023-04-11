// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    uint256 balance;
    bool active;
}
contract DonateCryptoRDM {
    uint256 public fee = 100;
    uint256 public index;

    mapping (uint256 => Campaign) public campaigns;

    function addCampaign(
        string calldata title, 
        string calldata description, 
        string calldata videoUrl
        ) public {
        Campaign memory campaign;
        campaign.title = title;
        campaign.description = description;
        campaign.videoUrl = videoUrl;
        campaign.active = true;
        campaign.author = msg.sender;
        
        index++;
        campaigns[index] = campaign;
    }

    function donate(uint256 id) public payable {
        require(id > 0, "This campaign does not exists");
        require(msg.value > 0, "You must send a donation value > 0");
        require(campaigns[id].active == true, "Cannot donate to this campaign");

        campaigns[id].balance = msg.value;
    }

    function withdraw(uint256 id) public {
        Campaign memory campaign = campaigns[id];

        require(campaign.author == msg.sender, "You do not have permission");
        require(campaign.active == true, "This campaign is closed");
        require(campaign.balance > fee, "This campaign does not have enough balance");

        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - fee}("Finish process");

        campaigns[id].active = false;
    }
}
