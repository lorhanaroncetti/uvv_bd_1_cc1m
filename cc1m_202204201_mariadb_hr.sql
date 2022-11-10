-- Criando um usuário no MariaDB:

CREATE USER 'lorhana'@localhost identified by '202204201';

-- Criando um BD no MariaDB:

CREATE DATABASE uvv
                CHARACTER SET UTF8
                COLLATE UTF8_general_ci;
                
GRANT ALL ON uvv.* TO 'lorhana'@localhost;

USE uvv;



-- Criando as tabelas, colunas, index e comentários:

CREATE TABLE Cargos (
                id_cargo VARCHAR(10) NOT NULL,
                nome_cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2) NOT NULL,
                salario_maximo DECIMAL(8,2) NOT NULL,
                PRIMARY KEY (id_cargo));

CREATE UNIQUE INDEX cargos_idx
 ON Cargos( nome_cargo );

ALTER TABLE Cargos COMMENT 'Tabela cargos, que armazena os dados dos cargos, inclusive a faixa salarial de cada um.';

ALTER TABLE Cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Se refere ao código identificador atribuído a um cargo. Funciona como chave primária da tabela cargos.';

ALTER TABLE Cargos MODIFY COLUMN  nome_cargo VARCHAR(35) COMMENT 'Se refere ao nome atribuído a um cargo. Funciona como índice único.';

ALTER TABLE Cargos MODIFY COLUMN salario_minimo DECIMAL(8,2) COMMENT 'Se refere ao menor salário admitido para um cargo, em reais (sem R$). Deve ser maior ou igual a 1.212 e menor que o valor da coluna salario_maximo.';

ALTER TABLE Cargos MODIFY COLUMN salario_maximo DECIMAL(8,2) COMMENT 'Se refere ao maior salário admitido para um cargo, em reais (sem R$). Deve ser maior que o valor da coluna salario_minimo.';





CREATE TABLE Regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(50),
                PRIMARY KEY (id_regiao));


CREATE UNIQUE INDEX regiões_idx
 ON Regioes(nome);

ALTER TABLE Regioes COMMENT 'Tabela regiões, que armazena as informações das regiões. É uma tabela do tipo 1:N.';

ALTER TABLE Regioes MODIFY COLUMN id_regiao INTEGER COMMENT 'Se refere ao código identificador atribuído a uma região a qual o país onde está localizado um escritório ou facilidade da empresa pertence. Funciona como chave primária da tabela regiões.';

ALTER TABLE Regioes MODIFY COLUMN nome VARCHAR(50) COMMENT 'Se refere ao nome de uma região a qual o país onde está localizado um escritório ou facilidade da empresa pertence';





CREATE TABLE Paises (
                id_pais CHAR(2) NOT NULL,
                nome_pais VARCHAR(50),
                id_regiao INT NOT NULL,
                PRIMARY KEY (id_pais));

CREATE UNIQUE INDEX países_idx
 ON Paises( nome_pais );

ALTER TABLE Paises COMMENT 'Tabela que informa nome e código de países nos quais existem escritórios e também uma FK (id_pais).';

ALTER TABLE Paises MODIFY COLUMN id_pais CHAR(2) COMMENT 'Se refere ao código identificador atribuído a um país onde está localizado um escritório ou facilidade da empresa. Funciona como chave primária da tabela países.';

ALTER TABLE Paises MODIFY COLUMN nome_pais VARCHAR(50) COMMENT 'Se refere ao nome do país onde está localizado um escritório ou facilidade da empresa. Funciona como índice único';

ALTER TABLE Paises MODIFY COLUMN id_regiao INT COMMENT 'É uma chave estrangeira do tipo integer (numero não fracionário). Como toda FK, esta coluna não pode ser deixada com o valor nulo.';





CREATE TABLE Localizaes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                cep VARCHAR(8) NOT NULL,
                uf VARCHAR(25),
                id_pais CHAR(2),
                PRIMARY KEY (id_localizacao));
               
ALTER TABLE Localizaes COMMENT 'TTabela localizações, que armazena os endereços dos escritórios e facilidades da empresa.';

ALTER TABLE Localizaes MODIFY COLUMN id_localizacao INT COMMENT 'Se refere ao código identificador atribuído a uma localização; onde está localizado um escritório. Funciona como uma PK da tabela localizações.';

ALTER TABLE Localizaes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Se refere ao endereço, constituído de número e logradouro, de um escritório.';

