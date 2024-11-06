const express = require('express');
const user = require('../controllers/user');
const circle = require('../controllers/closeCircle')
const general = require('../controllers/general')
const router = express.Router();

router.post('/api/user', user.createUser);

router.get('/api/user/', user.getData);
router.post('/api/circle/create', circle.createCircle);
router.post('/api/circle/add', circle.add2Circle);
router.delete('/api/circle/remove', circle.removeFromCircle);

router.post('/api/addDangerZone', general.addDangerZone);
router.post('/api/generateRandomLocation', general.generateRandomLocation);

module.exports = router;