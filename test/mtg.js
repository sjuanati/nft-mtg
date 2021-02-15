const { expectRevert } = require('@openzeppelin/test-helpers');
const MTG = artifacts.require('MTG.sol');
const NFT = artifacts.require('NFT.sol');

contract('MTG', (accounts) => {
    let mtg, nft;
    const [owner] = accounts;

    beforeEach(async() => {
        nft = await NFT.new('https://testing.com');
        mtg = await MTG.new(nft.address);
    });

    it('should create NFT', async() => {
        const text = web3.utils.fromAscii('Test Proposal');
        await mtg.mint(owner, 1, 100, text);
        const bal = await mtg.balanceOf(owner, 1);
        console.log('bal', bal.toString());
    });


});
