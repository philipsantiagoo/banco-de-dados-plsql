/*
================================================================
Informações sobre a participação de pilotos em sessões de um fim de semana de GP, incluindo dados detalhados de voltas e telemetria, para a corrida da Austrália de 2024. Os dados incluem tempos de volta, setores, condições dos pneus, uso do ERS, RPM do motor, aceleração e velocidade, simulando o desempenho dos pilotos durante a corrida.
================================================================
*/

-- participacao do Hamilton na corrida da Austrália de 2024
INSERT INTO Participa_sessao (
    tipo_sessao,
    nome_gp,
    ano_gp,
    credencial_FIA_piloto,
    codigo_chassi,
    nome_modelo,
    ano_projeto_modelo,
    posicao_final,
    tempo_final,
    pontos,
    status
) VALUES (
    'Corrida',
    'Austrália',
    2024,
    (
        SELECT p.credencial_FIA
        FROM Pessoa p
        WHERE p.nome = 'Lewis Hamilton'
    ),
    '1112',  -- chassi do carro
    'Mojangui',  -- modelo do carro
    2024,
    5,
    5400.123, -- tempo total em segundos (exemplo)
    10,
    'Finalizado'
);

-- Corrida completa do Hamilton
INSERT INTO Volta (
    numero_volta,
    tipo_sessao,
    nome_gp,
    ano_gp,
    credencial_FIA_piloto,
    posicao_piloto,
    setor_1,
    setor_2,
    setor_3,
    tempo_volta
)
SELECT
    gs AS numero_volta,
    'Corrida',
    'Austrália',
    2024,
    p.credencial_FIA_pessoa,

    -- posição simples (pode evoluir depois)
    5,

    -- setores variando com desgaste
    (30 + gs * 0.02 + random()) AS setor_1,
    (28 + gs * 0.02 + random()) AS setor_2,
    (29 + gs * 0.02 + random()) AS setor_3,

    -- tempo total coerente
    (87 + gs * 0.05 + random()*2)

FROM generate_series(1, 58) AS gs
JOIN Piloto p ON TRUE
JOIN Pessoa pe ON pe.credencial_FIA = p.credencial_FIA_pessoa
WHERE pe.nome = 'Lewis Hamilton';


-- dados coletados na pista a cada volta (100 amostras por volta) para o Hamilton na corrida da Austrália de 2024
INSERT INTO Telemetria (
    time_stamp,
    numero_volta,
    tipo_sessao,
    nome_gp,
    ano_gp,
    credencial_FIA_piloto,
    temperatura_pneus,
    pressao_pneus,
    porcentagem_ERS,
    rpm_motor,
    aceleracao,
    velocidade
)
SELECT
    TIMESTAMP '2024-03-24 10:00:00'
        + (v.numero_volta || ' minutes')::interval
        + (gs || ' seconds')::interval,

    v.numero_volta,
    'Corrida',
    'Austrália',
    2024,
    v.credencial_FIA_piloto,

    -- 🔥 desgaste progressivo
    (90 + v.numero_volta * 0.3 + random()*2),

    (21 + random()*2),

    -- 🔋 ERS diminui ao longo da volta
    GREATEST(0, 100 - gs * 0.8 + random()*3),

    -- 🔧 RPM ligado à fase da pista
    CASE
        WHEN gs BETWEEN 1 AND 20 THEN 9000 + random()*1000   -- largada
        WHEN gs BETWEEN 21 AND 60 THEN 12000 + random()*1500 -- reta
        WHEN gs BETWEEN 61 AND 80 THEN 8000 + random()*1000  -- curva
        ELSE 10000 + random()*1200
    END,

    -- 🚀 aceleração
    CASE
        WHEN gs BETWEEN 1 AND 20 THEN 0.9
        WHEN gs BETWEEN 21 AND 60 THEN 0.7 + random()*0.3
        WHEN gs BETWEEN 61 AND 80 THEN 0.3 + random()*0.2
        ELSE 0.5 + random()*0.3
    END,

    -- 🏎 velocidade com lógica de pista + PIT STOP
    CASE
        -- PIT STOP na volta 25
        WHEN v.numero_volta = 25 AND gs BETWEEN 40 AND 60 THEN
            80 + random()*20

        -- largada (volta 1)
        WHEN v.numero_volta = 1 AND gs < 20 THEN
            150 + random()*30

        -- reta
        WHEN gs BETWEEN 21 AND 60 THEN
            280 + random()*20

        -- curva
        WHEN gs BETWEEN 61 AND 80 THEN
            120 + random()*30

        -- transição
        ELSE
            200 + random()*50
    END

