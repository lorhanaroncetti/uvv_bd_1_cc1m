
CREATE TABLE Cargos (
                id_cargo VARCHAR(10) NOT NULL,
                nome_cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2) NOT NULL,
                salario_maximo NUMERIC(8,2) NOT NULL,
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo)
);


CREATE TABLE Regioes (
                id_regiao INTEGER NOT NULL,
                nome_regiao VARCHAR(25),
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao)
);


CREATE UNIQUE INDEX regioes_idx
 ON Regioes
 ( nome_regiao );

CREATE TABLE Paises (
                id_pais CHAR(2) NOT NULL,
                nome_pais VARCHAR(50),
                id_regiao INTEGER NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais)
);


CREATE UNIQUE INDEX paises_idx
 ON Paises
 ( nome_pais );

CREATE TABLE Localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                cep VARCHAR(8) NOT NULL,
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao)
);


CREATE TABLE Departamentos (
                id_departamento INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                nome_departamento VARCHAR(50),
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento, id_gerente)
);


CREATE UNIQUE INDEX departamentos_idx
 ON Departamentos
 ( nome_departamento );

CREATE TABLE Empregados (
                id_departamento INTEGER NOT NULL,
                data_contratacao DATE NOT NULL,
                nome_empregado VARCHAR(100) NOT NULL,
                telefone VARCHAR(30) NOT NULL,
                email VARCHAR(35) NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2),
                id_supervisor INTEGER NOT NULL,
                id_departamento_1 INTEGER NOT NULL,
                CONSTRAINT empregados_pk PRIMARY KEY (id_departamento)
);


CREATE TABLE Gerentes (
                id_departamento INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                CONSTRAINT gerentes_pk PRIMARY KEY (id_departamento, id_gerente)
);


CREATE TABLE Historico_Cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                id_departamento INTEGER NOT NULL,
                data_final DATE,
                id_cargo VARCHAR(10) NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (id_empregado)
);


ALTER TABLE Empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Historico_Cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES Regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES Paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES Localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Regioes ADD CONSTRAINT localizacoes_regioes_fk
FOREIGN KEY (id_localizacao)
REFERENCES Localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Historico_Cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Gerentes ADD CONSTRAINT departamentos_gerentes_fk
FOREIGN KEY (id_departamento, id_gerente)
REFERENCES Departamentos (id_departamento, id_gerente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
Warning: Relationship has no columns to map:
*/
ALTER TABLE Historico_Cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY ()
REFERENCES Empregados ()
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Gerentes ADD CONSTRAINT empregados_gerentes_fk
FOREIGN KEY (id_departamento)
REFERENCES Empregados (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE Empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_departamento_1)
REFERENCES Empregados (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
