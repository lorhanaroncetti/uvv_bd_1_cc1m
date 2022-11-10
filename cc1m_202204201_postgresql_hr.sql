create user lorhana with createdb
createrole inherit replication bypassrls encrypted
password '202204201';

create database uvv
owner = lorhana
template = template0 
encoding = 'UTF8'
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
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo));

alter table hr.Cargos 
                 add constraint salario_minimo_check 
    			 check (salario_minimo >= 1212), 
    			 add constraint salario_minimo_maximo_check 
    			 check (salario_maximo > salario_minimo);


CREATE UNIQUE INDEX cargos_idx
 ON hr.Cargos( nome_cargo );
 
 

CREATE TABLE hr.Regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(50),
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao));


CREATE UNIQUE INDEX regi_es_idx
 ON hr.Regioes( nome );

CREATE TABLE hr.Paises (
                id_pais CHAR(2) NOT NULL,
                nome_pais VARCHAR(50),
                id_regiao INTEGER NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais));


CREATE UNIQUE INDEX pa_ses_idx
 ON hr.Paises( nome_pais );

CREATE TABLE hr.Localizaes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                cep VARCHAR(8) NOT NULL,
                uf VARCHAR(25),
                id_pais CHAR(2),
                CONSTRAINT localizaes_pk PRIMARY KEY (id_localizacao));


CREATE TABLE hr.Departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento));


CREATE UNIQUE INDEX departamentos_idx
 ON hr.Departamentos( nome );

CREATE TABLE hr.Empregados (
                id_empregados INTEGER NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2) NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                id_supervisor INTEGER NOT NULL,
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregados));

alter table hr.Empregados add constraint empregados_cargos_fk
                 foreign key (id_cargo)
                 references cargos(id_cargo),
                 add constraint empregados_departamentos_fk 
                 foreign key (id_departamento) 
                 references departamentos(id_departamento),
                 add constraint salario_check 
        		     check (salario >= 1212),
        		     add constraint comissao_check 
    			       check (comissao between 0 and 30);


CREATE UNIQUE INDEX empregados_idx
 ON hr.Empregados( email );

CREATE TABLE hr.Supervisao (
                id_departamento INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                CONSTRAINT supervisao_pk PRIMARY KEY (id_departamento, id_empregados));


CREATE TABLE hr.Historico_Cargos (
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_empregados INTEGER NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (data_inicial));

alter table hr.Historico_Cargos 
             add constraint data_inicial_final_check 
				     check (data_inicial < data_final);
             
     
-- Criação dos comentários da tabela hr.Cargos:

comment on table hr.Cargos is 'Tabela cargos, que armazena os dados dos cargos, inclusive a faixa salarial de cada um.';

comment on column hr.Cargos.id_cargo is 'Se refere ao código identificador atribuído a um cargo. Funciona como chave primária da tabela cargos.';

comment on column hr.Cargos.nome_cargo is 'Se refere ao nome atribuído a um cargo. Funciona como índice único.';

comment on column hr.Cargos.salario_minimo is 'Se refere ao menor salário admitido para um cargo, em reais (sem R$). Deve ser maior ou igual a 1.212 e menor que o valor da coluna salario_maximo.';

comment on column hr.Cargos.salario_maximo is 'Se refere ao maior salário admitido para um cargo, em reais (sem R$). Deve ser maior que o valor da coluna salario_minimo.';



-- Criação dos comentários da tabela hr.Departamentos:

comment on table hr.Departamentos is 'Tabela departamentos, que armazena os dados  dos  departamentos da empresa.';

comment on column hr.Departamentos.id_departamento is  'Se refere ao código identificador atribuído a um departamento. Funciona como chave primária da tabela departamentos.';

comment on column hr.Departamentos.nome is 'Se refere ao nome atribuído a um departamento. Funciona como índice único.';

comment on column hr.Departamentos.id_localizacao is 'Se refere ao código identificador da localização a qual o departamento pertence. Funciona como chave estrangeira para a tabela localizações.';



-- Criação dos comentários da tabela hr.Empregados:

comment on table hr.Empregados is 'Tabela empregados, que armazena os dados dos empregados da empresa.';

comment on column hr.Empregados.id_empregados is 'Se refere ao código identificador atribuído a um empregado. Funciona como chave primária da tabela empregados.';

comment on column hr.Empregados.nome_empregado is 'Se refere ao nome completo do empregado.';

comment on column hr.Empregados.email is 'Se refere a parte inicial do email do empregado (antes do @). Funciona como índice único.';

comment on column hr.empregados.telefone is 'Se refere ao telefone do empregado. Deve ser inserido o código do país e do estado (sem espaço e sem caracteres especiais).';

comment on column hr.Empregados.data_contratacao is 'Se refere a data em que o cargo atual foi atribuído ao empregado';

comment on column hr.Empregados.id_cargo is 'Se refere ao código identificador atribuído ao cargo atual do empregado. Funciona como chave estrangeira para a tabela cargos.';

comment on column hr.Empregados.salario is 'Se refere ao salário atual do empregado, em reais (sem R$). Deve ser maior ou igual a 1.212.';

comment on column hr.Empregados.comissao is 'Se refere a porcentagem de comissão atribuída ao empregado. Sendo que, apenas funcionários do departamento de vendas são elegíveis para comissões. Não pode ser maior que 30. Não pode ser negativa.';

comment on column hr.Empregados.id_departamento is 'Se refere ao código identificador atribuído ao departamento que o empregado pertence.  Funciona como chave estrangeira para a tabela departamentos.';

