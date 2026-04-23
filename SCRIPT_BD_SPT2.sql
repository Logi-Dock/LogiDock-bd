CREATE DATABASE logi_dock;

USE logi_dock;

CREATE TABLE endereco (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    numero VARCHAR(10),
    cidade VARCHAR(45),
    estado CHAR(2),
    logradouro VARCHAR(100)
);
CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(45),
    cnpj CHAR(14),
    dt_registro DATE,
    fk_endereco INT,
    CONSTRAINT ct_fk_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco)
);

CREATE TABLE sensor (
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo_sensor VARCHAR(45),
    marca_sensor VARCHAR(45),
    fk_doca INT,
    CONSTRAINT ct_fk_doca FOREIGN KEY (fk_doca) REFERENCES doca(id_doca)
);

select * from historico_sensor;
truncate historico_sensor;


INSERT INTO sensor(modelo_sensor, marca_sensor, fk_doca) VALUES
('HC-SR04', 'Genérico', 1);

CREATE TABLE historico_sensor (
	id_historico_sensor INT PRIMARY KEY AUTO_INCREMENT,
    dt_registro DATETIME,
    status_sensor TINYINT(1),
    fk_sensor INT,
    CONSTRAINT ct_fk_sensor FOREIGN KEY (fk_sensor) REFERENCES sensor (id_sensor)
);
select * from doca;
CREATE TABLE doca (
	id_doca INT PRIMARY KEY AUTO_INCREMENT,
    numero VARCHAR(10),
    status_doca VARCHAR(15),
    fk_empresa INT,
    CONSTRAINT fk_ck_status_doca CHECK (status_doca IN ('LIVRE', 'OCUPADA', 'MANUTENÇÃO')),
    CONSTRAINT fk_ct_fk_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa)
);

CREATE TABLE nivel_acesso (
	id_nivel_acesso INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    CONSTRAINT ct_ck_nome CHECK (nome IN ('ADMINISTRADOR', 'GESTOR', 'FUNCIONÁRIO'))
);

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(20),
    fk_empresa INT,
    fk_nivel_acesso INT,
    CONSTRAINT f_k_ct_fk_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa),
    CONSTRAINT f_k_ct_fk_nivel_acesso FOREIGN KEY (fk_nivel_acesso) REFERENCES nivel_acesso (id_nivel_acesso)
);

CREATE TABLE permissao (
	id_permissao INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    descricao VARCHAR(150)
);

CREATE TABLE permissoes_compartilhadas (
	id_permissoes_compartilhadas INT PRIMARY KEY AUTO_INCREMENT,
    fk_nivel_acesso INT,
    fk_permissao INT,
    CONSTRAINT ct_fk_nivel_acesso FOREIGN KEY (fk_nivel_acesso) REFERENCES nivel_acesso (id_nivel_acesso),
    CONSTRAINT ct_fk_permissao FOREIGN KEY (fk_permissao) REFERENCES permissao (id_permissao)
);

INSERT INTO endereco (numero, cidade, estado, logradouro) VALUES
('100', 'São Paulo', 'SP', 'Av. Paulista'),
('2500', 'Campinas', 'SP', 'Rod. Anhanguera'),
('45', 'Santos', 'SP', 'Av. Portuária');

INSERT INTO empresa (razao_social, cnpj, dt_registro, fk_endereco) VALUES
('Logística Brasil LTDA', '12345678000199', '2024-01-10', 1),
('TransPorto SA', '98765432000188', '2023-08-20', 2),
('Dock Solutions', '45678912000155', '2025-02-15', 3);

INSERT INTO sensor (fk_empresa, status_sensor) VALUES
(1, 1),
(1, 0),
(2, 0),
(3, 1);

INSERT INTO doca (numero, status_doca, fk_empresa) VALUES
('D01', 'OCUPADA', 1),
('D02', 'LIVRE', 1),
('A01', 'MANUTENÇÃO', 2),
('B15', 'OCUPADA', 3);

INSERT INTO historico_sensor (fk_sensor, dt_hora_entrada, dt_hora_saida) VALUES
(1, '2026-03-25 10:00:00', NULL),
(2, '2026-03-25 07:45:00', '2026-03-25 08:20:00'),
(4, '2026-03-25 09:00:00', NULL);

INSERT INTO nivel_acesso (nome) VALUES
('ADMINISTRADOR'),
('FUNCIONÁRIO'),
('GESTOR');

INSERT INTO permissao (nome, descricao) VALUES
('CRIAR_DOCA', 'Permite cadastrar novas docas'),
('EDITAR_DOCA', 'Permite editar docas'),
('VISUALIZAR_DOCA', 'Permite visualizar docas'),
('GERENCIAR_USUARIOS', 'Permite gerenciar usuários');

INSERT INTO usuario (nome, email, senha, fk_empresa, fk_nivel_acesso) VALUES
('Carlos Silva', 'carlos@logbrasil.com', '123456', 1, 1),
('Ana Souza', 'ana@logbrasil.com', '123456', 1, 2),
('Marcos Lima', 'marcos@transporto.com', '123456', 2, 3),
('Fernanda Costa', 'fernanda@docksolutions.com', '123456', 3, 3);

INSERT INTO permissoes_compartilhadas (fk_nivel_acesso, fk_permissao) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 3),
(3, 1),
(3, 2),
(3, 3);

SELECT
    e.razao_social AS 'Nome da Empresa',
    d.numero AS 'Número da Doca',
    d.status_doca AS 'Status da Doca',
    s.status_sensor AS 'Status do Sensor',
    hs.dt_hora_entrada AS 'Data da Entrada',
    hs.dt_hora_saida AS 'Data de Saída'
FROM empresa e
JOIN doca d
    ON d.fk_empresa = e.id_empresa
JOIN sensor s
    ON d.fk_sensor = s.id_sensor
JOIN historico_sensor hs
    ON hs.fk_sensor = s.id_sensor;
    
SELECT
    u.nome AS 'Usuário',
    na.nome AS 'Nivel de Acesso',
    p.nome AS 'Permissão'
FROM usuario u
JOIN nivel_acesso na
    ON u.fk_nivel_acesso = na.id_nivel_acesso
JOIN permissoes_compartilhadas pc
    ON pc.fk_nivel_acesso = na.id_nivel_acesso
JOIN permissao p
    ON p.id_permissao = pc.fk_permissao
ORDER BY na.nome;