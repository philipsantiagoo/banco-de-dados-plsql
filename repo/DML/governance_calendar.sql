-- =================================================================           
-- POVOAMENTO PARTE 4: Calendário, Eventos e FIA
-- =================================================================
BEGIN

-- 1. ENTIDADE: Funcionario_FIA
INSERT INTO Funcionario_FIA VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Juan Manuel Correa'), 'LS-JMC001', 'Race Steward');
INSERT INTO Funcionario_FIA VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Fabiana Flosi'), 'LS-FF002', 'Race Control Officer');
INSERT INTO Funcionario_FIA VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Niels Wittich'), 'LS-NW003', 'Race Director');

-- 2. ENTIDADE: Grande_premio
INSERT INTO Grande_premio VALUES ('Grand Prix da Austrália', 2024, 'Austrália', 58, 'Albert Park');
INSERT INTO Grande_premio VALUES ('Grand Prix de Mônaco', 2024, 'Mônaco', 78, 'Circuit de Monaco');
INSERT INTO Grande_premio VALUES ('Grand Prix da Grã-Bretanha', 2024, 'Reino Unido', 52, 'Silverstone');
INSERT INTO Grande_premio VALUES ('Grand Prix do Brasil', 2025, 'Brasil', 71, 'Interlagos');

-- 3. ENTIDADE: Sessao 
INSERT INTO Sessao VALUES ('Treino Livre 1', 'Grand Prix da Austrália', 2024, DATE '2024-03-22', TIMESTAMP '2024-03-22 10:30:00');
INSERT INTO Sessao VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, DATE '2024-03-22', TIMESTAMP '2024-03-22 14:30:00');
INSERT INTO Sessao VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, DATE '2024-03-23', TIMESTAMP '2024-03-23 17:00:00');
INSERT INTO Sessao VALUES ('Corrida', 'Grand Prix da Austrália', 2024, DATE '2024-03-24', TIMESTAMP '2024-03-24 15:00:00');
INSERT INTO Sessao VALUES ('Qualificação', 'Grand Prix de Mônaco', 2024, DATE '2024-05-25', TIMESTAMP '2024-05-25 14:00:00');

-- 4. ENTIDADE: Atua_em 
INSERT INTO Atua_em VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Juan Manuel Correa'), 'Treino Livre 1', 'Grand Prix da Austrália', 2024);
INSERT INTO Atua_em VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Juan Manuel Correa'), 'Treino Livre 2', 'Grand Prix da Austrália', 2024);
INSERT INTO Atua_em VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Fabiana Flosi'), 'Qualificação', 'Grand Prix da Austrália', 2024);
INSERT INTO Atua_em VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Niels Wittich'), 'Corrida', 'Grand Prix da Austrália', 2024);
INSERT INTO Atua_em VALUES ((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Niels Wittich'), 'Qualificação', 'Grand Prix de Mônaco', 2024);

COMMIT;
END;
/