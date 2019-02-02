const express = require('express');
const app = express();
const path = require('path');
const util = require('util');
const port = 80;

app.get('/', (req, res) => {
	res.sendFile(path.join(__dirname + '/index.html'));
});

app.get('/fetch', (req, res) => {
	var info = { servers: [] };
	
	res.json(info);
});

app.get('/download/:server/:period/:date?', (req, res) => {
	res.json(req.params);
});

app.get('/overviewer/:server/:period/:date?/*', (req, res) => {
	var path = req.params[0] || "index.html";
	var date = req.params['date'] || "";
	if (date !== "") {
		date += '/';
	}
	var file = util.format('/minecraft/servers/%s/backups/%s/%s%s',
		req.params['server'], req.params['period'], date, path);
	console.log(util.format("sending file: %s", file));
	res.sendFile(file);
});

app.listen(port, () => console.log(`Listining on port ${port}...`));