ALTER TABLE Localizaes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'Se refere a cidade onde está localizado um escritório.';

ALTER TABLE Localizaes MODIFY COLUMN cep VARCHAR(8) COMMENT 'Se refere ao CEP da localização de um escritório ou facilidade da empresa, coloquei como not null para facilitar a localização do endereço.';

ALTER TABLE Localizaes MODIFY COLUMN uf VARCHAR(25) COMMENT 'Se refere ao estado (por extenso) onde está localizado o escritório.';

ALTER TABLE Localizaes MODIFY COLUMN id_pais CHAR(2) COMMENT 'Se refere ao código identificador atribuído a um país onde está localizado um escritório. Funciona como FK para a tabela países.';

               
               
                   
                                           
CREATE TABLE Departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50),
                id_localizacao INT NOT NULL,
                PRIMARY KEY (id_departamento));
                            
CREATE UNIQUE INDEX departamentos_idx
 ON Departamentos( nome );

ALTER TABLE Departamentos COMMENT 'Tabela departamentos, que armazena os dados  dos  departamentos da empresa.';

ALTER TABLE Departamentos MODIFY COLUMN id_departamento INT COMMENT 'Se refere ao código identificador atribuído a um departamento. Funciona como uma PK da tabela departamentos.';

ALTER TABLE Departamentos MODIFY COLUMN nome VARCHAR(50) COMMENT 'Se refere ao nome atribuído a um departamento. Funciona como índice único.';

ALTER TABLE Departamentos MODIFY COLUMN id_localizacao INT COMMENT 'Se refere ao código identificador da localização a qual o departamento pertence. Funciona como FK para a tabela localizações.';






CREATE TABLE Empregados (
                id_empregados INT NOT NULL,
                nome_empregado VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario DECIMAL(8,2) NOT NULL,
                comissao DECIMAL(4,2) NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT NOT NULL,
                id_supervisor INT NOT NULL,
                PRIMARY KEY (id_empregados));
               
ALTER TABLE Empregados add
                constraint salario_check 
        		check (salario >= 1212);
        	
ALTER TABLE Empregados add
				constraint comissao_check 
    			check (comissao between 0 and 30);

CREATE UNIQUE INDEX empregados_idx
 ON Empregados( email );

ALTER TABLE Empregados COMMENT 'Tabela empregados, que armazena os dados dos empregados da empresa';

ALTER TABLE Empregados MODIFY COLUMN id_empregados INT COMMENT 'Se refere ao código identificador atribuído a um empregado. Funciona como chave primária da tabela empregados.';

ALTER TABLE Empregados MODIFY COLUMN nome_empregado VARCHAR(75) COMMENT 'Se refere a nome completo do funcionário.';

ALTER TABLE Empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'Se refere a parte inicial do email do empregado.';

ALTER TABLE Empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'Se refere ao telefone do empregado. Deve ser inserido o código do país e do estado (sem espaço e sem caracteres especiais).';

ALTER TABLE Empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Se refere a data em que o cargo atual foi atribuído ao empregado';

ALTER TABLE Empregados MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Se refere ao código identificador atribuído ao cargo atual do empregado. Funciona como FK para a tabela cargos.';

ALTER TABLE Empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'Se refere ao salário atual do empregado, em reais (sem R$). Deve ser maior ou igual a 1.212.';

ALTER TABLE Empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'Se refere a porcentagem de comissão atribuída ao empregado. Sendo que, apenas funcionários do departamento de vendas são elegíveis para comissões. Não pode ser maior que 30. Não pode ser negativa.';

ALTER TABLE Empregados MODIFY COLUMN id_departamento INT COMMENT 'Se refere ao código identificador atribuído ao departamento que o empregado pertence.  Funciona como chave estrangeira para a tabela departamentos.';

ALTER TABLE Empregados MODIFY COLUMN id_supervisor INT COMMENT 'Se refere ao empregado que atua como supervisor direto do empregado em questão. Funciona como FK para a própria tabela empregados autorelacionamento.';





CREATE TABLE Supervisao (
                id_departamento INT NOT NULL,
                id_gerente INT NOT NULL,
                PRIMARY KEY (id_departamento, id_gerente));
               
ALTER TABLE Supervisao COMMENT 'Tabela supervisao, que armazena as informações referentes a qual empregado gerencia qual departamento. Possui PFK para a tabela funcionários.';

