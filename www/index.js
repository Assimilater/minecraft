// Very barebones routing for minecraft viewer
const { readdirSync, statSync } = require('fs');
const { join } = require('path');
const util = require('util');

const express = require('express');
const app = express();
const port = 80;

const mcsroot = '/minecraft/servers';
const wwwroot = '/minecraft/www'; // __dirname

// At the core, we really only have one html file to serve
app.get('/', (req, res) => {
	res.sendFile(join(wwwroot + '/index.html'));
});

// index.html will use ajax to ask for info about the servers/backups on page load
app.get('/fetch', (req, res) => {
	var info = {};
	console.log('fetch started');
	readdirSync(mcsroot).forEach(function(dir) {
		serverpath = join(mcsroot, dir);
		console.log('server: ' + serverpath);
		if(statSync(serverpath).isDirectory()) {
			var server = { name: dir };
			var periods = [ 'daily', 'weekly', 'monthly' ];
			periods.forEach(function(period) {
				server[period] = [];
				var periodpath = join(serverpath, 'backups', period);
				console.log('\tperiod: ' + periodpath);
				readdirSync(periodpath).forEach(function(date) {
					var backuppath = join(periodpath, date);
					console.log('\t\tbackup: ' + backuppath);
					if(statSync(backuppath).isDirectory()) {
						server[period].push(date);
					}
				});
			});
			info[dir] = server;
		}
	});
	console.log('fetch finished');
	res.json(info);
});

app.get('/download/:server/:period/:date?', (req, res) => {
	var date = req.params['date'] || "";
	if (date !== "") {
		date += '/';
	}

	var file = util.format('%s/%s/backups/%s/%s%s',
		mcsroot, req.params['server'], req.params['period'], date, 'world.zip');

	console.log(util.format("downloading file: %s", file));

	res.download(file);
});

app.get('/overviewer/:server/:period/:date?/*', (req, res) => {
	var path = req.params[0] || "index.html";

	var date = req.params['date'] || "";
	if (date !== "") {
		date += '/';
	}

	var file = util.format('%s/%s/backups/%s/%s%s',
		mcsroot, req.params['server'], req.params['period'], date, path);

	console.log(util.format("sending file: %s", file));

	res.sendFile(file);
});

app.listen(port, () => console.log(`Listining on port ${port}...`));
