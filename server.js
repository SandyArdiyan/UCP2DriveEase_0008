const express = require('express');
const cors = require('cors');
require('dotenv').config();

// Mengaktifkan koneksi database
const db = require('./config/db');

const app = express();

// Middleware dasar
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ---------------------------------------------------------
// IMPORT ROUTES (Pastikan file ini benar-benar ada di folder routes)
// ---------------------------------------------------------
const authRoutes = require('./routes/authRoutes');
const katalogRoutes = require('./routes/katalogRoutes');
const kategoriRoutes = require('./routes/kategoriRoutes');

// ---------------------------------------------------------
// MENDAFTARKAN ROUTES (Ini yang bikin 404 kalau terlewat)
// ---------------------------------------------------------
app.use('/api', authRoutes);              // Jalur untuk login
app.use('/api/katalog', katalogRoutes);   // Jalur untuk GET, POST, PUT, DELETE Katalog
app.use('/api/kategori', kategoriRoutes); // Jalur untuk GET, POST, PUT, DELETE Kategori

// Jalankan Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server DriveEase menyala di http://localhost:${PORT}`);
});