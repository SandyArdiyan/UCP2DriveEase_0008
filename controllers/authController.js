const db = require('../config/db');
const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.login = (req, res) => {
    // 1. Log ini akan mencetak data yang dikirim dari HP Pixel ke terminal VS Code
    console.log("\n[DEBUG] Data mentah dari Flutter:", req.body);

    // 2. Amankan dari nilai undefined/null agar tidak error saat di-trim()
    const email = (req.body.email || '').trim();
    const password = (req.body.password || '').trim();

    if (!email || !password) {
        console.log("[DEBUG] Tolak: Email atau password kosong!");
        return res.status(400).json({ message: 'Email dan password tidak boleh kosong' });
    }

    // 3. Eksekusi Query
    const query = 'SELECT * FROM user WHERE email = ? AND password = ?';
    db.query(query, [email, password], (err, results) => {
        if (err) {
            console.error("[DEBUG] Error Database:", err);
            return res.status(500).json({ message: 'Terjadi kesalahan pada server', error: err });
        }

        console.log("[DEBUG] Hasil dari Database:", results.length > 0 ? "Data Ditemukan" : "Data Kosong");

        if (results.length === 0) {
            return res.status(401).json({ message: 'Email atau password salah!' });
        }

        const user = results[0];

        // 4. Generate JWT
        const token = jwt.sign(
            { id: user.id, email: user.email }, 
            process.env.JWT_SECRET, 
            { expiresIn: '1d' }
        );

        res.status(200).json({
            message: 'Login berhasil',
            token: token,
            user: { id: user.id, username: user.username, email: user.email }
        });
    });
};