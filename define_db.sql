CREATE TABLE turno (
	id SERIAL PRIMARY KEY,
	horario VARCHAR(10) UNIQUE NOT NULL --integral/noturno
);
CREATE TABLE cursos (
	id VARCHAR(10) PRIMARY KEY,
	nome VARCHAR(20),
	turno_id INT REFERENCES turno(id)
);
CREATE TABLE comodos (
	id SERIAL PRIMARY KEY,
	comodo VARCHAR(20)

);
CREATE TABLE areas_administrativas (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) UNIQUE NOT NULL,
	descrição TEXT
);
CREATE TABLE usuarios (
	id SERIAL PRIMARY KEY,
	email VARCHAR(255) UNIQUE NOT NULL,
	apelido VARCHAR(20),
	ano_ingresso INT, --na república
	curso_id VARCHAR(10) REFERENCES cursos(id),
	comodo_id INT REFERENCES comodos(id),
	senha_salted_hashed VARCHAR(255),
);
CREATE TABLE usuario_areas ( --tabela associativa n:n
    usuario_id INT NOT NULL,
    area_adm_id INT NOT NULL,
    PRIMARY KEY (usuario_id, area_adm_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (area_adm_id) REFERENCES areas_administrativas(id) ON DELETE CASCADE
);
CREATE TABLE venda_salgado (
	id SERIAL PRIMARY KEY,
	data DATE UNIQUE NOT NULL,
	valor_gasto NUMERIC(10,2) DEFAULT 0,
	valor_recebido NUMERIC(10,2) DEFAULT 0,
	observacao TEXT,
	venda_ocorreu BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE vendedores_salgado (
	venda_salgado_id INT NOT NULL,
    usuario_id INT NOT NULL,
    PRIMARY KEY (venda_salgado_id, usuario_id),
    FOREIGN KEY (venda_salgado_id) REFERENCES venda_salgado(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);
CREATE TABLE produtos (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(20),
	custo_unitario NUMERIC(10,2) NOT NULL,
	valor_venda NUMERIC(10,2) NOT NULL,
	descricao TEXT
);

CREATE TABLE venda_produtos (
	data_inicio DATE NOT NULL,
	id_produto INT NOT NULL,
	nome_produto VARCHAR (20) NOT NULL,
	PRIMARY KEY (data_inicio, nome_produto),
	FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

