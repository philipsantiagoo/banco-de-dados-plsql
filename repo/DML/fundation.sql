-- =================================================================           
-- POVOAMENTO PARTE 1: FUNDAÇÃO 
-- Tabelas: Pessoa, Telefone, Passaporte, Equipe, Patrocinador, Temporada
-- =================================================================


-- ENTIDADE: Pessoa

-- Max Verstappen
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
VALUES (seq_credencial_fia.NEXTVAL, 'Max Verstappen', TO_DATE('1997-09-30', 'YYYY-MM-DD'));

-- Lewis Hamilton
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
VALUES (seq_credencial_fia.NEXTVAL, 'Lewis Hamilton', TO_DATE('1985-01-07', 'YYYY-MM-DD'));

-- Charles Leclerc
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
VALUES (seq_credencial_fia.NEXTVAL, 'Charles Leclerc', TO_DATE('1997-10-16', 'YYYY-MM-DD'));

-- Lando Norris
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
VALUES (seq_credencial_fia.NEXTVAL, 'Lando Norris', TO_DATE('1999-11-13', 'YYYY-MM-DD'));



-- ENTIDADE: Telefone

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
VALUES ('+31', '6', '912345678', '1000');

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
VALUES ('+44', '20', '987654321', '1001');

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
VALUES ('+64', '76', '989273401', '1002');

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
VALUES ('+51', '25', '973097990', '1003');



-- 3. ENTIDADE: Passaporte

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
VALUES ('NV123456', 'Holanda', '1000', 'Max Emilian Verstappen', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2032-01-01', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
VALUES ('LH987654', 'Reino Unido', '1001', 'Lewis Carl Davidson Hamilton', TO_DATE('2021-05-15', 'YYYY-MM-DD'), TO_DATE('2031-05-15', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
VALUES ('MC778899', 'Mônaco', '1002', 'Charles Marc Hervé Perceval Leclerc', TO_DATE('2023-02-10', 'YYYY-MM-DD'), TO_DATE('2033-02-10', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
VALUES ('GB554433', 'Reino Unido', '1003', 'Lando Norris', TO_DATE('2022-11-20', 'YYYY-MM-DD'), TO_DATE('2032-11-20', 'YYYY-MM-DD'));



-- 4. ENTIDADE: Equipe

INSERT INTO Equipe (nome_equipe, cidade, pais)
VALUES ('Oracle Red Bull Racing', 'Milton Keynes', 'Reino Unido');

INSERT INTO Equipe (nome_equipe, cidade, pais)
VALUES ('Scuderia Ferrari', 'Maranello', 'Itália');

INSERT INTO Equipe (nome_equipe, cidade, pais)
VALUES ('Mercedes-AMG Petronas', 'Brackley', 'Reino Unido');

INSERT INTO Equipe (nome_equipe, cidade, pais)
VALUES ('McLaren Formula 1 Team', 'Woking', 'Reino Unido');



-- 5. ENTIDADE: Patrocinador

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa)
VALUES ('5493006M94867W22V98', 'Oracle Corporation', 'EUA');

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa)
VALUES ('RE8900006M94867W22V11', 'Santander', 'Espanha');

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa)
VALUES ('PET770006M94867W22V33', 'Petronas', 'Malásia');

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa)
VALUES ('ARAMCO006M94867W22V55', 'Aramco', 'Arábia Saudita');

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa)
VALUES ('AWS110006M94867W22V99', 'Amazon Web Services', 'EUA');



-- 6. ENTIDADE: Temporada

INSERT INTO Temporada (ano) VALUES (2024);
INSERT INTO Temporada (ano) VALUES (2025);
INSERT INTO Temporada (ano) VALUES (2026);

COMMIT;