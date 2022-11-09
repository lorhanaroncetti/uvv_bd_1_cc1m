create user lorhana with createdb
createrole inherit replication bypassrls encrypted
password '202204201';

create database uvv
owner = lorhana
template = template0 
encoding = 'UTF8';
lc_collate = 'pt_BR.UTF-8' 
lc_ctype = 'pt_BR.UTF-8';

CREATE SCHEMA hr;
ALTER SCHEMA hr OWNER TO lorhana;

SET SEARCH_PATH TO hr, "$user", public;
select current_schema();



CREATE TABLE hr.Cargos (
                id_cargo VARCHAR(10) NOT NULL,
                nome_cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2) NOT NULL,
                salario_maximo NUMERIC(8,2) NOT NULL,
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo)
);


CREATE UNIQUE INDEX cargos_idx
 ON hr.Cargos
 ( nome_cargo );

CREATE TABLE hr.Regioes (
                id_regiao INTEGER NOT NULL,
                nome_regiao VARCHAR(25) NOT NULL,
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao)
);


CREATE TABLE hr.Paises (
                id_pais_char CHAR(2) NOT NULL,
                id_regiao INTEGER,
                nome_pais VARCHAR(50) NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais_char)
);


CREATE TABLE hr.Localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50) NOT NULL,
                cep VARCHAR(8) NOT NULL,
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais_char CHAR(2) NOT NULL,
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao)
);


CREATE TABLE hr.Departamentos (
                id_departamento INTEGER NOT NULL,
                id_localizacao INTEGER NOT NULL,
                nome_depart VARCHAR(50) NOT NULL,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento)
);


CREATE UNIQUE INDEX departamentos_idx
 ON hr.Departamentos
 ( nome_depart );

CREATE TABLE hr.Empregados (
                id_empregado INTEGER NOT NULL,
                id_supervisor INTEGER NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2),
                id_departamento INTEGER NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado, id_supervisor)
);


CREATE UNIQUE INDEX empregados_idx
 ON hr.Empregados
 ( email );

CREATE TABLE hr.Supervisao (
                id_supervisor INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                CONSTRAINT supervisao_pk PRIMARY KEY (id_supervisor, id_gerente)
);


CREATE TABLE hr.HIstorico_Cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (id_empregado, data_inicial)
);

ALTER TABLE hr.HIstorico_Cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.Regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais_char)
REFERENCES hr.Paises (id_pais_char)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.Localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.HIstorico_Cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Supervisao ADD CONSTRAINT departamentos_supervisao_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.HIstorico_Cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.Empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.Empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Supervisao ADD CONSTRAINT empregados_supervisao_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.Empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

