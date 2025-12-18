const express = require('express');
const router = express.Router();
const facilityController = require('../controllers/facilityController');
const authMiddleware = require('../middleware/authMiddleware');

router.get('/facilities', facilityController.getAllFacilities);
router.post('/seed', facilityController.seedFacilities); // Public for ease of use
router.post('/booking', authMiddleware, facilityController.createBooking);

module.exports = router;
