// Upload a picture to Pinata
// Code to be reviewed (upload done manually through the website)

const axios = require('axios');
const fs = require('fs');
const path = require('path');
const FormData = require('form-data');
require('dotenv').config();
const pinataApiKey = process.env.PINATA_KEY;
const pinataSecretApiKey = process.env.PINATA_SECRET;

const pinFileToIPFS = async () => {
    try {
        const url = `https://api.pinata.cloud/pinning/pinFileToIPFS`;
        let data = new FormData();
        data.append("file", fs.createReadStream(path.join(__dirname, '../data/black-lotus.jpg')));
        const res = await axios.post(url, data, {
            maxContentLength: "Infinity",
            headers: {
                //   "Content-Type": `multipart/form-data; boundary=${data._boundary}`,
                "Content-Type": `multipart/form-data;`,
                pinata_api_key: pinataApiKey,
                pinata_secret_api_key: pinataSecretApiKey,
            },
        });
        console.log(res.data);
    } catch (err) {
        console.log('Error in uploadFile.js : ', err);
    };
};

pinFileToIPFS();