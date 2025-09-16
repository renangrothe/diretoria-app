CREATE TABLE turno (
	turno_id UUID PRIMARY_KEY,
	horario VARCHAR(10) UNIQUE NOT NULL --integral/noturno
);
CREATE TABLE cursos (
	curso_id VARCHAR(10) PRIMARY KEY,
	nome VARCHAR(20),
	turno_id UUID REFERENCES turno(turno_id)
);
CREATE TABLE quartos (
	quarto_id UUID PRIMARY_KEY,
	comodo VARCHAR(20)
);
CREATE TABLE areas_administrativas (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) UNIQUE NOT NULL,
	descrição TEXT
);
CREATE TABLE usuarios (
	email VARCHAR(255) PRIMARY KEY,
	apelido VARCHAR(20),
	ano_ingresso INT, --na república
	curso_id VARCHAR(10) REFERENCES cursos(curso_id),
	quarto_id UUID REFERENCES quartos(quarto_id),
	senha_salted_hashed VARCHAR(30),


);
CREATE TABLE usuario_areas ( --tabela associativa n:n
    usuario_id INT NOT NULL,
    area_adm_id INT NOT NULL,
    PRIMARY KEY (usuario_id, area_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES areas_administrativas(id) ON DELETE CASCADE
);
