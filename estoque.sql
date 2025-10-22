CREATE DATABASE IF NOT EXISTS sistema_estoque;

USE sistema_estoque;


CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome_completo VARCHAR(100) NOT NULL,
  nome_usuario VARCHAR(50) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  marca VARCHAR(50),
  preco DECIMAL(10,2) NOT NULL,
  cor VARCHAR(30),
  peso DECIMAL(10,2),
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  quantidade INT DEFAULT 0,
  FOREIGN KEY (produto_id) REFERENCES produtos(id)
    ON DELETE CASCADE
);


CREATE TABLE log_estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  alteracao INT NOT NULL,
  usuario VARCHAR(50) NOT NULL,
  token VARCHAR(255) NOT NULL,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (produto_id) REFERENCES produtos(id)
  ON DELETE cascade
);


INSERT INTO usuarios (nome_completo, nome_usuario, senha)
VALUES
('Administrador do Sistema', 'admin', '$2a$10$GoggPlyqu/9Xhl2HkxDMseO2RjDlnOu4yG4jlWcQZC7.E6OmxcZiK'),
('Maria Oliveira', 'maria', '$2a$10$GoggPlyqu/9Xhl2HkxDMseO2RjDlnOu4yG4jlWcQZC7.E6OmxcZiK'),
('João Silva', 'joao', '$2a$10$GoggPlyqu/9Xhl2HkxDMseO2RjDlnOu4yG4jlWcQZC7.E6OmxcZiK'),
('Ana Costa', 'ana', '$2a$10$GoggPlyqu/9Xhl2HkxDMseO2RjDlnOu4yG4jlWcQZC7.E6OmxcZiK'),
('Carlos Pereira', 'carlos', '$2a$10$GoggPlyqu/9Xhl2HkxDMseO2RjDlnOu4yG4jlWcQZC7.E6OmxcZiK');

INSERT INTO produtos (nome, marca, preco, cor, peso)
VALUES
('Mouse óptico', 'Logitech', 79.90, 'Preto', 0.2),
('Teclado mecânico', 'Redragon', 249.90, 'Preto', 1.0),
('Monitor 24"', 'Samsung', 899.00, 'Preto', 3.5),
('Cadeira gamer', 'ThunderX3', 1299.90, 'Vermelha', 18.0),
('Headset', 'HyperX', 399.00, 'Preto', 0.4),
('Notebook 15"', 'Dell', 4999.00, 'Cinza', 2.2),
('HD Externo 1TB', 'Seagate', 399.90, 'Preto', 0.3),
('Pendrive 64GB', 'Kingston', 89.90, 'Azul', 0.05),
('Webcam Full HD', 'Logitech', 349.90, 'Preta', 0.2),
('Caixa de Som Bluetooth', 'JBL', 599.90, 'Azul', 0.7),
('Impressora Multifuncional', 'HP', 799.90, 'Branca', 6.5),
('Mousepad Gamer', 'Redragon', 59.90, 'Preto', 0.25),
('Microfone USB', 'Fifine', 329.90, 'Preto', 0.6),
('Monitor 27"', 'LG', 1299.90, 'Preto', 4.0),
('Smartphone', 'Samsung', 2499.00, 'Prata', 0.18);


INSERT INTO estoque (produto_id, quantidade)
VALUES
(1, 12),
(2, 5),
(3, 7),
(4, 3),
(5, 10),
(6, 4),
(7, 15),
(8, 25),
(9, 8),
(10, 9),
(11, 6),
(12, 40),
(13, 5),
(14, 2),
(15, 10);

INSERT INTO log_estoque (produto_id, alteracao, usuario, token, data_hora)
VALUES
(1, +5, 'admin', 'token1', NOW() - INTERVAL 5 DAY),
(2, -1, 'maria', 'token2', NOW() - INTERVAL 3 DAY),
(3, +2, 'joao', 'token3', NOW() - INTERVAL 2 DAY),
(4, -1, 'ana', 'token4', NOW() - INTERVAL 1 DAY),

(5, +10, 'carlos', 'token5', NOW());
