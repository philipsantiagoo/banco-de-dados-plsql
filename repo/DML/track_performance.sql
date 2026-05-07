-- =================================================================           
-- POVOAMENTO PARTE 5: DESEMPENHO E TELEMETRIA DE PISTA
-- =================================================================
BEGIN

-- =================================================================
-- 1. CORRIDA: GP DA AUSTRÁLIA (2024)
-- =================================================================

-- LEWIS HAMILTON (P5)
INSERT INTO Participa_sessao (tipo_sessao, nome_gp, ano_gp, credencial_FIA_piloto, codigo_chassi, nome_modelo, ano_projeto_modelo, posicao_final, tempo_final, pontos, status_participacao) 
VALUES ('Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), '1112', 'Mojangui', 2022, 5, NUMTODSINTERVAL(5400.123, 'SECOND'), 10, 'Finalizado');

INSERT INTO Volta (numero_volta, tipo_sessao, nome_gp, ano_gp, credencial_FIA_piloto, posicao_piloto, setor1, setor2, setor3, tempo_volta)
SELECT LEVEL, 'Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), 5,
       NUMTODSINTERVAL(30 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'),
       NUMTODSINTERVAL(28 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'),
       NUMTODSINTERVAL(29 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'),
       NUMTODSINTERVAL(87 + LEVEL * 0.05 + DBMS_RANDOM.VALUE(0, 2), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 58;

INSERT INTO Telemetria (timestamp_leitura, numero_volta, tipo_sessao, nome_gp, ano_gp, credencial_FIA_piloto, temperatura_pneus, pressao_pneus, porcentagem_bateria_ERS, rpm, aceleracao, velocidade)
SELECT TIMESTAMP '2024-03-24 15:00:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Corrida', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (90 + v.numero_volta * 0.3 + DBMS_RANDOM.VALUE(0, 2)), (21 + DBMS_RANDOM.VALUE(0, 2)),
       LEAST(100, GREATEST(0, 100 - s.amostra * 0.8 + DBMS_RANDOM.VALUE(0, 3))),
       CASE WHEN s.amostra <= 20 THEN 9000 + DBMS_RANDOM.VALUE(0, 1000) WHEN s.amostra <= 60 THEN 12000 + DBMS_RANDOM.VALUE(0, 1500) WHEN s.amostra <= 80 THEN 8000 + DBMS_RANDOM.VALUE(0, 1000) ELSE 10000 + DBMS_RANDOM.VALUE(0, 1200) END,
       CASE WHEN s.amostra <= 20 THEN 0.9 WHEN s.amostra <= 60 THEN 0.7 + DBMS_RANDOM.VALUE(0, 0.3) WHEN s.amostra <= 80 THEN 0.3 + DBMS_RANDOM.VALUE(0, 0.2) ELSE 0.5 + DBMS_RANDOM.VALUE(0, 0.3) END,
       CASE WHEN v.numero_volta = 25 AND s.amostra BETWEEN 40 AND 60 THEN 80 + DBMS_RANDOM.VALUE(0, 20) WHEN v.numero_volta = 1 AND s.amostra <= 20 THEN 150 + DBMS_RANDOM.VALUE(0, 30) WHEN s.amostra BETWEEN 21 AND 60 THEN 280 + DBMS_RANDOM.VALUE(0, 20) WHEN s.amostra BETWEEN 61 AND 80 THEN 120 + DBMS_RANDOM.VALUE(0, 30) ELSE 200 + DBMS_RANDOM.VALUE(0, 50) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton') AND v.nome_gp = 'Grand Prix da Austrália' AND v.ano_gp = 2024 AND v.tipo_sessao = 'Corrida';


-- MAX VERSTAPPEN (P1)
INSERT INTO Participa_sessao VALUES ('Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), '1113', 'Falcon', 1999, 1, NUMTODSINTERVAL(5350.321, 'SECOND'), 25, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 1,
       NUMTODSINTERVAL(29.5 + LEVEL * 0.01 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(27.5 + LEVEL * 0.01 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(28.5 + LEVEL * 0.01 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(85 + LEVEL * 0.03 + DBMS_RANDOM.VALUE(0, 1), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 58;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-24 15:00:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Corrida', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (88 + v.numero_volta * 0.25 + DBMS_RANDOM.VALUE(0, 1)), (21 + DBMS_RANDOM.VALUE(0, 1)), LEAST(100, GREATEST(0, 100 - s.amostra * 0.8 + DBMS_RANDOM.VALUE(0, 3))),
       CASE WHEN s.amostra BETWEEN 21 AND 60 THEN 12500 + DBMS_RANDOM.VALUE(0, 1000) WHEN s.amostra BETWEEN 61 AND 80 THEN 9000 + DBMS_RANDOM.VALUE(0, 800) ELSE 11000 + DBMS_RANDOM.VALUE(0, 1000) END,
       CASE WHEN s.amostra BETWEEN 61 AND 80 THEN 0.3 + DBMS_RANDOM.VALUE(0, 0.2) ELSE 0.7 + DBMS_RANDOM.VALUE(0, 0.3) END,
       CASE WHEN v.numero_volta = 20 AND s.amostra BETWEEN 40 AND 60 THEN 90 + DBMS_RANDOM.VALUE(0, 10) WHEN s.amostra BETWEEN 21 AND 60 THEN 300 + DBMS_RANDOM.VALUE(0, 15) WHEN s.amostra BETWEEN 61 AND 80 THEN 130 + DBMS_RANDOM.VALUE(0, 20) ELSE 220 + DBMS_RANDOM.VALUE(0, 40) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen') AND v.nome_gp = 'Grand Prix da Austrália' AND v.ano_gp = 2024 AND v.tipo_sessao = 'Corrida';


-- CHARLES LECLERC (P2)
INSERT INTO Participa_sessao VALUES ('Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), '1111', 'McQueen', 1993, 2, NUMTODSINTERVAL(5370.654, 'SECOND'), 18, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), 2,
       NUMTODSINTERVAL(30 + LEVEL * 0.015 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(28 + LEVEL * 0.015 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(29 + LEVEL * 0.015 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(87 + LEVEL * 0.04 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 58;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-24 15:00:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Corrida', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (89 + v.numero_volta * 0.28 + DBMS_RANDOM.VALUE(0, 2)), (21 + DBMS_RANDOM.VALUE(0, 1.5)), LEAST(100, GREATEST(0, 100 - s.amostra * 0.7 + DBMS_RANDOM.VALUE(0, 3))),
       CASE WHEN s.amostra BETWEEN 21 AND 60 THEN 12200 + DBMS_RANDOM.VALUE(0, 1200) WHEN s.amostra BETWEEN 61 AND 80 THEN 8800 + DBMS_RANDOM.VALUE(0, 1000) ELSE 10500 + DBMS_RANDOM.VALUE(0, 1200) END,
       CASE WHEN s.amostra BETWEEN 61 AND 80 THEN 0.35 + DBMS_RANDOM.VALUE(0, 0.2) ELSE 0.65 + DBMS_RANDOM.VALUE(0, 0.3) END,
       CASE WHEN v.numero_volta = 22 AND s.amostra BETWEEN 40 AND 60 THEN 85 + DBMS_RANDOM.VALUE(0, 15) WHEN s.amostra BETWEEN 21 AND 60 THEN 285 + DBMS_RANDOM.VALUE(0, 20) WHEN s.amostra BETWEEN 61 AND 80 THEN 125 + DBMS_RANDOM.VALUE(0, 25) ELSE 210 + DBMS_RANDOM.VALUE(0, 50) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc') AND v.nome_gp = 'Grand Prix da Austrália' AND v.ano_gp = 2024 AND v.tipo_sessao = 'Corrida';


-- LANDO NORRIS (P4)
INSERT INTO Participa_sessao VALUES ('Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), '1114', 'UltraSpeed', 2007, 4, NUMTODSINTERVAL(5410.777, 'SECOND'), 12, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Corrida', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), 4,
       NUMTODSINTERVAL(31 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(29 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(30 + LEVEL * 0.02 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(90 + LEVEL * 0.06 + DBMS_RANDOM.VALUE(0, 3), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 58;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-24 15:00:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Corrida', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (90 + v.numero_volta * 0.35 + DBMS_RANDOM.VALUE(0, 3)), (21 + DBMS_RANDOM.VALUE(0, 2)), LEAST(100, GREATEST(0, 100 - s.amostra * 0.7 + DBMS_RANDOM.VALUE(0, 3))),
       CASE WHEN s.amostra BETWEEN 21 AND 60 THEN 11800 + DBMS_RANDOM.VALUE(0, 1500) WHEN s.amostra BETWEEN 61 AND 80 THEN 8500 + DBMS_RANDOM.VALUE(0, 1200) ELSE 10000 + DBMS_RANDOM.VALUE(0, 1500) END,
       CASE WHEN s.amostra BETWEEN 61 AND 80 THEN 0.3 + DBMS_RANDOM.VALUE(0, 0.3) ELSE 0.6 + DBMS_RANDOM.VALUE(0, 0.4) END,
       CASE WHEN v.numero_volta = 18 AND s.amostra BETWEEN 40 AND 60 THEN 80 + DBMS_RANDOM.VALUE(0, 20) WHEN s.amostra BETWEEN 21 AND 60 THEN 270 + DBMS_RANDOM.VALUE(0, 30) WHEN s.amostra BETWEEN 61 AND 80 THEN 120 + DBMS_RANDOM.VALUE(0, 35) ELSE 200 + DBMS_RANDOM.VALUE(0, 60) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris') AND v.nome_gp = 'Grand Prix da Austrália' AND v.ano_gp = 2024 AND v.tipo_sessao = 'Corrida';


-- =================================================================
-- 2. QUALIFICAÇÃO: GP DA AUSTRÁLIA (2024)
-- =================================================================

--  MAX VERSTAPPEN (P1 Quali)
INSERT INTO Participa_sessao VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), '1113', 'Falcon', 1999, 1, NUMTODSINTERVAL(82.345, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 1,
       NUMTODSINTERVAL(28 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(26 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(27 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND'), NUMTODSINTERVAL(82 + DBMS_RANDOM.VALUE(0, 0.5), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 3;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-23 17:00:00' + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Qualificação', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (95 + DBMS_RANDOM.VALUE(0, 3)), (22 + DBMS_RANDOM.VALUE(0, 1)), GREATEST(0, 100 - s.amostra * 1.2), (13000 + DBMS_RANDOM.VALUE(0, 1500)), (0.8 + DBMS_RANDOM.VALUE(0, 0.2)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 310 + DBMS_RANDOM.VALUE(0, 10) WHEN s.amostra BETWEEN 61 AND 80 THEN 140 + DBMS_RANDOM.VALUE(0, 20) ELSE 250 + DBMS_RANDOM.VALUE(0, 30) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen') AND v.tipo_sessao = 'Qualificação' AND v.nome_gp = 'Grand Prix da Austrália';


-- CHARLES LECLERC (P3 Quali)
INSERT INTO Participa_sessao VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), '1111', 'McQueen', 1993, 3, NUMTODSINTERVAL(82.900, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), 3,
       NUMTODSINTERVAL(28.5 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(26.5 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(27.5 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(83 + DBMS_RANDOM.VALUE(0, 1), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 3;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-23 17:00:00' + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Qualificação', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (96 + DBMS_RANDOM.VALUE(0, 3)), (22 + DBMS_RANDOM.VALUE(0, 1)), GREATEST(0, 100 - s.amostra * 1.3), (12800 + DBMS_RANDOM.VALUE(0, 1400)), (0.75 + DBMS_RANDOM.VALUE(0, 0.25)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 300 + DBMS_RANDOM.VALUE(0, 15) WHEN s.amostra BETWEEN 61 AND 80 THEN 135 + DBMS_RANDOM.VALUE(0, 20) ELSE 240 + DBMS_RANDOM.VALUE(0, 40) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc') AND v.tipo_sessao = 'Qualificação' AND v.nome_gp = 'Grand Prix da Austrália';


-- LEWIS HAMILTON (P2 Quali)
INSERT INTO Participa_sessao VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), '1112', 'Mojangui', 2022, 2, NUMTODSINTERVAL(83.200, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), 2,
       NUMTODSINTERVAL(29 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(27 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(28 + DBMS_RANDOM.VALUE(0, 1), 'SECOND'), NUMTODSINTERVAL(83.5 + DBMS_RANDOM.VALUE(0, 1), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 3;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-23 17:00:00' + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Qualificação', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (95 + DBMS_RANDOM.VALUE(0, 3)), (22 + DBMS_RANDOM.VALUE(0, 1)), GREATEST(0, 100 - s.amostra * 1.1), (12500 + DBMS_RANDOM.VALUE(0, 1300)), (0.7 + DBMS_RANDOM.VALUE(0, 0.3)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 295 + DBMS_RANDOM.VALUE(0, 20) WHEN s.amostra BETWEEN 61 AND 80 THEN 130 + DBMS_RANDOM.VALUE(0, 25) ELSE 230 + DBMS_RANDOM.VALUE(0, 40) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton') AND v.tipo_sessao = 'Qualificação' AND v.nome_gp = 'Grand Prix da Austrália';


-- LANDO NORRIS (P4 Quali)
INSERT INTO Participa_sessao VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), '1114', 'UltraSpeed', 2007, 4, NUMTODSINTERVAL(84.100, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Qualificação', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), 4,
       NUMTODSINTERVAL(29.5 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(27.5 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(28.5 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(84 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 3;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-23 17:00:00' + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Qualificação', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (97 + DBMS_RANDOM.VALUE(0, 4)), (22 + DBMS_RANDOM.VALUE(0, 2)), GREATEST(0, 100 - s.amostra * 1.4), (12200 + DBMS_RANDOM.VALUE(0, 1500)), (0.65 + DBMS_RANDOM.VALUE(0, 0.35)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 285 + DBMS_RANDOM.VALUE(0, 25) WHEN s.amostra BETWEEN 61 AND 80 THEN 125 + DBMS_RANDOM.VALUE(0, 30) ELSE 220 + DBMS_RANDOM.VALUE(0, 50) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris') AND v.tipo_sessao = 'Qualificação' AND v.nome_gp = 'Grand Prix da Austrália';


-- =================================================================
-- 3. TREINO LIVRE 2: GP DA AUSTRÁLIA (2024)
-- =================================================================

-- LANDO NORRIS (P1 TL2)
INSERT INTO Participa_sessao VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), '1114', 'UltraSpeed', 2007, 1, NUMTODSINTERVAL(87.900, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), 1,
       NUMTODSINTERVAL(30 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(28 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(29 + DBMS_RANDOM.VALUE(0, 1.5), 'SECOND'), NUMTODSINTERVAL(88 + DBMS_RANDOM.VALUE(0, 3), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 22;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-22 14:30:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (87 + DBMS_RANDOM.VALUE(0, 4)), (21 + DBMS_RANDOM.VALUE(0, 2)), (70 + DBMS_RANDOM.VALUE(0, 30)), (9500 + DBMS_RANDOM.VALUE(0, 2500)), (0.5 + DBMS_RANDOM.VALUE(0, 0.4)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 280 + DBMS_RANDOM.VALUE(0, 20) WHEN s.amostra BETWEEN 61 AND 80 THEN 130 + DBMS_RANDOM.VALUE(0, 25) ELSE 210 + DBMS_RANDOM.VALUE(0, 40) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris') AND v.tipo_sessao = 'Treino Livre 2';


-- LEWIS HAMILTON (P2 TL2)
INSERT INTO Participa_sessao VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), '1112', 'Mojangui', 2022, 2, NUMTODSINTERVAL(88.300, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), 2,
       NUMTODSINTERVAL(30.5 + DBMS_RANDOM.VALUE(0, 2), 'SECOND'), NUMTODSINTERVAL(28.5 + DBMS_RANDOM.VALUE(0, 2), 'SECOND'), NUMTODSINTERVAL(29.5 + DBMS_RANDOM.VALUE(0, 2), 'SECOND'), NUMTODSINTERVAL(89 + DBMS_RANDOM.VALUE(0, 4), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 25;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-22 14:30:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (88 + DBMS_RANDOM.VALUE(0, 5)), (21 + DBMS_RANDOM.VALUE(0, 2)), (65 + DBMS_RANDOM.VALUE(0, 35)), (9300 + DBMS_RANDOM.VALUE(0, 2700)), (0.45 + DBMS_RANDOM.VALUE(0, 0.45)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 275 + DBMS_RANDOM.VALUE(0, 25) WHEN s.amostra BETWEEN 61 AND 80 THEN 125 + DBMS_RANDOM.VALUE(0, 30) ELSE 205 + DBMS_RANDOM.VALUE(0, 50) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton') AND v.tipo_sessao = 'Treino Livre 2';


-- CHARLES LECLERC (P3 TL2)
INSERT INTO Participa_sessao VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), '1111', 'McQueen', 1993, 3, NUMTODSINTERVAL(88.900, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), 3,
       NUMTODSINTERVAL(31 + DBMS_RANDOM.VALUE(0, 2.5), 'SECOND'), NUMTODSINTERVAL(29 + DBMS_RANDOM.VALUE(0, 2.5), 'SECOND'), NUMTODSINTERVAL(30 + DBMS_RANDOM.VALUE(0, 2.5), 'SECOND'), NUMTODSINTERVAL(90 + DBMS_RANDOM.VALUE(0, 5), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 17;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-22 14:30:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (89 + DBMS_RANDOM.VALUE(0, 5)), (21 + DBMS_RANDOM.VALUE(0, 2)), (60 + DBMS_RANDOM.VALUE(0, 40)), (9100 + DBMS_RANDOM.VALUE(0, 2900)), (0.4 + DBMS_RANDOM.VALUE(0, 0.5)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 270 + DBMS_RANDOM.VALUE(0, 30) WHEN s.amostra BETWEEN 61 AND 80 THEN 120 + DBMS_RANDOM.VALUE(0, 35) ELSE 200 + DBMS_RANDOM.VALUE(0, 60) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc') AND v.tipo_sessao = 'Treino Livre 2';


-- MAX VERSTAPPEN (P4 TL2)
INSERT INTO Participa_sessao VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), '1113', 'Falcon', 1999, 4, NUMTODSINTERVAL(90.200, 'SECOND'), 0, 'Finalizado');

INSERT INTO Volta SELECT LEVEL, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 4,
       NUMTODSINTERVAL(32 + DBMS_RANDOM.VALUE(0, 3), 'SECOND'), NUMTODSINTERVAL(30 + DBMS_RANDOM.VALUE(0, 3), 'SECOND'), NUMTODSINTERVAL(31 + DBMS_RANDOM.VALUE(0, 3), 'SECOND'), NUMTODSINTERVAL(92 + DBMS_RANDOM.VALUE(0, 6), 'SECOND')
FROM DUAL CONNECT BY LEVEL <= 37;

INSERT INTO Telemetria SELECT TIMESTAMP '2024-03-22 14:30:00' + NUMTODSINTERVAL(v.numero_volta, 'MINUTE') + NUMTODSINTERVAL(s.amostra, 'SECOND'),
       v.numero_volta, 'Treino Livre 2', 'Grand Prix da Austrália', 2024, v.credencial_FIA_piloto,
       (90 + DBMS_RANDOM.VALUE(0, 6)), (21 + DBMS_RANDOM.VALUE(0, 3)), (50 + DBMS_RANDOM.VALUE(0, 50)), (8800 + DBMS_RANDOM.VALUE(0, 3000)), (0.35 + DBMS_RANDOM.VALUE(0, 0.5)),
       CASE WHEN s.amostra BETWEEN 20 AND 60 THEN 260 + DBMS_RANDOM.VALUE(0, 35) WHEN s.amostra BETWEEN 61 AND 80 THEN 115 + DBMS_RANDOM.VALUE(0, 40) ELSE 190 + DBMS_RANDOM.VALUE(0, 70) END
FROM Volta v CROSS JOIN (SELECT LEVEL AS amostra FROM DUAL CONNECT BY LEVEL <= 100) s
WHERE v.credencial_FIA_piloto = (SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen') AND v.tipo_sessao = 'Treino Livre 2';

COMMIT;
END;
/