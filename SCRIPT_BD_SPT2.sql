CREATE DATABASE logi_dock;
USE logi_dock;

CREATE TABLE endereco (
	id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    numero_endereco VARCHAR(10),
    cidade VARCHAR(45),
    estado CHAR(2),
    logradouro VARCHAR(100)
);

CREATE TABLE empresa (
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    razao_social VARCHAR(45),
    cnpj CHAR(14),
    dt_registro DATE,
    horario_inicio_expediente TIME,
    horario_final_expediente TIME,
    fk_endereco INT,
    CONSTRAINT empresa_fk_endereco FOREIGN KEY (fk_endereco) REFERENCES endereco (id_endereco)
);

CREATE TABLE doca (
	id_doca INT PRIMARY KEY AUTO_INCREMENT,
    numero_doca VARCHAR(10),
    status_doca VARCHAR(15),
    fk_empresa INT,
    CONSTRAINT ct_status_doca CHECK (status_doca IN ('ATIVO', 'INATIVO')),
    CONSTRAINT doca_fk_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa)
);

CREATE TABLE sensor (
	id_sensor INT PRIMARY KEY AUTO_INCREMENT,
    modelo_sensor VARCHAR(45) DEFAULT 'HC-SR04',
    fk_doca INT,
    CONSTRAINT sensor_fk_doca FOREIGN KEY (fk_doca) REFERENCES doca(id_doca)
);

CREATE TABLE historico_sensor (
	id_historico_sensor INT PRIMARY KEY AUTO_INCREMENT,
    dt_registro DATETIME,
    status_sensor TINYINT(1),
    fk_sensor INT,
    CONSTRAINT historico_fk_sensor FOREIGN KEY (fk_sensor) REFERENCES sensor (id_sensor)
);

CREATE TABLE nivel_acesso (
	id_nivel_acesso INT PRIMARY KEY AUTO_INCREMENT,
    nome_nivel_acesso VARCHAR(45),
    CONSTRAINT nivel_ck_nome CHECK (nome_nivel_acesso IN ('ADMINISTRADOR', 'GESTOR', 'FUNCIONÁRIO'))
);

CREATE TABLE usuario (
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome_user VARCHAR(45),
    email_user VARCHAR(45),
    senha_user VARCHAR(20),
    fk_empresa INT,
    fk_nivel_acesso INT,
    CONSTRAINT usuario_fk_empresa FOREIGN KEY (fk_empresa) REFERENCES empresa (id_empresa),
    CONSTRAINT usuario_fk_nivel_acesso FOREIGN KEY (fk_nivel_acesso) REFERENCES nivel_acesso (id_nivel_acesso)
);

CREATE TABLE permissao (
	id_permissao INT PRIMARY KEY AUTO_INCREMENT,
    nome_permissao VARCHAR(45),
    descricao_permissao VARCHAR(150)
);

CREATE TABLE permissoes_compartilhadas (
	id_permissoes_compartilhadas INT PRIMARY KEY AUTO_INCREMENT,
    fk_nivel_acesso INT,
    fk_permissao INT,
    CONSTRAINT permissoes_fk_nivel_acesso FOREIGN KEY (fk_nivel_acesso) REFERENCES nivel_acesso (id_nivel_acesso),
    CONSTRAINT permissoes_fk_permissao FOREIGN KEY (fk_permissao) REFERENCES permissao (id_permissao)
);

INSERT INTO endereco (numero_endereco, cidade, estado, logradouro) VALUES
('100', 'São Paulo', 'SP', 'Av. Paulista'),
('2500', 'Campinas', 'SP', 'Rod. Anhanguera'),
('45', 'Santos', 'SP', 'Av. Portuária');

INSERT INTO empresa (razao_social, cnpj, dt_registro, horario_inicio_expediente, horario_final_expediente, fk_endereco) VALUES
('Logística Brasil LTDA', '12345678000199', '2024-01-10', '05:00:00', '23:00:00', 1),
('TransPorto SA', '98765432000188', '2023-08-20', '08:00:00', '22:00:00', 2),
('Dock Solutions', '45678912000155', '2025-02-15', '06:00:00', '22:30:00', 3);

INSERT INTO doca (numero_doca, status_doca, fk_empresa) VALUES
('D01', 'ATIVO', 1),
('D02', 'ATIVO', 1),
('A01', 'ATIVO', 2),
('B15', 'ATIVO', 3);

INSERT INTO sensor (fk_doca) VALUES
(1),
(2),
(3),
(4);

INSERT INTO historico_sensor (dt_registro, status_sensor, fk_sensor) VALUES
('2026-03-25 10:00:00', 1, 1),
('2026-03-25 14:00:00', 0, 1),
('2026-03-26 06:00:00', 1, 2),
('2026-03-26 14:35:00', 0, 2),
('2026-03-26 17:00:00', 1, 3),
('2026-03-26 20:00:00', 0, 3);

INSERT INTO nivel_acesso (nome_nivel_acesso) VALUES
('ADMINISTRADOR'),
('FUNCIONÁRIO'),
('GESTOR');

INSERT INTO permissao (nome_permissao, descricao_permissao) VALUES
('CRIAR_DOCA', 'Permite cadastrar novas docas'),
('EDITAR_DOCA', 'Permite editar docas'),
('VISUALIZAR_DOCA', 'Permite visualizar docas'),
('GERENCIAR_USUARIOS', 'Permite gerenciar usuários');

INSERT INTO usuario (nome_user, email_user, senha_user, fk_empresa, fk_nivel_acesso) VALUES
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


-- Seleciona o usuário, o nivel de acesso e as permissões cadastradas para ele
SELECT
u.nome_user AS 'Usuário',
na.nome_nivel_acesso AS 'Nivel de Acesso',
p.nome_permissao AS 'Permissão'
FROM usuario u

JOIN nivel_acesso na
ON u.fk_nivel_acesso = na.id_nivel_acesso
    
JOIN permissoes_compartilhadas pc
ON pc.fk_nivel_acesso = na.id_nivel_acesso
    
JOIN permissao p
ON p.id_permissao = pc.fk_permissao
    
ORDER BY na.nome_nivel_acesso;




-- Exibição de uma ocorrência da doca, mostrando a data de entrada, saida e o tempo de permanencia do caminhão
SELECT
e.razao_social AS 'Nome da Empresa',
d.numero_doca AS 'Número da Doca',
d.status_doca AS 'Status da Doca',
s.modelo_sensor AS 'Modelo do Sensor',
hs_entrada.dt_registro AS 'Data de Entrada',
hs_saida.dt_registro AS 'Data da Saída',
CONCAT(TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, hs_saida.dt_registro), ' horas') AS 'Tempo de Permanência',

CASE
WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, hs_saida.dt_registro) > 5
	THEN 'Em Atraso'
    
WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, hs_saida.dt_registro) >= 4
	THEN 'Quase fora do prazo'
    
ELSE 'No Prazo'
END AS 'Tipo de Ocorrência'

FROM empresa e

JOIN doca d
ON e.id_empresa = d.fk_empresa

JOIN sensor s
ON d.id_doca = s.fk_doca

JOIN historico_sensor hs_entrada
ON hs_entrada.fk_sensor = s.id_sensor
AND hs_entrada.status_sensor = 1

JOIN historico_sensor hs_saida
ON hs_saida.fk_sensor = s.id_sensor
AND hs_saida.status_sensor = 0
AND hs_saida.dt_registro > hs_entrada.dt_registro
    
ORDER BY e.razao_social;