const jwt = require('jsonwebtoken');
require('dotenv').config();

const verifyToken = (req, res, next) => {
    // Mengambil token dari header Authorization
    const authHeader = req.header('Authorization');
    const token = authHeader && authHeader.split(' ')[1]; // Format: "Bearer <token>"

    if (!token) {
        return res.status(401).json({ 
            status: false, 
            message: 'Akses ditolak. Token autentikasi tidak ditemukan!' 
        });
    }

    try {
        // Verifikasi token dengan secret key
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        req.user = verified; 
        next(); // Token valid, izinkan lanjut ke proses CRUDS
    } catch (error) {
        res.status(403).json({ 
            status: false, 
            message: 'Token tidak valid atau sesi telah habis!' 
        });
    }
};

module.exports = verifyToken;