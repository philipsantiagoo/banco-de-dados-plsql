-- =================================================================           
-- POVOAMENTO PARTE 2: ESTRUTURA TÉCNICA
-- Tabelas: 
-- =================================================================

--Funcionario_equipe--

--Max Verstappen

INSERT INTO Funcionario_equipe(credencial_FIA_pessoa, nome_equipe_contratante, licenca_staff, funcao_equipe, departamento)
VALUES('1000', 'Oracle Red Bull Racing', '1200-3000', 'Piloto', 'Equipe de Corrida');

--Lewis Hamilton

INSERT INTO Funcionario_equipe(credencial_FIA_pessoa, nome_equipe_contratante, licenca_staff, funcao_equipe, departamento)
VALUES('1001', 'Scuderia Ferrari', '1200-3001', 'Piloto', 'Equipe de Corrida');

--Charles Leclerc

INSERT INTO Funcionario_equipe(credencial_FIA_pessoa, nome_equipe_contratante, licenca_staff, funcao_equipe, departamento)
VALUES('1002', 'Scuderia Ferrari', '1200-3002', 'Piloto', 'Equipe de Corrida');

--Lando Norris

INSERT INTO Funcionario_equipe(credencial_FIA_pessoa, nome_equipe_contratante, licenca_staff, funcao_equipe, departamento)
VALUES('1003', 'McLaren Formula 1 Team', '1200-3002', 'Piloto', 'Equipe de Corrida');

--Chefe--

INSERT INTO Chefe(credencial_FIA_funcionario, nome_equipe_liderada, data_assuncao_equipe, cargo_chefe)
VALUES('1004', 'Scuderia Ferrari', TO_DATE('1992-03-22', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Chefe(credencial_FIA_funcionario, nome_equipe_liderada, data_assuncao_equipe, cargo_chefe)
VALUES('1005', 'McLaren Formula 1 Team', TO_DATE('2005-09-01', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Chefe(credencial_FIA_funcionario, nome_equipe_liderada, data_assuncao_equipe, cargo_chefe)
VALUES('1006', 'Oracle Red Bull Racing', TO_DATE('2023-06-13', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Chefe(credencial_FIA_funcionario, nome_equipe_liderada, data_assuncao_equipe, cargo_chefe)
VALUES('1007', 'Mercedes-AMG Petronas', TO_DATE('2011-02-24', 'YYYY-MM-DD'), 'Chefe');

--Engenheiro--

INSERT INTO Engenheiro(credencial_FIA_funcionario, especialidade)
VALUES('1008', 'Chassi');

INSERT INTO Engenheiro(credencial_FIA_funcionario, especialidade)
VALUES('1009', 'Motor');

INSERT INTO Engenheiro(credencial_FIA_funcionario, especialidade)
VALUES('1010', 'Aerofolio');

INSERT INTO Engenheiro(credencial_FIA_funcionario, especialidade)
VALUES('1011', 'Sistema Elétrico');

--Mecanico--

INSERT INTO Mecanico(credencial_FIA_funcionario, posicao_pit_stop, especialidade)
VALUES('1012', 'Gunners', 'Pneus');

INSERT INTO Mecanico(credencial_FIA_funcionario, posicao_pit_stop, especialidade)
VALUES('1013', 'Jack Men', 'Macaco Hidráulico');

INSERT INTO Mecanico(credencial_FIA_funcionario, posicao_pit_stop, especialidade)
VALUES('1014', 'Tire Off', 'Pneus');

INSERT INTO Mecanico(credencial_FIA_funcionario, posicao_pit_stop, especialidade)
VALUES('1015', 'Tire On', 'Pneus');

--Modelo_carro--

INSERT INTO Modelo_carro(nome_modelo, ano_projeto, nome_equipe_desenvolvedora, fabricante_motor)
VALUES('McQueen', TO_DATE('1993-06-16', 'YYYY-MM-DD'), 'Scuderia Ferrari', 'Latveria Produtos');

INSERT INTO Modelo_carro(nome_modelo, ano_projeto, nome_equipe_desenvolvedora, fabricante_motor)
VALUES('Mojangui', TO_DATE('2022-07-21', 'YYYY-MM-DD'), 'Mercedes-AMG Petronas', 'ACME');

INSERT INTO Modelo_carro(nome_modelo, ano_projeto, nome_equipe_desenvolvedora, fabricante_motor)
VALUES('Falcon', TO_DATE('1999-11-10', 'YYYY-MM-DD'), 'Oracle Red Bull Racing', 'Oscorp');

INSERT INTO Modelo_carro(nome_modelo, ano_projeto, nome_equipe_desenvolvedora, fabricante_motor)
VALUES('UltraSpeed', TO_DATE('2007-02-15', 'YYYY-MM-DD'), 'McLaren Formula 1 Team', 'DeLorean');

--Chassi--

INSERT INSERT Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status)
VALUES('1111', 'McQueen', TO_DATE('1993-06-16', 'YYYY-MM-DD'), 001, 'Desativado');

INSERT INSERT Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status)
VALUES('1112', 'Mojangui', TO_DATE('2022-07-21', 'YYYY-MM-DD'), 002, 'Ativo');

INSERT INSERT Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status)
VALUES('1113', 'Falcon', TO_DATE('1999-11-10', 'YYYY-MM-DD'), 003, 'Desativado');

INSERT INSERT Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status)
VALUES('1114', 'UltraSpeed', TO_DATE('2007-02-15', 'YYYY-MM-DD'), 004, 'Ativo');

--Participa_temporada--

INSERT INTO Participa_temporada(nome_equipe_participante, ano_temporada)
VALUES('Oracle Red Bull Racing', TO_DATE('', 'YYYY-MM-DD'));

INSERT INTO Participa_temporada(nome_equipe_participante, ano_temporada)
VALUES('Mercedes-AMG Petronas', TO_DATE('', 'YYYY-MM-DD'));

INSERT INTO Participa_temporada(nome_equipe_participante, ano_temporada)
VALUES('Scuderia Ferrari', TO_DATE('', 'YYYY-MM-DD'));

INSERT INTO Participa_temporada(nome_equipe_participante, ano_temporada)
VALUES('McLaren Formula 1 Team', TO_DATE('', 'YYYY-MM-DD'));