FROM Volta v
JOIN generate_series(1, 100) AS gs ON TRUE
JOIN Pessoa pe ON pe.credencial_FIA = v.credencial_FIA_piloto
WHERE pe.nome = 'Lewis Hamilton'
AND v.nome_gp = 'Austrália'
AND v.ano_gp = 2024;
AND v.tipo_sessao = 'Corrida';


-- participação de Max Verstappen na corrida da Austrália de 2024
INSERT INTO Participa_sessao (
    tipo_sessao,
    nome_gp,
    ano_gp,
    credencial_FIA_piloto,
    codigo_chassi,
    nome_modelo,
    ano_projeto_modelo,
    posicao_final,
    tempo_final,
    pontos,
    status
)
VALUES (
    'Corrida',
    'Grand Prix da Austrália',
    2024,
    '1000',
    '1113',
    'Falcon',
    DATE '1999-11-10',
    1,  -- 1º lugar
    5350.321,
    25,
    'Finalizado'
);

-- Corrida completa do Verstappen
INSERT INTO Volta (
    numero_volta,
    tipo_sessao,
    nome_gp,
    ano_gp,
    credencial_FIA_piloto,
    posicao_piloto,
    setor_1,
    setor_2,
    setor_3,
    tempo_volta
)
SELECT
    gs,
    'Corrida',
    'Grand Prix da Austrália',
    2024,
    '1000',
    1,

    (29.5 + gs * 0.01 + random()*0.5),
    (27.5 + gs * 0.01 + random()*0.5),
    (28.5 + gs * 0.01 + random()*0.5),

    (85 + gs * 0.03 + random())

FROM generate_series(1, 58) AS gs;


-- dados coletados na pista a cada volta (100 amostras por volta) para o Verstappen na corrida da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-24 15:00:00'
        + (v.numero_volta || ' minutes')::interval
        + (gs || ' seconds')::interval,

    v.numero_volta,
    'Corrida',
    'Grand Prix da Austrália',
    2024,
    '1000',

    (88 + v.numero_volta * 0.25 + random()),

    (21 + random()),

    GREATEST(0, 100 - gs * 0.7 + random()*2),

    CASE
        WHEN gs BETWEEN 21 AND 60 THEN 12500 + random()*1000
        WHEN gs BETWEEN 61 AND 80 THEN 9000 + random()*800
        ELSE 11000 + random()*1000
    END,

    CASE
        WHEN gs BETWEEN 61 AND 80 THEN 0.3 + random()*0.2
        ELSE 0.7 + random()*0.3
    END,

    CASE
        WHEN v.numero_volta = 20 AND gs BETWEEN 40 AND 60 THEN
            90 + random()*10
        WHEN gs BETWEEN 21 AND 60 THEN
            300 + random()*15
        WHEN gs BETWEEN 61 AND 80 THEN
            130 + random()*20
        ELSE
            220 + random()*40
    END

FROM Volta v
JOIN generate_series(1, 100) gs ON TRUE
WHERE v.credencial_FIA_piloto = '1000'
AND v.nome_gp = 'Grand Prix da Austrália'
AND v.ano_gp = 2024;

-- participação de Charles Leclerc na corrida da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Corrida','Grand Prix da Austrália',2024,
    '1002','1111','McQueen',DATE '1993-06-16',
    2,5370.654,18,'Finalizado' -- terminou em 2º lugar
);

-- Corrida completa do Leclerc
INSERT INTO Volta (...)
SELECT
    gs,'Corrida','Grand Prix da Austrália',2024,'1002',2,
    (30 + gs*0.015 + random()),
    (28 + gs*0.015 + random()),
    (29 + gs*0.015 + random()),
    (87 + gs*0.04 + random()*1.5)
FROM generate_series(1,58) gs;


-- dados coletados na pista a cada volta (100 amostras por volta) para o Leclerc na corrida da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-24 15:00:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Corrida','Grand Prix da Austrália',2024,'1002',

    (89 + v.numero_volta * 0.28 + random()*2),

    (21 + random()*1.5),

    GREATEST(0, 100 - gs * 0.75 + random()*2),

    CASE
        WHEN gs BETWEEN 21 AND 60 THEN 12200 + random()*1200
        WHEN gs BETWEEN 61 AND 80 THEN 8800 + random()*1000
        ELSE 10500 + random()*1200
    END,

    CASE
        WHEN gs BETWEEN 61 AND 80 THEN 0.35 + random()*0.2
        ELSE 0.65 + random()*0.3
    END,

    CASE
        WHEN v.numero_volta = 22 AND gs BETWEEN 40 AND 60 THEN
            85 + random()*15
        WHEN gs BETWEEN 21 AND 60 THEN
            285 + random()*20
        WHEN gs BETWEEN 61 AND 80 THEN
            125 + random()*25
        ELSE
            210 + random()*50
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto = '1002'
AND v.nome_gp = 'Grand Prix da Austrália'
AND v.ano_gp = 2024;