comment on column hr.Empregados.id_supervisor is 'Se refere ao empregado que atua como supervisor direto do empregado em questão. Funciona como chave estrangeira para a própria tabela empregados autorelacionamento.';



-- Criação dos comentários da tabela hr.Supervisao:

comment on table hr.Supervisao is 'Tabela supervisao, que armazena as informações referentes a qual empregado gerencia qual departamento.'; 

comment on column hr.Supervisao.id_departamento is 'Se refere ao código identificador atribuído ao departamento que o empregado trabalha como gerente. Junto com a coluna id_gerente, funciona como chave primária composta da tabela trabalha_em. Também funciona como chave  estrangeira para a tabela departamentos.';

comment on column hr.Supervisao.id_gerente is 'Se refere ao código identificador atribuído a um empregado que gerencia um departamento. Junto com a coluna id_departamento funciona como chave primária composta da tabela trabalha_em. Também funciona como chave estrangeira para a tabela empregados.';



-- Criação dos comentário da tabela hr.Historico_Cargos

comment on table hr.Historico_Cargos is 'Tabela histórico_cargos, que armazena o histórico de cargos de um empregado. Uma linha nova deve ser inserida para cada alteração feita no cadastro de um empregado, como por exemplo uma transferência de departamento ou de cargo.';

comment on column hr.Historico_Cargos.data_inicial is 'Se refere ao código identificador atribuído a umm histórico. Funciona como chave primária da tabela historico_cargos.';

comment on column hr.Historico_Cargos.id_empregados is 'Se refere ao código identificador atribuído a um empregado.  Funciona como chave estrangeira para a tabela empregados.';

comment on column hr.Historico_Cargos.data_inicial is 'Se refere a data em que o cargo foi atribuído ao empregado. Deve ser menor do que a data_final.';

comment on column hr.Historico_Cargos.data_final is 'Se refere ao último dia em que o empregado exerceu o cargo. Deve ser maior que a data_inicial.';

comment on column hr.Historico_Cargos.id_cargo  is 'Se refere ao código identificador atribuído ao cargo do empregado. Funciona como chave estrangeira para a tabela cargos.';

comment on column hr.Historico_Cargos.id_departamento is 'Se refere ao código identificador atribuído ao departamento ao qual o empregado pertence. Funciona como chave estrangeira para a tabela departamentos.';



-- Criação dos comentários da tabela hr.Localizaes

comment on table hr.Localizaes is 'Tabela localizações, que armazena os endereços dos escritórios e facilidades da empresa.';

comment on column hr.Localizaes.id_localizacao is 'Se refere ao código identificador atribuído a uma localização onde está localizado um escritório ou facilidade da empresa. Funciona como chave primária da tabela localizações.';

comment on column hr.Localizaes.endereco is 'Se refere ao endereço, constituído de número e logradouro, de um escritório ou facilidade da empresa.';

comment on column hr.Localizaes.cep is 'Se refere ao CEP da localização de um escritório ou facilidade da empresa, coloquei como not null para facilitar a localização do endereço.';

comment on column hr.Localizaes.cidade is 'Se refere a cidade onde está localizado de um escritório ou facilidade da empresa.';

comment on column hr.Localizaes.uf is 'Se refere ao estado (por extenso) onde está localizado o escritório ou facilidade da empresa.';

comment on column hr.Localizaes.id_pais is 'Se refere ao código identificador atribuído a um país onde está localizado um escritório ou facilidade da empresa. Funciona como chave estrangeira para a tabela países.';




-- Criação dos comentários da tabela hr.Paises

comment on table hr.Paises is 'Tabela países, que armazena os países nos quais existem escritórios e facilidades da empresa.';

comment on column hr.Paises.id_pais is 'Se refere ao código identificador atribuído a um país onde está localizado um escritório ou facilidade da empresa. Funciona como chave primária da tabela países.';

comment on column hr.Paises.nome_pais is 'Se refere ao nome do país onde está localizado um escritório ou facilidade da empresa. Funciona como índice único.';

comment on column hr.Paises.id_regiao is 'Se refere ao código identificador atribuído a uma região a qual o país onde está localizado um escritório ou facilidade da empresa pertence. Funciona como chave estrangeira para a tabela regiões.';



-- Criação dos comentários da tabela hr.Regioes

comment on table hr.Regioes is 'Tabela regiões, que armazena as regiões em que estão presentes os países nos quais.';

comment on column hr.Regioes.id_regiao is 'Se refere ao código identificador atribuído a uma região a qual o país onde está localizado um escritório ou facilidade da empresa pertence. Funciona como chave primária da tabela regiões.';

comment on column hr.Regioes.nome is 'Se refere ao nome de uma região a qual o país onde está localizado um escritório ou facilidade da empresa pertence. Funciona como chave primária da tabela regiões. Funciona como índice único.';



ALTER TABLE hr.Empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Historico_Cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Paises ADD CONSTRAINT regi_es_pa_ses_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.Regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Localizaes ADD CONSTRAINT pa_ses_localiza__es_fk
FOREIGN KEY (id_pais)
REFERENCES hr.Paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Departamentos ADD CONSTRAINT localiza__es_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.Localizaes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Historico_Cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Supervisao ADD CONSTRAINT departamentos_supervisao_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Historico_Cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregados)
REFERENCES hr.Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Supervisao ADD CONSTRAINT empregados_supervisao_fk
FOREIGN KEY (id_empregados)
REFERENCES hr.Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.Empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
