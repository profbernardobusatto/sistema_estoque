const express = require('express');
const mysql = require('mysql');
const cors = require('cors');
const path = require('path');

const config = require('./config');

const app = express();
app.use(cors());
app.use(express.json());

// Conexão com banco de dados
const db = mysql.createConnection(config.db);

// Abrir tela de login
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// Autenticar login
app.post('/login', (req, res) => {
	let usuario = req.body.usuario
	let senha = req.body.senha

	db.query('SELECT * FROM usuarios WHERE usuario = ? AND senha = ?', 
		[usuario, senha], (err, results) => {
			
		if (results.length > 0) {
			res.json({ 
				success: true,
				nome: results[0].nome,
				usuario: results[0].usuario	
			 });
		} else {
			res.json({ success: false });
		}
	});
});

// listar produtos
app.get('/produtos', (req, res) => {
  db.query('SELECT * FROM produtos', (err, results) => {
    if (err) {
		return res.status(500).json({ error: err });
	}
	
    res.json(results);
  });
});



app.listen(3000, () => {
  console.log('Servidor rodando em http://localhost:3000');
});