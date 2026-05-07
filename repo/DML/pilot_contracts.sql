-- =================================================================           
-- POVOAMENTO PARTE 3: Pilotos, Finanças e Substituições
-- Tabelas: Piloto, Contrato, Patrocina, Substitui
-- =================================================================

BEGIN
-- 1. ENTIDADE: Piloto
INSERT INTO Piloto VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 'VER-001');
INSERT INTO Piloto VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), 'HAM-008');
INSERT INTO Piloto VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), 'LEC-016');
INSERT INTO Piloto VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), 'NOR-004');

-- 2. ENTIDADE: Contrato (Patrocinador-Equipe)
INSERT INTO Contrato VALUES ('Oracle Red Bull Racing', '5493006M94867W22V98', DATE '2024-01-01', DATE '2026-12-31', 150000000);
INSERT INTO Contrato VALUES ('Scuderia Ferrari', 'RE8900006M94867W22V11', DATE '2023-02-12', DATE '2026-02-02', 120000000);
INSERT INTO Contrato VALUES ('Mercedes-AMG Petronas', 'PET770006M94867W22V33', DATE '2018-10-10', DATE '2025-01-11', 100000000);
INSERT INTO Contrato VALUES ('Scuderia Ferrari', 'ARAMCO006M94867W22V55', DATE '2006-12-12', NULL, 80000000);
INSERT INTO Contrato VALUES ('McLaren Formula 1 Team', 'AWS110006M94867W22V99', DATE '2024-01-01', DATE '2026-12-31', 90000000);

-- 3. ENTIDADE: Patrocina (Patrocinador-Piloto)
INSERT INTO Patrocina VALUES ('5493006M94867W22V98', (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), DATE '2024-01-01', DATE '2026-12-31', 5000000); 
INSERT INTO Patrocina VALUES ('RE8900006M94867W22V11', (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), DATE '2023-02-12', DATE '2025-12-31', 4000000); 
INSERT INTO Patrocina VALUES ('RE8900006M94867W22V11', (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), DATE '2002-09-11', NULL, 3000000); 
INSERT INTO Patrocina VALUES ('ARAMCO006M94867W22V55', (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), DATE '2024-01-01', DATE '2026-12-31', 2500000); 
INSERT INTO Patrocina VALUES ('AWS110006M94867W22V99', (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), DATE '2018-01-02', DATE '2026-12-12', 3500000);

-- 4. ENTIDADE: Substitui
INSERT INTO Substitui VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, 
    (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 
    (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris')
);

COMMIT;
END;
/