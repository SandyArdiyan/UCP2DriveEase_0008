const db = require('../config/db');

exports.getAllKatalog = (req, res) => {
    // Menangkap kata kunci pencarian dari query string
    const keyword = req.query.search || '';
    
    // Query SQL untuk Search berdasarkan nama armada atau plat nomor
    const sql = "SELECT * FROM katalog WHERE nama_armada LIKE ? OR plat_nomor LIKE ?";
    const queryValue = `%${keyword}%`;

    db.query(sql, [queryValue, queryValue], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ data: results });
    });
};

exports.createKatalog = (req, res) => {
    const { nama_armada, id_kategori, plat_nomor } = req.body;
    db.query('INSERT INTO katalog (nama_armada, id_kategori, plat_nomor) VALUES (?, ?, ?)', 
    [nama_armada, id_kategori, plat_nomor], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Armada berhasil ditambahkan' });
    });
};

exports.updateKatalog = (req, res) => {
    const { id } = req.params;
    const { nama_armada, id_kategori, plat_nomor } = req.body;
    db.query('UPDATE katalog SET nama_armada = ?, id_kategori = ?, plat_nomor = ? WHERE id = ?', 
    [nama_armada, id_kategori, plat_nomor, id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Armada berhasil diubah' });
    });
};

exports.deleteKatalog = (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM katalog WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ message: 'Armada berhasil dihapus' });
    });
};