ALTER TABLE Supervisao MODIFY COLUMN id_departamento INT COMMENT 'Se refere ao código identificador atribuído ao departamento que o empregado trabalha como gerente. Junto com a coluna id_gerente, funciona como chave primária composta da tabela trabalha_em. Também funciona como chave  estrangeira para a tabela departamentos.';

ALTER TABLE Supervisao MODIFY COLUMN id_gerente INT COMMENT 'Se refere ao código identificador atribuído a um empregado que gerencia um departamento. A chave primária vai garantir que este valor não seja repetido ou confundido com a identificação de outro funcionário.';

               
               
               

CREATE TABLE Historico_Cargos (
                data_inicial DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_empregados INT NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (data_inicial));
               
ALTER TABLE Historico_Cargos add 
			constraint data_inicial_final_check 
			check (data_inicial < data_final);
				
ALTER TABLE Historico_Cargos COMMENT 'Tabela histórico_cargos, que armazena o histórico de cargos de um empregado. Uma linha nova deve ser inserida para cada alteração feita no cadastro de um empregado, como por exemplo uma transferência de departamento ou de cargo.';

ALTER TABLE Historico_Cargos MODIFY COLUMN data_inicial DATE COMMENT 'Se refere ao código identificador atribuído a um histórico. Funciona como chave primária da tabela historico_cargos. Deve ser menor que a data final';

ALTER TABLE Historico_Cargos MODIFY COLUMN data_final DATE COMMENT 'Se refere ao último dia em que o empregado exerceu o cargo. Deve ser maior que a data_inicial.';

ALTER TABLE Historico_Cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Se refere ao código identificador atribuído ao cargo do empregado. Funciona como chave estrangeira para a tabela cargos.';

ALTER TABLE Historico_Cargos MODIFY COLUMN id_empregados INT COMMENT 'Se refere ao código identificador atribuído a um empregado.  Funciona como chave estrangeira para a tabela empregados.';

ALTER TABLE Historico_Cargos MODIFY COLUMN id_departamento INT COMMENT 'Se refere ao código identificador atribuído ao departamento ao qual o empregado pertence. Funciona como chave estrangeira para a tabela departamentos.';
            
         
               
               
-- Criação das FK's das tabelas:
               
ALTER TABLE Empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Historico_Cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES Cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Paises ADD CONSTRAINT regiões_países_fk
FOREIGN KEY (id_regiao)
REFERENCES Regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Localizaes ADD CONSTRAINT países_localizações_fk
FOREIGN KEY (id_pais)
REFERENCES Paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Departamentos ADD CONSTRAINT localizações_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES Localizaes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Historico_Cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Supervisao ADD CONSTRAINT departamentos_supervisao_fk
FOREIGN KEY (id_departamento)
REFERENCES Departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Historico_Cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregados)
REFERENCES Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Supervisao ADD CONSTRAINT empregados_supervisao_fk
FOREIGN KEY (id_gerente)
REFERENCES Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES Empregados (id_empregados)
ON DELETE NO ACTION
ON UPDATE NO ACTION;





-- Inserção dos valores da tabela Regioes:

INSERT INTO Regioes (id_regiao, nome) VALUES (1, 'Europe');
INSERT INTO Regioes (id_regiao, nome) VALUES (2, 'Americas');
INSERT INTO Regioes (id_regiao, nome) VALUES (3, 'Asia');
INSERT INTO Regioes (id_regiao, nome) VALUES (4, 'Middle East and Africa');


-- Inserção dos valores da tabela Paises:

INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('AR', 'Argentina', '2');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('AU', 'Australia', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('BE', 'Belgium', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('BR', 'Brazil', '2');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('CA', 'Canada', '2');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('CH', 'Switzerland', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('CN', 'China', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('DE', 'Germany', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('DK', 'Denmark', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('EG', 'Egypt', '4');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('FR', 'France', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('IL', 'Israel', '4');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('IN', 'India', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('IT', 'Italy', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('JP', 'Japan', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('KW', 'Kuwait', '4');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('ML', 'Malaysia', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('MX', 'Mexico', '2');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('NG', 'Nigeria', '4');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('NL', 'Netherlands', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('SG', 'Singapore', '3');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('UK', 'United Kingdom', '1');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('US', 'United States of America', '2');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('ZM', 'Zambia', '4');
INSERT INTO Paises (id_pais, nome_pais, id_regiao) VALUES ('ZW', 'Zimbabwe', '4');
