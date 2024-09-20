// server.js
const https = require('https');
const fs = require('fs');


const options = {
    key: fs.readFileSync('./certs/old/server.key'), // replace it with your key path
    cert: fs.readFileSync('./certs/old/server.crt'), // replace it with your certificate path
    secureProtocol: "TLSv1_2_method",    
    ciphers: 'AES256-SHA256:AES256-SHA:AES128-SHA256:AES128-SHA:RC4-SHA:RC4-MD5:DES-CBC3-SHA',
    honorCipherOrder: true 
}

https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end('Hello, janderson essa é resposta janderson janderson HTTPS World!');
}).listen(443, () => {
  console.log('Server is running on port 443');
});