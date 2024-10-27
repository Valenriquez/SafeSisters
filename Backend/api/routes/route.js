const express = require('express');
const user = require('../controllers/user');
const circle = require('../controllers/closeCircle')
const router = express.Router();

router.get('/api/user/', user.getData);
router.post('/api/circle/create', circle.createCircle);
router.post('/api/circle/add', circle.add2Circle);
router.delete('/api/circle/remove', circle.removeFromCircle);

module.exports = router;