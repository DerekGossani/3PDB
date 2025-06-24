

-- SISTEMA DE RESERVAS DE ALBERGUE

-- TABELAS

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE Reserva (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  data_inicio DATE,
  dias INT,
  status ENUM('ativa', 'cancelada'),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_reserva INT,
  data_pagamento DATE,
  metodo_pagamento VARCHAR(50),
  valor DECIMAL(10,2),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);

CREATE TABLE Quarto (
  id_quarto INT AUTO_INCREMENT PRIMARY KEY,
  quantidade_vagas INT,
  tem_banheiro BOOLEAN
);

CREATE TABLE Vaga (
  id_vaga INT AUTO_INCREMENT PRIMARY KEY,
  id_quarto INT,
  identificacao_local VARCHAR(50),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto)
);

CREATE TABLE Peculiaridade (
  id_peculiaridade INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(100)
);


CREATE TABLE Vaga_Peculiaridade (
  id_vaga INT,
  id_peculiaridade INT,
  PRIMARY KEY (id_vaga, id_peculiaridade),
  FOREIGN KEY (id_vaga) REFERENCES Vaga(id_vaga),
  FOREIGN KEY (id_peculiaridade) REFERENCES Peculiaridade(id_peculiaridade)
);


CREATE TABLE Quarto_Peculiaridade (
  id_quarto INT,
  id_peculiaridade INT,
  PRIMARY KEY (id_quarto, id_peculiaridade),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto),
  FOREIGN KEY (id_peculiaridade) REFERENCES Peculiaridade(id_peculiaridade)
);

CREATE TABLE Reserva_Vaga (
  id_reserva INT,
  id_vaga INT,
  PRIMARY KEY (id_reserva, id_vaga),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_vaga) REFERENCES Vaga(id_vaga)
);

CREATE TABLE Reserva_Quarto (
  id_reserva INT,
  id_quarto INT,
  PRIMARY KEY (id_reserva, id_quarto),
  FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
  FOREIGN KEY (id_quarto) REFERENCES Quarto(id_quarto)
);


-- INSERTS

INSERT INTO Cliente (nome, email) VALUES
('Ana Clara', 'ana@gmail.com'),
('Bruno Souza', 'bruno@gmail.com');


INSERT INTO Peculiaridade (descricao) VALUES
('Beliche'),
('Cama de cima'),
('Perto da janela'),
('Sol da manhã'),
('Banheiro no quarto');

INSERT INTO Quarto (quantidade_vagas, tem_banheiro) VALUES
(6, TRUE),
(4, FALSE);

INSERT INTO Quarto_Peculiaridade (id_quarto, id_peculiaridade) VALUES
(1, 5);  

INSERT INTO Vaga (id_quarto, identificacao_local) VALUES
(1, 'Cama 1'),
(1, 'Cama 2'),
(1, 'Cama 3'),
(2, 'Cama A'),
(2, 'Cama B');

INSERT INTO Vaga_Peculiaridade (id_vaga, id_peculiaridade) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

INSERT INTO Reserva (id_cliente, data_inicio, dias, status) VALUES
(1, '2025-07-01', 5, 'ativa'),
(2, '2025-07-05', 3, 'cancelada');


INSERT INTO Pagamento (id_reserva, data_pagamento, metodo_pagamento, valor) VALUES
(1, '2025-06-25', 'Cartão de Crédito', 350.00);

INSERT INTO Reserva_Vaga (id_reserva, id_vaga) VALUES
(1, 1),
(1, 2);

INSERT INTO Reserva_Quarto (id_reserva, id_quarto) VALUES
(2, 2);


-- SELECTs 

SELECT c.nome, v.identificacao_local, r.data_inicio
FROM Cliente c
JOIN Reserva r ON c.id_cliente = r.id_cliente
JOIN Reserva_Vaga rv ON r.id_reserva = rv.id_reserva
JOIN Vaga v ON rv.id_vaga = v.id_vaga;

SELECT v.identificacao_local, p.descricao
FROM Vaga v
JOIN Vaga_Peculiaridade vp ON v.id_vaga = vp.id_vaga
JOIN Peculiaridade p ON vp.id_peculiaridade = p.id_peculiaridade
WHERE v.id_vaga = 1;

-- UPDATE

UPDATE Cliente
SET email = 'ana_clara@gmail.com'
WHERE id_cliente = 1;

DELETE FROM Reserva_Vaga
WHERE id_reserva = 1 AND id_vaga = 2;

DELETE FROM Cliente
WHERE id_cliente = 2;


-- VAGAS DISPONÍVEIS E RESERVADAS NO DIA

-- Vagas reservadas em um determinado dia
SELECT 
  v.id_vaga,
  v.identificacao_local,
  q.id_quarto,
  r.data_inicio,
  r.dias,
  c.nome AS cliente
FROM Reserva r
JOIN Reserva_Vaga rv ON r.id_reserva = rv.id_reserva
JOIN Vaga v ON rv.id_vaga = v.id_vaga
JOIN Quarto q ON v.id_quarto = q.id_quarto
JOIN Cliente c ON r.id_cliente = c.id_cliente
WHERE CURDATE() BETWEEN r.data_inicio AND DATE_ADD(r.data_inicio, INTERVAL r.dias - 1 DAY);

-- Vagas disponíveis no dia (todas que NÃO estão em reserva nesse dia)
SELECT 
  v.id_vaga,
  v.identificacao_local,
  q.id_quarto
FROM Vaga v
JOIN Quarto q ON v.id_quarto = q.id_quarto
WHERE v.id_vaga NOT IN (
  SELECT rv.id_vaga
  FROM Reserva r
  JOIN Reserva_Vaga rv ON r.id_reserva = rv.id_reserva
  WHERE CURDATE() BETWEEN r.data_inicio AND DATE_ADD(r.data_inicio, INTERVAL r.dias - 1 DAY)
);
