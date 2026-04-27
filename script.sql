CREATE DATABASE pilates;
USE pilates;

CREATE TABLE usuario(
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome_usuario VARCHAR(45),
    dt_nasc_usuario DATE,
    email_usuario VARCHAR(45),
    senha_usuario VARCHAR(45)
);

CREATE TABLE preferencia_usuario(
	id_preferencia INT PRIMARY KEY AUTO_INCREMENT,
    genero_musical VARCHAR(45),
    objetivo_pilates VARCHAR(45),
    fk_usuario INT,
    CONSTRAINT preferencia_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE treino(
	id_treino INT PRIMARY KEY AUTO_INCREMENT,
    tempo_treino DATE,
    fk_usuario INT,
    CONSTRAINT treino_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE resultado_quiz(
	id_quiz INT PRIMARY KEY AUTO_INCREMENT,
    pontuacao_quiz TINYINT,
    data_quiz DATE,
    fk_usuario INT,
    CONSTRAINT quiz_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario)
);



