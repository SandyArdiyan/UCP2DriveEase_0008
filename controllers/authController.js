const db = require('../config/db');
const jwt = require('jsonwebtoken');
require('dotenv').config();

// ==========================================
// 1. FUNGSI LOGIN
// ==========================================
exports.login = (req, res) => {
    console.log("\n[DEBUG] Data mentah dari Flutter (Login):", req.body);

    const email = (req.body.email || '').trim();
    const password = (req.body.password || '').trim();

    if (!email || !password) {
        console.log("[DEBUG] Tolak: Email atau password kosong!");
        return res.status(400).json({ message: 'Email dan password tidak boleh kosong' });
    }

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

        const token = jwt.sign(
            { id: user.id, email: user.email }, 
            process.env.JWT_SECRET, 
            { expiresIn: '1d' }
        );

        // PERBAIKAN: Mengirimkan properti "nama" secara langsung agar mudah ditangkap Flutter
        res.status(200).json({
            success: true,
            message: 'Login berhasil',
            token: token,
            nama: user.nama || user.username // Mengantisipasi nama kolom di database-mu
        });
    });
};

// ==========================================
// 2. FUNGSI REGISTRASI (INI YANG BARU DITAMBAHKAN)
// ==========================================
exports.register = (req, res) => {
    console.log("\n[DEBUG] Data mentah dari Flutter (Register):", req.body);

    const nama = (req.body.nama || '').trim();
    const email = (req.body.email || '').trim();
    const password = (req.body.password || '').trim();

    if (!nama || !email || !password) {
        console.log("[DEBUG] Tolak: Data registrasi tidak lengkap!");
        return res.status(400).json({ success: false, message: 'Semua kolom wajib diisi!' });
    }

    // Cek dulu apakah email sudah pernah dipakai
    const checkEmailQuery = 'SELECT * FROM user WHERE email = ?';
    db.query(checkEmailQuery, [email], (err, results) => {
        if (err) {
            console.error("[DEBUG] Error Cek Email:", err);
            return res.status(500).json({ success: false, message: 'Terjadi kesalahan server' });
        }

        if (results.length > 0) {
            return res.status(400).json({ success: false, message: 'Email sudah terdaftar!' });
        }

        // Kalau email aman, masukkan data baru ke database (Diasumsikan nama kolom di MySQL adalah: nama, email, password)
        const insertQuery = 'INSERT INTO user (nama, email, password) VALUES (?, ?, ?)';
        db.query(insertQuery, [nama, email, password], (err, result) => {
            if (err) {
                console.error("[DEBUG] Gagal Insert Database:", err);
                // Jika kolom di database-mu bernama 'username' (bukan 'nama'), ganti kata 'nama' di query atas menjadi 'username'
                return res.status(500).json({ success: false, message: 'Gagal menyimpan data ke database', error: err.message });
            }

            console.log("[DEBUG] Registrasi Sukses ID:", result.insertId);
            res.status(200).json({ success: true, message: 'Berhasil' });
        });
    });
};