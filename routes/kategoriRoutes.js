const express = require('express');
const router = express.Router();
const kategoriController = require('../controllers/kategoriController');
const verifyToken = require('../middleware/authMiddleware');

// Pasang verifyToken agar rute ini aman
router.get('/', verifyToken, kategoriController.getAllKategori);
router.post('/', verifyToken, kategoriController.createKategori);
router.put('/:id', verifyToken, kategoriController.updateKategori);
router.delete('/:id', verifyToken, kategoriController.deleteKategori);

module.exports = router;