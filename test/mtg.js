const { expectRevert } = require('@openzeppelin/test-helpers');
const MTG = artifacts.require('MTG.sol');
const NFT = artifacts.require('NFT.sol');
const RECEIVER = artifacts.require('Receiver.sol');

const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

contract('MTG', (accounts) => {
    let mtg;
    const [owner, user1] = accounts;
    const text = web3.utils.fromAscii('The Abyss'); // 0x546865204162797373

    beforeEach(async () => {
        mtg = await MTG.new({ from: owner });
        await mtg.create('https://gateway.pinata.cloud/ipfs/QmdsPpTrrWK6256Xpwa9TfbXWo1g3Q6PSYs1jVSQqKSmTS', { from: owner });
    });

    it('should create NFT', async () => {
        const balance = await mtg.balanceOf(owner, 1);
        const uri = await mtg.uri(1);

        assert(balance.toNumber() === 0);
        assert(uri === 'https://gateway.pinata.cloud/ipfs/QmdsPpTrrWK6256Xpwa9TfbXWo1g3Q6PSYs1jVSQqKSmTS')
    });

    it('should mint tokens', async () => {
        const initialBalance = await mtg.balanceOf(owner, 1);
        await mtg.mint(owner, 1, 100, text, { from: owner });
        const finalBalance = await mtg.balanceOf(owner, 1);

        assert(initialBalance.toNumber() === 0);
        assert(finalBalance.toNumber() === 100);
    });

    it('should NOT mint tokens - caller is not the owner', async () => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);

        await expectRevert(
            mtg.mint(user1, 1, 100, text, { from: user1 }),
            'Ownable: caller is not the owner -- Reason given: Ownable: caller is not the owner.'
        );
        await expectRevert(
            nft.mint(owner, 1, 100, text, { from: owner }),
            'Ownable: caller is not the owner -- Reason given: Ownable: caller is not the owner.'
        );
    });

    it('should NOT mint tokens - token does not exist', async () => {
        await expectRevert(
            mtg.mint(owner, 4, 100, text, { from: owner }),
            'token does not exist'
        );
    });

    it('should approve for all', async () => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);

        await mtg.mint(owner, 1, 100, text, { from: owner });
        await nft.setApprovalForAll(user1, true, {from: owner});
        const result = await nft.isApprovedForAll(owner, user1);

        assert(result === true);
    });

    it('should NOT approve for all - self approval', async () => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(owner, 1, 100, text, { from: owner });
    
        await expectRevert(
            nft.setApprovalForAll(owner, true, {from: owner}),
            'ERC1155: setting approval status for self'
        );
    });

    it('should transfer tokens to user', async () => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(owner, 1, 100, text, { from: owner });

        const initialBalanceOwner = await mtg.balanceOf(owner, 1);
        const initialBalanceUser = await mtg.balanceOf(user1, 1);

        await nft.setApprovalForAll(user1, true, {from: owner});
        await nft.safeTransferFrom(owner, user1, 1, 30, text, { from: owner });

        const finalBalanceOwner = await mtg.balanceOf(owner, 1);
        const finallBalanceUser = await mtg.balanceOf(user1, 1);

        assert(initialBalanceOwner.toNumber() === 100);
        assert(initialBalanceUser.toNumber() === 0);
        assert(finalBalanceOwner.toNumber() === 70);
        assert(finallBalanceUser.toNumber() === 30);
    });

    // Remark: owner can transfer tokens without approval
    it('should NOT transfer tokens to user - no approval', async() => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(owner, 1, 100, text, { from: owner });

        await expectRevert(
            nft.safeTransferFrom(owner, user1, 1, 30, text, { from: user1 }),
            'ERC1155: caller is not owner nor approved'
        );
    });

    it('should NOT transfer tokens user - zero address', async() => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(user1, 1, 100, text, { from: owner });

        await expectRevert(
            nft.safeTransferFrom(user1, ZERO_ADDRESS, 1, 30, text, { from: owner }),
            'ERC1155: transfer to the zero address'
        );
    });

    it('should NOT transfer tokens user - insufficient balance', async() => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(user1, 1, 100, text, { from: owner });

        await expectRevert(
            nft.safeTransferFrom(owner, user1, 1, 200, text, { from: owner }),
            'ERC1155: insufficient balance for transfer'
        );
    });

    // Test to send ERC1155 tokens to MTG, and they should be lost
    // Add EIP-165 to prevent stuck tokens in contracts

    it.only('should transfer tokens to contract', async () => {
        const receiver = await RECEIVER.new({ from: owner });
        const addressReceiver = receiver.address;
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);
        await mtg.mint(owner, 1, 100, text, { from: owner });

        const initialBalanceOwner = await mtg.balanceOf(owner, 1);
        const initialBalanceContract = await mtg.balanceOf(addressReceiver, 1);

        await nft.setApprovalForAll(addressReceiver, true, {from: owner});
        await nft.safeTransferFrom(owner, addressReceiver, 1, 30, text, { from: owner });

        const finalBalanceOwner = await mtg.balanceOf(owner, 1);
        const finalBalanceContract = await mtg.balanceOf(addressReceiver, 1);


        assert(initialBalanceOwner.toNumber() === 100);
        assert(initialBalanceContract.toNumber() === 0);
        assert(finalBalanceOwner.toNumber() === 70);
        assert(finalBalanceContract.toNumber() === 30);
    });

    it('should NOT transfer tokens to contract - Non ERC1155Receiver contract', async () => {
        const addressNFT =  await mtg.addressOf(1);
        const nft = await NFT.at(addressNFT);

        await mtg.mint(owner, 1, 100, text, { from: owner });
        await nft.setApprovalForAll(mtg.address, true, {from: owner});

        await expectRevert(
            nft.safeTransferFrom(owner, mtg.address, 1, 30, text, { from: owner }),
            'ERC1155: transfer to non ERC1155Receiver implementer'
        );
    });
});

