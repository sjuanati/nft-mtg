const { expectRevert } = require('@openzeppelin/test-helpers');
const MTG = artifacts.require('MTG.sol');
const NFT = artifacts.require('NFT.sol');

const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

contract('MTG', (accounts) => {
    let mtg, nft;
    const [owner, user1] = accounts;
    const text = web3.utils.fromAscii('The Abyss'); // 0x546865204162797373

    beforeEach(async () => {
        mtg = await MTG.new({ from: owner });
        await mtg.create('https://testing.com', { from: owner });
    });

    it('should create NFT', async () => {
        const balance = await mtg.balanceOf(owner, 1);
        const uri = await mtg.uri(1);

        assert(balance.toNumber() === 0);
        assert(uri === 'https://testing.com')
    });

    it('should mint tokens', async () => {
        const initialBalance = await mtg.balanceOf(owner, 1);
        await mtg.mint(owner, 1, 100, text, { from: owner });
        const finalBalance = await mtg.balanceOf(owner, 1);

        assert(initialBalance.toNumber() === 0);
        assert(finalBalance.toNumber() === 100);
    });

    it('should not mint tokens - caller is not the owner', async () => {
        await expectRevert(
            mtg.mint(user1, 1, 100, text, { from: user1 }),
            'Ownable: caller is not the owner -- Reason given: Ownable: caller is not the owner.'
        );
    });

    it('should not mint tokens - token does not exist', async () => {
        await expectRevert(
            mtg.mint(owner, 4, 100, text, { from: owner }),
            'token does not exist'
        );
    });
/*
    it('should transfer tokens', async () => {
        await nft.mint(owner, 1, 100, text, { from: owner });

        const initialBalanceOwner = await mtg.balanceOf(owner, 1);
        const initialBalanceUser = await mtg.balanceOf(user1, 1);

        await nft.setApprovalForAll(mtg.address, true, { from: owner });
        await mtg.transfer(owner, user1, 1, 30, text, { from: owner });

        const finalBalanceOwner = await mtg.balanceOf(owner, 1);
        const finallBalanceUser = await mtg.balanceOf(user1, 1);

        assert(initialBalanceOwner.toNumber() === 100);
        assert(initialBalanceUser.toNumber() === 0);
        assert(finalBalanceOwner.toNumber() === 70);
        assert(finallBalanceUser.toNumber() === 30);
    });

    it('should not transfer tokens - no approval', async() => {
        await nft.mint(owner, 1, 100, text, { from: owner });

        await expectRevert(
            mtg.transfer(owner, user1, 1, 30, text, { from: owner }),
            'ERC1155: caller is not owner nor approved -- Reason given: ERC1155: caller is not owner nor approved.'
        );
    });
*/


});
