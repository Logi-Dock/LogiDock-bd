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
    CONSTRAINT nivel_ck_nome CHECK (nome_nivel_acesso IN ('ADMINISTRADOR', 'GESTOR', 'FUNCIONÁRIO', 'TÉCNICO'))
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
('Dock Solutions', '45678912000155', '2025-02-15', '06:00:00', '22:30:00', 3),
('Suporte LogiDock', '45678912000888', null, null, null, null);

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
('2026-03-25 14:30:00', 1, 1),
('2026-03-25 16:30:00', 0, 1),
('2026-03-25 16:35:00', 1, 1),
('2026-03-25 22:30:00', 0, 1),
('2026-03-26 06:00:00', 1, 2),
('2026-03-26 14:35:00', 0, 2),
('2026-03-25 15:00:00', 1, 2),
('2026-03-25 20:30:00', 0, 2),
('2026-03-26 17:00:00', 1, 3),
('2026-03-26 20:00:00', 0, 3),
('2026-03-25 20:20:00', 1, 3),
('2026-03-25 23:59:00', 0, 3);

INSERT INTO nivel_acesso (nome_nivel_acesso) VALUES
('ADMINISTRADOR'),
('FUNCIONÁRIO'),
('GESTOR'),
('TÉCNICO');

INSERT INTO permissao (nome_permissao, descricao_permissao) VALUES
('CRIAR_DOCA', 'Permite cadastrar novas docas'),
('EDITAR_DOCA', 'Permite editar docas'),
('VISUALIZAR_DOCA', 'Permite visualizar docas'),
('GERENCIAR_USUARIOS', 'Permite gerenciar usuários'),
('UTILIZAR IA', 'ACESSO A INTELIGÊNCIA ARTIFICIAL');

INSERT INTO usuario (nome_user, email_user, senha_user, fk_empresa, fk_nivel_acesso) VALUES
('Carlos Silva', 'carlos@logbrasil.com', '123456', 1, 1),
('Ana Souza', 'ana@logbrasil.com', '123456', 1, 2),
('Marcos Lima', 'marcos@transporto.com', '123456', 2, 3),
('Fernanda Costa', 'fernanda@docksolutions.com', '123456', 3, 3),
('Suporte N3', 'suporte@logidock.com', '123456', 4, 4);

INSERT INTO permissoes_compartilhadas (fk_nivel_acesso, fk_permissao) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 3),
(3, 1),
(3, 2),
(3, 3),
(4, 5);


-- Select do LOGIN 

SELECT u.id_usuario, u.nome_user, u.email_user, e.razao_social, n.nome_nivel_acesso FROM usuario u
JOIN empresa e ON e.id_empresa = u.fk_empresa
JOIN nivel_acesso n ON n.id_nivel_acesso = u.fk_nivel_acesso;


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

select * from historico_sensor;

-- Exibição de uma ocorrência da doca, mostrando a data de entrada, saida e o tempo de permanencia do caminhão
CREATE OR REPLACE VIEW ocorrencias_docas AS SELECT
e.id_empresa AS 'ID da Empresa',
e.razao_social AS 'Nome da Empresa',
d.numero_doca AS 'Número da Doca',
d.status_doca AS 'Status da Doca',
s.modelo_sensor AS 'Modelo do Sensor',
hs_entrada.dt_registro AS 'Data de Entrada',
hs_saida.dt_registro AS 'Data da Saída',

CONCAT(
    TIMESTAMPDIFF(
        HOUR,
        hs_entrada.dt_registro,
        CASE WHEN hs_saida.dt_registro IS NULL THEN NOW() ELSE hs_saida.dt_registro END
    ),
    ' horas',
    
    CASE 
        WHEN (
            TIMESTAMPDIFF(
                MINUTE,
                hs_entrada.dt_registro,
                CASE WHEN hs_saida.dt_registro IS NULL THEN NOW() ELSE hs_saida.dt_registro END
            )
            -
            TIMESTAMPDIFF(
                HOUR,
                hs_entrada.dt_registro,
                CASE WHEN hs_saida.dt_registro IS NULL THEN NOW() ELSE hs_saida.dt_registro END
            ) * 60
        ) > 0
        THEN CONCAT(
            ' ',
            (
                TIMESTAMPDIFF(
                    MINUTE,
                    hs_entrada.dt_registro,
                    CASE WHEN hs_saida.dt_registro IS NULL THEN NOW() ELSE hs_saida.dt_registro END
                )
                -
                TIMESTAMPDIFF(
                    HOUR,
                    hs_entrada.dt_registro,
                    CASE WHEN hs_saida.dt_registro IS NULL THEN NOW() ELSE hs_saida.dt_registro END
                ) * 60
            ),
            ' minutos'
        )
        ELSE ''
    END
) AS 'Tempo de Permanência',
-- QUANDO AINDA TA NA DOCA
CASE
WHEN hs_saida.dt_registro IS NULL
    AND TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) > 5
    THEN 'Em Atraso (em andamento)'

WHEN hs_saida.dt_registro IS NULL
    AND TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) >= 4
    THEN 'Quase fora do prazo (em andamento)'

