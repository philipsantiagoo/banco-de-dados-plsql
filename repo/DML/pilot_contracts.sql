-- =================================================================           
-- POVOAMENTO PARTE 4: Pilotos, Finanças e Substituições
-- Tabelas: Piloto, Contrato, Patrocina, Substitui
-- =================================================================

-- 1. ENTIDADE: Piloto

INSERT INTO Piloto (credencial_FIA_pessoa, superlicenca)
VALUES ('1000', 'VER-001');

INSERT INTO Piloto (credencial_FIA_pessoa, superlicenca)
VALUES ('1001', 'HAM-008');

INSERT INTO Piloto (credencial_FIA_pessoa, superlicenca)
VALUES ('1002', 'LEC-016');

INSERT INTO Piloto (credencial_FIA_pessoa, superlicenca)
VALUES ('1003', 'NOR-004');

-- 2. ENTIDADE: Contrato (Patrocinador-Equipe)

INSERT INTO Contrato (nome_equipe_patrocinada, LEI_patrocinador, data_inicio, data_fim, valor)
VALUES ('Oracle Red Bull Racing', '5493006M94867W22V98', DATE '2024-01-01', DATE '2026-12-31', 150000000);

INSERT INTO Contrato (nome_equipe_patrocinada, LEI_patrocinador, data_inicio, data_fim, valor)
VALUES ('Scuderia Ferrari', 'RE8900006M94867W22V11', DATE '2023-02-12', DATE '2026-02-02', 120000000);

INSERT INTO Contrato (nome_equipe_patrocinada, LEI_patrocinador, data_inicio, data_fim, valor)
VALUES ('Mercedes-AMG Petronas', 'PET770006M94867W22V33', DATE '2018-10-10', DATE '2025-01-11', 100000000);

INSERT INTO Contrato (nome_equipe_patrocinada, LEI_patrocinador, data_inicio, data_fim, valor)
VALUES ('Scuderia Ferrari', 'ARAMCO006M94867W22V55', DATE '2006-12-12', NULL, 80000000);

INSERT INTO Contrato (nome_equipe_patrocinada, LEI_patrocinador, data_inicio, data_fim, valor)
VALUES ('McLaren Formula 1 Team', 'AWS110006M94867W22V99', DATE '2024-01-01', DATE '2026-12-31', 90000000);

-- 3. ENTIDADE: Patrocina (Patrocinador-Piloto)

INSERT INTO Patrocina (LEI_patrocinador, credencial_FIA_piloto, data_inicio, data_fim, valor)
VALUES ('5493006M94867W22V98', '1000', DATE '2024-01-01', DATE '2026-12-31', 5000000);  -- Verstappen-Oracle

INSERT INTO Patrocina (LEI_patrocinador, credencial_FIA_piloto, data_inicio, data_fim, valor)
VALUES ('RE8900006M94867W22V11', '1001', DATE '2023-02-12', DATE '2025-12-31', 4000000);  -- Hamilton-Santander

INSERT INTO Patrocina (LEI_patrocinador, credencial_FIA_piloto, data_inicio, data_fim, valor)
VALUES ('RE8900006M94867W22V11', '1002', DATE '2002-09-11', NULL, 3000000);  -- Leclerc-Santander

INSERT INTO Patrocina (LEI_patrocinador, credencial_FIA_piloto, data_inicio, data_fim, valor)
VALUES ('ARAMCO006M94867W22V55', '1002', DATE '2024-01-01', DATE '2026-12-31', 2500000);  -- Leclerc-Aramco

INSERT INTO Patrocina (LEI_patrocinador, credencial_FIA_piloto, data_inicio, data_fim, valor)
VALUES ('AWS110006M94867W22V99', '1003', DATE '2018-01-02', DATE '2026-12-12', 3500000);  -- Norris-AWS

-- 4. ENTIDADE: Substitui (Substituição de Pilotos)

INSERT INTO Substitui (tipo_sessao, nome_gp, ano_gp, credencial_FIA_piloto_substituido, credencial_FIA_piloto_substituto)
VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, '1000', '1003');

COMMIT;

