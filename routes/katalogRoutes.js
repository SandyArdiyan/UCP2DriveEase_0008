const express = require('express');
const router = express.Router();
const katalogController = require('../controllers/katalogController');
const verifyToken = require('../middleware/authMiddleware'); // Satpam JWT

// Rute ini akan dipanggil saat Flutter meminta /api/katalog
router.get('/', verifyToken, katalogController.getAllKatalog);
router.post('/', verifyToken, katalogController.createKatalog);
router.put('/:id', verifyToken, katalogController.updateKatalog);
router.delete('/:id', verifyToken, katalogController.deleteKatalog);

module.exports = router;