WHEN hs_saida.dt_registro IS NULL
    THEN 'No Prazo (em andamento)'

-- QUANDO JÁ SAIU
WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, hs_saida.dt_registro) > 5
    THEN 'Em Atraso'

WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, hs_saida.dt_registro) >= 4
    THEN 'Quase fora do prazo'

ELSE 'No Prazo'
END AS 'Tipo de Ocorrência'

FROM empresa e

JOIN doca d ON e.id_empresa = d.fk_empresa
JOIN sensor s ON d.id_doca = s.fk_doca

JOIN historico_sensor hs_entrada
  ON hs_entrada.fk_sensor = s.id_sensor
 AND hs_entrada.status_sensor = 1

LEFT JOIN historico_sensor hs_saida
  ON hs_saida.fk_sensor = s.id_sensor
 AND hs_saida.status_sensor = 0
 AND hs_saida.dt_registro = (
     SELECT MIN(h2.dt_registro)
     FROM historico_sensor h2
     WHERE h2.fk_sensor = s.id_sensor
       AND h2.status_sensor = 0
       AND h2.dt_registro > hs_entrada.dt_registro
 )

ORDER BY hs_entrada.dt_registro;

SELECT * FROM ocorrencias_docas;
SELECT * FROM ocorrencias_docas WHERE `Número da Doca` = 'D01';
SELECT * FROM ocorrencias_docas WHERE `Número da Doca` = 'D02';
SELECT * FROM ocorrencias_docas WHERE `Número da Doca` = 'A01';
SELECT * FROM ocorrencias_docas WHERE `ID da Empresa` = 1;
SELECT * FROM ocorrencias_docas WHERE DATE(`Data de Entrada`) = '2026-03-26';





-- ADIÇÕES POR PEDRO

-- kpiDocaMaisAtrasos
-- KPI 1: doca com mais atrasos
-- COUNT(*) pq cada linha já é 1 ocorrência
-- COLLATE pq garante comparação sem erro de maiúscula/minúscula no js
-- filtro de data pra limitar período
SELECT
`Número da Doca` as doca,
COUNT(*) AS qtd_atrasos
FROM ocorrencias_docas
WHERE `ID da Empresa` = 1
AND `Tipo de Ocorrência` COLLATE utf8mb4_0900_ai_ci LIKE 'Em Atraso'
AND `Data de Entrada` >= NOW() - INTERVAL 24 HOUR
GROUP BY `Número da Doca`
ORDER BY qtd_atrasos DESC
LIMIT 1;

-- kpiDocaMaiorAtraso
-- KPI 2: maior atraso individual
-- TIMESTAMPDIFF calcula duração entre entrada e saída
-- CASE pra quando não tiver saída ainda (usa NOW)
-- DATE_FORMAT só pra exibir no front
SELECT
`Número da Doca` AS doca,
DATE_FORMAT(`Data de Entrada`, '%d/%m') AS data,
DATE_FORMAT(`Data de Entrada`, '%H:%i') AS hora_inicio,

CASE
	WHEN `Data da Saída` IS NULL
	THEN 'Agora'
	ELSE DATE_FORMAT(`Data da Saída`, '%H:%i')
END AS hora_fim,

TIMESTAMPDIFF(MINUTE,  `Data de Entrada`,
CASE
	WHEN `Data da Saída` IS NULL
	THEN NOW()
	ELSE `Data da Saída`
END) AS minutos_atraso
FROM ocorrencias_docas

WHERE `ID da Empresa` = 1
AND `Tipo de Ocorrência` LIKE 'Em Atraso%'
AND `Data de Entrada` >= NOW() - INTERVAL 24 HOUR
ORDER BY minutos_atraso DESC
LIMIT 1;

-- kpiDocaMaiorTaxaDeAtrasos
-- KPI 3: taxa de atraso
-- COUNT(CASE) conta só atrasos
-- COUNT(*) total operações
-- percentual = atrasos / total
SELECT
`Número da Doca` AS doca,
COUNT(CASE
	WHEN `Tipo de Ocorrência` LIKE '%Atraso%'
	THEN 1
END) AS qtd_atrasos,
COUNT(*) AS qtd_operacoes,
ROUND(COUNT(CASE
		WHEN `Tipo de Ocorrência` LIKE '%Atraso%'
		THEN 1
	END
) * 100.0 / COUNT(*), 0) AS percentual

FROM ocorrencias_docas
WHERE `ID da Empresa` = 1
AND `Data de Entrada` >= NOW() - INTERVAL 3 MONTH

GROUP BY `Número da Doca`
HAVING qtd_atrasos > 0
ORDER BY percentual DESC, qtd_atrasos DESC
LIMIT 1;

-- kpiDocaMaiorTempoDeAtrasoAcumulado
-- KPI 4: maior tempo acumulado
-- SUM dos tempos de atraso por doca
-- TIMESTAMPDIFF soma duração de cada operação
-- CASE resolve operação ainda aberta
SELECT
`Número da Doca` AS doca,
SUM(TIMESTAMPDIFF(MINUTE,  `Data de Entrada`,
CASE
	WHEN `Data da Saída` IS NULL
	THEN NOW()
	ELSE `Data da Saída`
END)) AS minutos_atraso
FROM ocorrencias_docas

