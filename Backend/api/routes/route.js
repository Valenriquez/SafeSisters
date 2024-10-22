const express = require('express');
const controllers = require('../controllers/user');
const router = express.Router();

router.get('/api/user/', controllers.getData);

module.exports = router;