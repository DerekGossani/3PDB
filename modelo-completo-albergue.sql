

-- MODELO COMPLETO - SISTEMA DE RESERVAS DE ALBERGUE

-- TABELAS

-- Cliente
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100)
);

-- Reserva
CREATE TABLE Reserva (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  data_inicio DATE,
  dias INT,
  status ENUM('ativa', 'cancelada'),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Pagamento
CREATE TABLE Pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_reserva INT,
  data_pagamento DATE,
  metodo_pagamento VARCHAR(50),
  valor DECIMAL(10,2),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);

-- Quarto
CREATE TABLE Quarto (
  id_quarto INT AUTO_INCREMENT PRIMARY KEY,
  quantidade_vagas INT,
  tem_banheiro BOOLEAN
);

-- Vaga (cama)
CREATE TABLE Vaga (
  id_vaga INT AUTO_INCREMENT PRIMARY KEY,
  id_quarto INT,
  identificacao_local VARCHAR(50),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto)
);

-- Peculiaridade
CREATE TABLE Peculiaridade (
  id_peculiaridade INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(100)
);

-- Vaga_Peculiaridade (N:M)
CREATE TABLE Vaga_Peculiaridade (
  id_vaga INT,
  id_peculiaridade INT,
  PRIMARY KEY (id_vaga, id_peculiaridade),
  FOREIGN KEY (id_vaga) REFERENCES Vaga(id_vaga),
  FOREIGN KEY (id_peculiaridade) REFERENCES Peculiaridade(id_peculiaridade)
);

-- Quarto_Peculiaridade (N:M)
CREATE TABLE Quarto_Peculiaridade (
  id_quarto INT,
  id_peculiaridade INT,
  PRIMARY KEY (id_quarto, id_peculiaridade),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto),
  FOREIGN KEY (id_peculiaridade) REFERENCES Peculiaridade(id_peculiaridade)
);

-- Reserva_Vaga (N:M)
CREATE TABLE Reserva_Vaga (
  id_reserva INT,
  id_vaga INT,
  PRIMARY KEY (id_reserva, id_vaga),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_vaga) REFERENCES Vaga(id_vaga)
);

-- Reserva_Quarto (N:M)
CREATE TABLE Reserva_Quarto (
  id_reserva INT,
  id_quarto INT,
  PRIMARY KEY (id_reserva, id_quarto),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto)
);


-- INSERTS DE EXEMPLO

-- Clientes
INSERT INTO Cliente (nome, email) VALUES
('Ana Clara', 'ana@gmail.com'),
('Bruno Souza', 'bruno@gmail.com');

-- Peculiaridades
INSERT INTO Peculiaridade (descricao) VALUES
('Beliche'),
('Cama de cima'),
('Perto da janela'),
('Sol da manhã'),
('Banheiro no quarto');

-- Quartos
INSERT INTO Quarto (quantidade_vagas, tem_banheiro) VALUES
(6, TRUE),
(4, FALSE);

-- Quarto_Peculiaridade
INSERT INTO Quarto_Peculiaridade (id_quarto, id_peculiaridade) VALUES
(1, 5);  -- Banheiro no quarto

-- Vagas
INSERT INTO Vaga (id_quarto, identificacao_local) VALUES
(1, 'Cama 1'),
(1, 'Cama 2'),
(1, 'Cama 3'),
(2, 'Cama A'),
(2, 'Cama B');

-- Vaga_Peculiaridade
INSERT INTO Vaga_Peculiaridade (id_vaga, id_peculiaridade) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

-- Reservas
INSERT INTO Reserva (id_cliente, data_inicio, dias, status) VALUES
(1, '2025-07-01', 5, 'ativa'),
(2, '2025-07-05', 3, 'cancelada');

-- Pagamentos
INSERT INTO Pagamento (id_reserva, data_pagamento, metodo_pagamento, valor) VALUES
(1, '2025-06-25', 'Cartão de Crédito', 350.00);

-- Reserva_Vaga
INSERT INTO Reserva_Vaga (id_reserva, id_vaga) VALUES
(1, 1),
(1, 2);

-- Reserva_Quarto
INSERT INTO Reserva_Quarto (id_reserva, id_quarto) VALUES
(2, 2);

-- SELECTs DE TESTE

-- Vagas reservadas por cliente
SELECT c.nome, v.identificacao_local, r.data_inicio
FROM Cliente c
JOIN Reserva r ON c.id_cliente = r.id_cliente
JOIN Reserva_Vaga rv ON r.id_reserva = rv.id_reserva
JOIN Vaga v ON rv.id_vaga = v.id_vaga;

-- Quartos com banheiro
SELECT * FROM Quarto WHERE tem_banheiro = TRUE;

-- Peculiaridades de uma vaga
SELECT v.identificacao_local, p.descricao
FROM Vaga v
JOIN Vaga_Peculiaridade vp ON v.id_vaga = vp.id_vaga
JOIN Peculiaridade p ON vp.id_peculiaridade = p.id_peculiaridade
WHERE v.id_vaga = 1;

-- UPDATE / DELETE EXEMPLOS

UPDATE Cliente
SET email = 'ana_clara@gmail.com'
WHERE id_cliente = 1;

DELETE FROM Reserva_Vaga
WHERE id_reserva = 1 AND id_vaga = 2;

DELETE FROM Cliente
WHERE id_cliente = 2;
