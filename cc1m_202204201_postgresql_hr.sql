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
COMMENT ON TABLE hr.Cargos IS 'a tabela cargos armazena informações dos cargos, como faixa salarial mínimo e máximo.';
COMMENT ON COLUMN hr.Cargos.id_cargo IS 'é a chave primária desta tabela.';
COMMENT ON COLUMN hr.Cargos.nome_cargo IS 'nome do cargo.';
COMMENT ON COLUMN hr.Cargos.salario_minimo IS 'o menor salário admitido para o cargo, ele não pode ser nulo.';
COMMENT ON COLUMN hr.Cargos.salario_maximo IS 'o maior salário admitido para um cargo, ele não pode ser nulo.';


CREATE UNIQUE INDEX cargos_idx
 ON hr.Cargos
 ( nome_cargo );
 
 ---
 
CREATE TABLE hr.Regioes (
                id_regiao INTEGER NOT NULL,
                nome_regiao VARCHAR(25) NOT NULL,
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.Regioes IS 'a tabela regiões contém os id's e nomes das regiões.';
COMMENT ON COLUMN hr.Regioes.id_regiao IS 'é a chave primária desta tabela.';
COMMENT ON COLUMN hr.Regioes.nome_regiao IS 'nomes da região.';

---

CREATE TABLE hr.Paises (
                id_pais_char CHAR(2) NOT NULL,
                id_regiao INTEGER,
                nome_pais VARCHAR(50) NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais_char)
);
COMMENT ON TABLE hr.Paises IS 'a tabela países contém informaçõs dos países inseridos nela.';
COMMENT ON COLUMN hr.Paises.id_pais IS 'é a chave primária desta tabela.';
COMMENT ON COLUMN hr.Paises.nome_pais IS 'é o nome do país.';
COMMENT ON COLUMN hr.Paises.id_regiao IS 'é a chave primária da tabela regiões. ela apareceu aqui por conta do relacionamento entre as tabelas hr.Paises-hr.Regioes';

---

CREATE TABLE hr.Localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50) NOT NULL,
                cep VARCHAR(8) NOT NULL,
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais_char CHAR(2) NOT NULL,
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.Localizacoes IS 'a tabela localizaçõs contém informações de diversos escritórios de empresas.';
COMMENT ON COLUMN hr.Localizacoes.id_localizacao IS 'é a chave primária desta tabela.';
COMMENT ON COLUMN hr.Localizacoes.endereco IS 'contem o endereço da empresa.';
COMMENT ON COLUMN hr.Localizacoes.cep IS 'coloquei como não nulo por conta de ser obrigatório ao menos o cep, já que através dele consigo as outras informações de cidade, endereço, etc..';
COMMENT ON COLUMN hr.Localizacoes.cidade IS 'cidade onde se encontra a empresa.';
COMMENT ON COLUMN hr.Localizacoes.uf IS 'estado em que se encontra a empresa';
COMMENT ON COLUMN hr.Localizacoes.id_pais IS 'é a chave primária da tabela países. ela apareceu aqui por conta do relacionamento hr.Localizacoes-hr.Paises';

---

CREATE TABLE hr.Departamentos (
                id_departamento INTEGER NOT NULL,
                id_localizacao INTEGER NOT NULL,
                nome_depart VARCHAR(50) NOT NULL,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.Departamentos IS 'é a tabela com as informações sobre os departamentos da empresa.';
COMMENT ON COLUMN hr.Departamentos.id_departamento IS 'é a chave primária desta tabela.';
COMMENT ON COLUMN hr.Departamentos.nome_depart IS 'é o nome do departamento da tabela.';
COMMENT ON COLUMN hr.Departamentos.id_localizacao IS 'não pode ser nula.';

CREATE UNIQUE INDEX departamentos_idx
 ON hr.Departamentos
 ( nome_depart );
 
 ---

CREATE TABLE hr.Empregados (
                id_empregado INTEGER NOT NULL,
                id_supervisor INTEGER NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2), NOT NULL,
                id_departamento INTEGER NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado, id_supervisor)
);
COMMENT ON TABLE hr.Empregados IS 'Tabela que contém as informações dos empregados.';
COMMENT ON COLUMN hr.Empregados.id_empregado IS 'chave primária da tabela.';
COMMENT ON COLUMN hr.Empregados.nome IS 'nome completo do empregado.';
COMMENT ON COLUMN hr.Empregados.email IS 'email do empregado, é uma AK';
COMMENT ON COLUMN hr.Empregados.telefone IS 'telefone do empregado';
COMMENT ON COLUMN hr.Empregados.data_contratacao IS 'data em que o empregado iniciou no cargo atual.';
COMMENT ON COLUMN hr.Empregados.id_cargo IS 'FK da tabela.';
COMMENT ON COLUMN hr.Empregados.salario IS 'calário mensal atual do empregado.';
COMMENT ON COLUMN hr.Empregados.comissao IS 'corresponde à comissao do empregado.';
COMMENT ON COLUMN hr.Empregados.id_departamento IS 'chave primária da tabela.';
COMMENT ON COLUMN hr.Empregados.id_supervisor IS 'chave primária da tabela.';


CREATE UNIQUE INDEX empregados_idx
 ON hr.Empregados
 ( email );

---

CREATE TABLE hr.Supervisao (
                id_supervisor INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                CONSTRAINT supervisao_pk PRIMARY KEY (id_supervisor, id_gerente)
);
COMMENT ON TABLE hr.Supervisao IS 'Tabela que contém as informações dos supervisores.';
COMMENT ON COLUMN hr.Supervisao.id_supervisor IS 'chave primária da tabela.';
COMMENT ON COLUMN hr.Supervisao.id_gerente IS 'chave primária da tabela.';

---

CREATE TABLE hr.HIstorico_Cargos (
                id_empregado INTEGER NOT NULL,
                data_inicial DATE NOT NULL,
                data_final DATE,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (id_empregado, data_inicial)
);
COMMENT ON TABLE hr.HIstorico_Cargos IS 'tabela que armazena o histórico de cargos de um empregado. Se um empregado mudar de departamento dentro de um cargo ou mudar de cargo dentro de um
departamento, novas linhas devem ser inseridas nesta tabela com a informação do empregado.';
COMMENT ON COLUMN hr.HIstorico_Cargos.data_inicial IS 'deve ser menor do que a data_final.';
COMMENT ON COLUMN hr.HIstorico_Cargos.id_empregado IS 'chave primária da tabela.';
COMMENT ON COLUMN hr.HIstorico_Cargos.data_final IS 'data em que o empregado muda de cargo.';
COMMENT ON COLUMN hr.HIstorico_Cargos.id_cargo IS 'FK da tabela.';
COMMENT ON COLUMN hr.HIstorico_Cargos.id_departamento IS 'FK da tabela.';

---

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