-- participação de Lando Norris na corrida da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Corrida','Grand Prix da Austrália',2024,
    '1003','1114','UltraSpeed',DATE '2007-02-15',
    4,5410.777,12,'Finalizado' -- terminou em 4º lugar
); 

-- Corrida completa do Norris
INSERT INTO Volta (...)
SELECT
    gs,'Corrida','Grand Prix da Austrália',2024,'1003',4,
    (31 + gs*0.02 + random()*1.5),
    (29 + gs*0.02 + random()*1.5),
    (30 + gs*0.02 + random()*1.5),
    (90 + gs*0.06 + random()*3)
FROM generate_series(1,58) gs;

-- dados coletados na pista a cada volta (100 amostras por volta) para o Norris na corrida da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-24 15:00:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Corrida','Grand Prix da Austrália',2024,'1003',

    (90 + v.numero_volta * 0.35 + random()*3),

    (21 + random()*2),

    GREATEST(0, 100 - gs * 0.9 + random()*3),

    CASE
        WHEN gs BETWEEN 21 AND 60 THEN 11800 + random()*1500
        WHEN gs BETWEEN 61 AND 80 THEN 8500 + random()*1200
        ELSE 10000 + random()*1500
    END,

    CASE
        WHEN gs BETWEEN 61 AND 80 THEN 0.3 + random()*0.3
        ELSE 0.6 + random()*0.4
    END,

    CASE
        WHEN v.numero_volta = 18 AND gs BETWEEN 40 AND 60 THEN
            80 + random()*20
        WHEN gs BETWEEN 21 AND 60 THEN
            270 + random()*30
        WHEN gs BETWEEN 61 AND 80 THEN
            120 + random()*35
        ELSE
            200 + random()*60
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto = '1003'
AND v.nome_gp = 'Grand Prix da Austrália'
AND v.ano_gp = 2024;

/*
================================================================
Informações sobre a participação de pilotos em sessões de um fim de semana de GP, incluindo dados detalhados de voltas e telemetria, para a sessão classificatória (qualificação) da Austrália de 2024. Os dados incluem tempos de volta, setores, condições dos pneus, uso do ERS, RPM do motor, aceleração e velocidade, simulando o desempenho dos pilotos durante a sessão.
================================================================
*/

-- participação de Max Verstappen na qualificação da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Qualificação','Grand Prix da Austrália',2024,
    '1000','1113','Falcon',DATE '1999-11-10',
    1,82.345,0,'Finalizado'
);

-- Qualificação completa do Verstappen (P1)
INSERT INTO Volta (...)
SELECT
    gs,
    'Qualificação',
    'Grand Prix da Austrália',
    2024,
    '1000',
    1,

    (28 + random()*0.5),
    (26 + random()*0.5),
    (27 + random()*0.5),

    (82 + random()*0.5)

FROM generate_series(1,3) gs;

-- dados coletados na pista a cada volta (100 amostras por volta) para o Verstappen na qualificação da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-23 17:00:00'
    + (gs || ' seconds')::interval,

    v.numero_volta,
    'Qualificação',
    'Grand Prix da Austrália',
    2024,
    '1000',

    (95 + random()*3),
    (22 + random()),

    GREATEST(0, 100 - gs * 1.2),

    (13000 + random()*1500),

    (0.8 + random()*0.2),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 310 + random()*10
        WHEN gs BETWEEN 61 AND 80 THEN 140 + random()*20
        ELSE 250 + random()*30
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1000'
AND v.tipo_sessao='Qualificação'
AND v.nome_gp='Grand Prix da Austrália';

-- participação de Charles Leclerc na qualificação da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Qualificação','Grand Prix da Austrália',2024,
    '1002','1111','McQueen',DATE '1993-06-16',
    3,82.900,0,'Finalizado'
);

-- Qualificação completa do Leclerc (P3)
INSERT INTO Volta (...)
SELECT
    gs,'Qualificação','Grand Prix da Austrália',2024,'1002',3,
    (28.5 + random()),
    (26.5 + random()),
    (27.5 + random()),
    (83 + random())
FROM generate_series(1,3) gs;

