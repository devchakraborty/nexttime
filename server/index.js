let express = require('express');
let bodyParser = require('body-parser');
let validator = require('express-validator');
let _ = require('lodash');
let util = require('util');
let geolib = require('geolib');
let googlemaps = require('googlemaps');
let gmAPI = new googlemaps({
	key: "AIzaSyDotZw0DuUGQoEW_6P8Ka0_j1LS4HoyC2I",
	secure: true
});
let apn = require('apn');

const MAX_DIST_NOTIF = 5.0; // KM

let people = {};
let reminders = {};

setInterval(() => {
	console.log(people, reminders);
}, 5000);

let app = express();
app.use(bodyParser.json());
app.use(validator({}));

let fbTokenCheck = (req, res, next) => {
	req.checkHeaders('x-fb-token', 'Invalid X-FB-Token header').notEmpty();
	req.fbToken = req.headers['x-fb-token'];
	next();
};

let fbIDCheck = (req, res, next) => {
	req.checkHeaders('x-fb-id', 'Invalid X-FB-ID header').notEmpty();
	req.fbID = req.headers['x-fb-id'];
	next();
};

let reminderCheck = (req, res, next) => {
	console.log("BODY", req.body);
	req.checkBody('id', 'Invalid id field').notEmpty();
	req.checkBody('type', 'Invalid type field').notEmpty();
	req.checkBody('specifier', 'Invalid specifier field').notEmpty();
	req.checkBody('specifier_id', 'Invalid specifier_id field').notEmpty();
	next();
};

let idParamCheck = (req, res, next) => {
	req.checkParams('id', 'Invalid id param').notEmpty();
	next();
};

let latlngCheck = (req, res, next) => {
	req.checkBody('lng', 'Invalid lng field').notEmpty();
	req.checkBody('lat', 'Invalid lat field').notEmpty();
	next();
};

let deviceTokenCheck = (req, res, next) => {
	req.checkBody('device_token', 'Invalid device_token field').notEmpty();
	next();
};

let errorCheck = (req, res, next) => {
	let errors = req.validationErrors();
	if (errors) {
		res.status(400).send({ errors: _.pluck(errors, 'msg') });
		return;
	}
	next();
};

app.post('/login', fbIDCheck, (req, res) => {
	if (people[req.fbID] != null) res.status(200).end();else res.status(401).end();
});

app.post('/register', fbIDCheck, deviceTokenCheck, errorCheck, (req, res) => {
	let fbID = req.fbID,
	    deviceToken = req.body.device_token;
	people[fbID] = {
		fbID: fbID,
		deviceToken: deviceToken
	};
	reminders[fbID] = {};

	res.status(200).end();
});

app.post('/location', fbIDCheck, errorCheck, (req, res) => {
	let lat = req.body.lat,
	    lng = req.body.lng,
	    fbID = req.fbID;
	if (people[fbID] == null) return res.status(401).end();
	people[fbID].location = {
		lat: req.body.lat,
		lng: req.body.lng
	};
	_.each(reminders[fbID], reminder => {

		if (reminder.type == 'near') {
			// place

			gmAPI.placeDetails({ placeid: reminder.specifier_id }, (err, result) => {
				if (err != null) {
					console.error(err);
					return;
				}
				console.log("GP RESULT", result);
				console.log("GP LOCATION", { latitude: lat, longitude: lng }, { latitude: result.result.geometry.location.lat, longitude: result.result.geometry.location.lng });
				let distance = geolib.getDistance({ latitude: lat, longitude: lng }, { latitude: result.result.geometry.location.lat, longitude: result.result.geometry.location.lng }) / 1000;

				console.log("DISTANCE", distance);

				if (distance <= MAX_DIST_NOTIF) {
					console.log("PUSH", fbID, people[fbID].deviceToken, reminders[fbID][reminder.id]);
					// let notif = new
				}
			});
		} else {// with, person

			}
	});
	res.status(200).end();
});

app.get('/reminders', fbIDCheck, errorCheck, (req, res) => {
	let fbID = req.fbID;

	if (reminders[fbID] == null) {
		return res.status(401).end();
	}

	res.json(reminders[fbID]);
});

app.post('/reminders', fbIDCheck, reminderCheck, errorCheck, (req, res) => {
	let fbID = req.fbID,
	    id = req.body.id;

	if (reminders[fbID] == null) {
		return res.status(401).end();
	}

	reminders[fbID][id] = req.body;

	res.status(200).end();
});

app.post('/reminders/:id', idParamCheck, fbIDCheck, errorCheck, (req, res) => {
	let fbID = req.fbID,
	    id = req.params.id;

	if (reminders[fbID] == null) reminders[fbID] = {};

	if (reminders[fbID][id] == null) reminders[fbID][id] = {};

	_.assign(reminders[fbID][id], req.body);

	res.status(200).end();
});

app.delete('/reminders/:id', idParamCheck, fbIDCheck, errorCheck, (req, res) => {
	let fbID = req.fbID,
	    id = req.params.id;

	if (reminders[fbID] == null) {
		reminders[fbID] = {};
		return res.status(200).end();
	}
	if (reminders[fbID][id] == null) {
		return res.status(200).end();
	}

	delete reminders[fbID][id];
	res.status(200).end();
});

app.listen(3000);
