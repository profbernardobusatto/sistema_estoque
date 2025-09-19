const express = require('express');
const mysql = require('mysql2'); // ← Corrigido o import
const cors = require('cors');
const path = require('path');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
const config = require('./config');

const app = express();
app.use(cors());
app.use(express.json());

// Conexão com o banco de dados MySQL
let connection; 

connection = mysql.createConnection(config.db);
  
connection.connect((err) => {
	if (err) {
		console.error('Erro ao conectar ao banco de dados MySQL:', err);
		process.exit(1);
	} 
});


// Tela de login
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/index.html'));
});

// autenticar login
app.post('/login', async (req, res) => {
  try {
    let usuario = req.body.usuario;
    let senha = req.body.senha;
    let sessionToken = crypto.randomBytes(64).toString('hex');
    
    // Executar query com promise
    const [results] = await connection.promise().query(
      'SELECT * FROM usuarios WHERE nome_usuario = ?', 
      [usuario]
    );
	
    // Usuário não encontrado
    if (results.length === 0) {
      return res.json({ 
        success: false, 
        message: 'Usuário não encontrado' 
      });
    }

    const user = results[0];
	
    // Comparar senhas com await
    const senhaConfere = await bcrypt.compare(senha, user.senha);
    
    if (!senhaConfere) {
      return res.json({ 
        success: false, 
        message: 'Senha incorreta' 
      });
    }

    res.json({ 
      success: true,
      nome: user.nome_completo,
      usuario: user.nome_usuario,
      sessionToken: sessionToken
    });

  } catch (err) {
    console.error('Erro no login:', err);
    res.status(500).json({ 
      success: false, 
      message: 'Erro no servidor' 
    });
  }
});

// pagina produtos
app.get('/produtos', (req, res) => {
	// Enviar arquivo HTML
	res.sendFile(path.join(__dirname, '../frontend/produtos.html'));
});

// busca produtos
app.get('/produtos/lista', (req, res) => {
	// busca dados da tabela de estoque no banco de dados com join na tabela de produtos buscando nome, marca, preco, cor, peso
	const results = connection.query(
	`SELECT p.nome, p.marca, p.preco, p.cor, p.peso, p.id, e.quantidade 
	 FROM produtos p
	 JOIN estoque e ON p.id = e.produto_id`,
		(err, results) => {
			if (err) {
				console.error('Erro ao buscar produtos:', err);
				return res.status(500).send('Erro ao buscar produtos');
			}

			res.json(results);
		}
	);		

});

// Iniciar servidor
app.listen(3000, () => {
  console.log('Servidor rodando em http://localhost:3000');
});