WHERE `ID da Empresa` = 1
AND `Tipo de Ocorrência` LIKE 'Em Atraso%'
AND `Data de Entrada` >= NOW() - INTERVAL 24 HOUR
GROUP BY doca
ORDER BY minutos_atraso
DESC LIMIT 1;

-- FIM ADIÇÕES POR PEDRO


-- SELECT para mostrar quando o caminhão entrou (Nicole)

SELECT 
e.razao_social AS Empresa,
d.numero_doca AS Doca,
s.modelo_sensor AS Sensor,
DATE_FORMAT(h.dt_registro, '%d/%m/%Y %H:%i:%s') AS Horario_Entrada
FROM historico_sensor h
JOIN sensor s ON h.fk_sensor = s.id_sensor
JOIN doca d ON s.fk_doca = d.id_doca
JOIN empresa e ON d.fk_empresa = e.id_empresa
WHERE h.status_sensor = 1
ORDER BY h.dt_registro DESC;


-- exibição de uma ocorrência da doca, com somente a data de entrada e tempo de permanência do caminhão 
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

select * from historico_sensor;

-- Exibição de uma ocorrência da doca, mostrando a data de entrada, saida e o tempo de permanencia do caminhão
CREATE OR REPLACE VIEW ocorrencias_docas AS 
SELECT
    e.id_empresa AS 'ID da Empresa',
    e.razao_social AS 'Nome da Empresa',
    d.numero_doca AS 'Número da Doca',
    d.status_doca AS 'Status da Doca',
    s.modelo_sensor AS 'Modelo do Sensor',
    hs_entrada.dt_registro AS 'Data de Entrada',
    
    -- Tempo de Permanência calculado sempre até o momento atual (NOW())
    CONCAT(
        TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()), ' horas',
        CASE 
            WHEN (TIMESTAMPDIFF(MINUTE, hs_entrada.dt_registro, NOW()) - (TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) * 60)) > 0
            THEN CONCAT(
                ' ',
                (TIMESTAMPDIFF(MINUTE, hs_entrada.dt_registro, NOW()) - (TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) * 60)),
                ' minutos'
            )
            ELSE ''
        END
    ) AS 'Tempo de Permanência',

    -- Tipo de Ocorrência baseado apenas no tempo decorrido desde a entrada
    CASE
        WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) > 5
            THEN 'Em Atraso (em andamento)'
            
        WHEN TIMESTAMPDIFF(HOUR, hs_entrada.dt_registro, NOW()) >= 4
            THEN 'Quase fora do prazo (em andamento)'
            
        ELSE 'No Prazo (em andamento)'
    END AS 'Tipo de Ocorrência'

FROM empresa e
JOIN doca d ON e.id_empresa = d.fk_empresa
JOIN sensor s ON d.id_doca = s.fk_doca
JOIN historico_sensor hs_entrada ON hs_entrada.fk_sensor = s.id_sensor AND hs_entrada.status_sensor = 1

ORDER BY hs_entrada.dt_registro;

-- Testes de selects para fazer na busca de usuários na página de cadastrar usuário
 SELECT nome_user, fk_nivel_acesso FROM usuario;

SELECT u.nome_user,n.nome_nivel_acesso  FROM usuario u JOIN nivel_acesso n ON n.id_nivel_acesso = u.fk_nivel_acesso WHERE fk_empresa = 3;

SELECT u.nome_user,n.nome_nivel_acesso, p.nome_permissao FROM usuario u 
	JOIN nivel_acesso n ON n.id_nivel_acesso = u.fk_nivel_acesso 
	JOIN permissoes_compartilhadas pc ON pc.fk_nivel_acesso = n.id_nivel_acesso
    JOIN permissao p ON pc.fk_permissao = p.id_permissao
    WHERE fk_empresa = 3
    GROUP BY u.nome_user;
    
    SELECT DISTINCT
    u.nome_user,
    n.nome_nivel_acesso, 
    p.nome_permissao 
FROM usuario u   
JOIN nivel_acesso n ON n.id_nivel_acesso = u.fk_nivel_acesso   
JOIN permissoes_compartilhadas pc ON pc.fk_nivel_acesso = n.id_nivel_acesso     
JOIN permissao p ON pc.fk_permissao = p.id_permissao     
WHERE u.fk_empresa = 3   
LIMIT 0, 500;



-- select da página de cadastrar usuário para fazer a busca
SELECT 
    u.nome_user,
    n.nome_nivel_acesso, 
    GROUP_CONCAT(p.nome_permissao) AS permissoes
FROM usuario u   
JOIN nivel_acesso n ON n.id_nivel_acesso = u.fk_nivel_acesso   
JOIN permissoes_compartilhadas pc ON pc.fk_nivel_acesso = n.id_nivel_acesso     
JOIN permissao p ON pc.fk_permissao = p.id_permissao     
WHERE u.fk_empresa = 3   
GROUP BY 
    u.nome_user, 
    n.nome_nivel_acesso;
    
    -- FIM ADIÇÕES NICOLE!
    
    