-- dados coletados na pista a cada volta (100 amostras por volta) para o Leclerc na qualificação da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-23 17:00:00'
    + (gs || ' seconds')::interval,

    v.numero_volta,'Qualificação','Grand Prix da Austrália',2024,'1002',

    (96 + random()*3),
    (22 + random()),

    GREATEST(0, 100 - gs * 1.3),

    (12800 + random()*1400),

    (0.75 + random()*0.25),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 300 + random()*15
        WHEN gs BETWEEN 61 AND 80 THEN 135 + random()*20
        ELSE 240 + random()*40
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1002'
AND v.tipo_sessao='Qualificação'
AND v.nome_gp='Grand Prix da Austrália';

-- participação de Lewis Hamilton na qualificação da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Qualificação','Grand Prix da Austrália',2024,
    '1001','1111','McQueen',DATE '1993-06-16',
    2,83.200,0,'Finalizado'
);

-- Qualificação completa do Hamilton (P2)
INSERT INTO Volta (...)
SELECT
    gs,'Qualificação','Grand Prix da Austrália',2024,'1001',2,
    (29 + random()),
    (27 + random()),
    (28 + random()),
    (83.5 + random())
FROM generate_series(1,3) gs;

-- dados coletados na pista a cada volta (100 amostras por volta) para o Hamilton na qualificação da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-23 17:00:00'
    + (gs || ' seconds')::interval,

    v.numero_volta,'Qualificação','Grand Prix da Austrália',2024,'1001',

    (95 + random()*3),
    (22 + random()),

    GREATEST(0, 100 - gs * 1.1),

    (12500 + random()*1300),

    (0.7 + random()*0.3),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 295 + random()*20
        WHEN gs BETWEEN 61 AND 80 THEN 130 + random()*25
        ELSE 230 + random()*40
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1001'
AND v.tipo_sessao='Qualificação'
AND v.nome_gp='Grand Prix da Austrália';

-- participação de Lando Norris na qualificação da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Qualificação','Grand Prix da Austrália',2024,
    '1003','1114','UltraSpeed',DATE '2007-02-15',
    4,84.100,0,'Finalizado'
);

-- Qualificação completa do Norris (P4)
INSERT INTO Volta (...)
SELECT
    gs,'Qualificação','Grand Prix da Austrália',2024,'1003',4,
    (29.5 + random()*1.5),
    (27.5 + random()*1.5),
    (28.5 + random()*1.5),
    (84 + random()*1.5)
FROM generate_series(1,3) gs;

-- dados coletados na pista a cada volta (100 amostras por volta) para o Norris na qualificação da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-23 17:00:00'
    + (gs || ' seconds')::interval,

    v.numero_volta,'Qualificação','Grand Prix da Austrália',2024,'1003',

    (97 + random()*4),
    (22 + random()*2),

    GREATEST(0, 100 - gs * 1.4),

    (12200 + random()*1500),

    (0.65 + random()*0.35),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 285 + random()*25
        WHEN gs BETWEEN 61 AND 80 THEN 125 + random()*30
        ELSE 220 + random()*50
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1003'
AND v.tipo_sessao='Qualificação'
AND v.nome_gp='Grand Prix da Austrália';


/*
===================================================================
Informações sobre a participação dos pilotos no treino livre 2 do GP da Austrália de 2024, contendo os mesmos dados de todos os pilotos participantes das sessões acima, mudando apenas o tipo de sessão e os tempos, para simular a evolução dos pilotos ao longo do fim de semana.
===================================================================
*/


-- participação de Lando Norris no treino livre 2 da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Treino Livre 2','Grand Prix da Austrália',2024,
    '1003','1114','UltraSpeed',DATE '2007-02-15',
    1,87.900,0,'Finalizado'
);

-- Treino Livre 2 completo do Norris
INSERT INTO Volta (...)
SELECT
    gs,'Treino Livre 2','Grand Prix da Austrália',2024,'1003',1,
    (30 + random()*1.5),
    (28 + random()*1.5),
    (29 + random()*1.5),
    (88 + random()*3)
FROM generate_series(1,22) gs; -- 22 voltas completadas, fazendo um treino mais curto e focado em acerto de corrida, com muitos testes de pneus e simulações de corrida


-- dados coletados na pista a cada volta (100 amostras por volta) para o Norris no treino livre 2 da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-22 14:30:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Treino Livre 2','Grand Prix da Austrália',2024,'1003',

    (87 + random()*4),
    (21 + random()*2),

    (70 + random()*30),

    (9500 + random()*2500),

    (0.5 + random()*0.4),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 280 + random()*20
        WHEN gs BETWEEN 61 AND 80 THEN 130 + random()*25
        ELSE 210 + random()*40
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1003'
AND v.tipo_sessao='Treino Livre 2';

