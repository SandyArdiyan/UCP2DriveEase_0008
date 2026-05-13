const db = require('../config/db');

exports.getAllKategori = (req, res) => {
    db.query('SELECT * FROM kategori', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ data: results });
    });
};

exports.createKategori = (req, res) => {
    const { nama_kategori } = req.body;
    db.query('INSERT INTO kategori (nama_kategori) VALUES (?)', [nama_kategori], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Kategori berhasil ditambahkan' });
    });
};

exports.updateKategori = (req, res) => {
    const { id } = req.params;
    const { nama_kategori } = req.body;
    db.query('UPDATE kategori SET nama_kategori = ? WHERE id = ?', [nama_kategori, id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Kategori berhasil diubah' });
    });
};

exports.deleteKategori = (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM kategori WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Kategori berhasil dihapus' });
    });
};