-- participação de Lewis Hamilton no treino livre 2 da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Treino Livre 2','Grand Prix da Austrália',2024,
    '1001','1111','McQueen',DATE '1993-06-16',
    2,88.300,0,'Finalizado'
);

-- Treino Livre 2 completo do Hamilton
INSERT INTO Volta (...)
SELECT
    gs,'Treino Livre 2','Grand Prix da Austrália',2024,'1001',2,
    (30.5 + random()*2),
    (28.5 + random()*2),
    (29.5 + random()*2),
    (89 + random()*4)
FROM generate_series(1,25) gs; -- 25 voltas concluídas nessa sessão, simulando um teste de setup mediano, com foco em acerto de corrida e simulações de corrida, mas sem muitos testes de pneus ou simulações longas


-- dados coletados na pista a cada volta (100 amostras por volta) para o Hamilton no treino livre 2 da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-22 14:30:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Treino Livre 2','Grand Prix da Austrália',2024,'1001',

    (88 + random()*5),
    (21 + random()*2),

    (65 + random()*35),

    (9300 + random()*2700),

    (0.45 + random()*0.45),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 275 + random()*25
        WHEN gs BETWEEN 61 AND 80 THEN 125 + random()*30
        ELSE 205 + random()*50
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1001'
AND v.tipo_sessao='Treino Livre 2';


-- participação de Charles Leclerc no treino livre 2 da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Treino Livre 2','Grand Prix da Austrália',2024,
    '1002','1111','McQueen',DATE '1993-06-16',
    3,88.900,0,'Finalizado'
);


-- Treino Livre 2 completo do Leclerc
INSERT INTO Volta (...)
SELECT
    gs,'Treino Livre 2','Grand Prix da Austrália',2024,'1002',3,
    (31 + random()*2.5),
    (29 + random()*2.5),
    (30 + random()*2.5),
    (90 + random()*5)
FROM generate_series(1,17) gs; -- 17 voltas completadas, simulando um teste de setup mais curto em decorrência de um pequeno problema técnico que não pôde ser resolvido a tempo de fazer o Leclerc voltar para a pista, mas que não comprometeu o restante do fim de semana


-- dados coletados na pista a cada volta (100 amostras por volta) para o Leclerc no treino livre 2 da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-22 14:30:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Treino Livre 2','Grand Prix da Austrália',2024,'1002',

    (89 + random()*5),
    (21 + random()*2),

    (60 + random()*40),

    (9100 + random()*2900),

    (0.4 + random()*0.5),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 270 + random()*30
        WHEN gs BETWEEN 61 AND 80 THEN 120 + random()*35
        ELSE 200 + random()*60
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1002'
AND v.tipo_sessao='Treino Livre 2';

-- participação de Max Verstappen no treino livre 2 da Austrália de 2024
INSERT INTO Participa_sessao VALUES (
    'Treino Livre 2','Grand Prix da Austrália',2024,
    '1000','1113','Falcon',DATE '1999-11-10',
    4,90.200,0,'Finalizado'
);

-- Treino Livre 2 completo do Verstappen
INSERT INTO Volta (...)
SELECT
    gs,'Treino Livre 2','Grand Prix da Austrália',2024,'1000',4,
    (32 + random()*3),
    (30 + random()*3),
    (31 + random()*3),
    (92 + random()*6)
FROM generate_series(1,37) gs; -- 37 voltas concluídas, simulando um teste de setup mais longo e focado em acerto de corrida, com muitos testes de pneus e simulações de corrida


-- dados coletados na pista a cada volta (100 amostras por volta) para o Verstappen no treino livre 2 da Austrália de 2024
INSERT INTO Telemetria (...)
SELECT
    TIMESTAMP '2024-03-22 14:30:00'
    + (v.numero_volta || ' minutes')::interval
    + (gs || ' seconds')::interval,

    v.numero_volta,'Treino Livre 2','Grand Prix da Austrália',2024,'1000',

    (90 + random()*6),
    (21 + random()*3),

    (50 + random()*50),

    (8800 + random()*3000),

    (0.35 + random()*0.5),

    CASE
        WHEN gs BETWEEN 20 AND 60 THEN 260 + random()*35
        WHEN gs BETWEEN 61 AND 80 THEN 115 + random()*40
        ELSE 190 + random()*70
    END

FROM Volta v
JOIN generate_series(1,100) gs ON TRUE
WHERE v.credencial_FIA_piloto='1000'
AND v.tipo_sessao='Treino Livre 2';