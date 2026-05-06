-- =================================================================           
-- POVOAMENTO PARTE 1: FUNDAÇÃO 
-- Tabelas: Pessoa, Telefone, Passaporte, Equipe, Patrocinador, Temporada
-- =================================================================
DECLARE
  v_cred_max     Pessoa.credencial_FIA%TYPE;
  v_cred_lewis   Pessoa.credencial_FIA%TYPE;
  v_cred_charles Pessoa.credencial_FIA%TYPE;
  v_cred_lando   Pessoa.credencial_FIA%TYPE;
  v_cred_juan    Pessoa.credencial_FIA%TYPE;
  v_cred_fabiana Pessoa.credencial_FIA%TYPE;
  v_cred_niels   Pessoa.credencial_FIA%TYPE;
  v_cred_george  Pessoa.credencial_FIA%TYPE;
  v_cred_kimi    Pessoa.credencial_FIA%TYPE;
  v_cred_toto    Pessoa.credencial_FIA%TYPE;
  v_cred_fred    Pessoa.credencial_FIA%TYPE;

  -- Variável temporária para inserção em massa (Engenheiros e Mecânicos)
  v_temp_cred    Pessoa.credencial_FIA%TYPE;
BEGIN





-- ==========================================
-- 1. ENTIDADE: Equipe
-- ==========================================
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Oracle Red Bull Racing', 'Milton Keynes', 'Reino Unido');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Scuderia Ferrari', 'Maranello', 'Itália');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Mercedes-AMG Petronas', 'Brackley', 'Reino Unido');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('McLaren Formula 1 Team', 'Woking', 'Reino Unido');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Aston Martin Aramco', 'Silverstone', 'Reino Unido');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Alpine F1 Team', 'Enstone', 'França');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Williams Racing', 'Grove', 'Reino Unido');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Visa Cash App RB', 'Faenza', 'Itália');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('MoneyGram Haas F1 Team', 'Kannapolis', 'EUA');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Audi F1 Team', 'Hinwil', 'Suíça');
INSERT INTO Equipe (nome_equipe, cidade, pais) VALUES ('Cadillac F1 Team', 'Fishers', 'EUA');





-- ==========================================
-- 2. ENTIDADES: Temporada e Patrocinador
-- ==========================================
INSERT INTO Temporada (ano) VALUES (2024);
INSERT INTO Temporada (ano) VALUES (2025);
INSERT INTO Temporada (ano) VALUES (2026);

INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa) VALUES ('5493006M94867W22V98', 'Oracle Corporation', 'EUA');
INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa) VALUES ('RE8900006M94867W22V11', 'Santander', 'Espanha');
INSERT INTO Patrocinador (LEI, nome_empresa, pais_empresa) VALUES ('PET770006M94867W22V33', 'Petronas', 'Malásia');





-- ==========================================
-- 3. ENTIDADE: Pessoa (Figuras Reais)
-- ==========================================
-- Chefes e Pilotos de todas as equipes e da FIA
FOR person IN (
    -- Adicionamos uma segunda coluna chamada 'dt' (Data)
    SELECT 'Christian Horner'   AS full_name, '1973-11-16' AS dt FROM DUAL UNION ALL
    SELECT 'Max Verstappen'     AS full_name, '1997-09-30' AS dt FROM DUAL UNION ALL
    SELECT 'Sergio Perez'       AS full_name, '1990-01-26' AS dt FROM DUAL UNION ALL

    SELECT 'Frederic Vasseur'   AS full_name, '1968-05-28' AS dt FROM DUAL UNION ALL
    SELECT 'Lewis Hamilton'     AS full_name, '1985-01-07' AS dt FROM DUAL UNION ALL
    SELECT 'Charles Leclerc'    AS full_name, '1997-10-16' AS dt FROM DUAL UNION ALL

    SELECT 'Toto Wolff'         AS full_name, '1972-01-12' AS dt FROM DUAL UNION ALL
    SELECT 'George Russell'     AS full_name, '1998-02-15' AS dt FROM DUAL UNION ALL
    SELECT 'Kimi Antonelli'     AS full_name, '2006-08-25' AS dt FROM DUAL UNION ALL

    SELECT 'Andrea Stella'      AS full_name, '1971-02-22' AS dt FROM DUAL UNION ALL
    SELECT 'Lando Norris'       AS full_name, '1999-11-13' AS dt FROM DUAL UNION ALL
    SELECT 'Oscar Piastri'      AS full_name, '2001-04-06' AS dt FROM DUAL UNION ALL

    SELECT 'Mike Krack'         AS full_name, '1972-03-18' AS dt FROM DUAL UNION ALL
    SELECT 'Fernando Alonso'    AS full_name, '1981-07-29' AS dt FROM DUAL UNION ALL
    SELECT 'Lance Stroll'       AS full_name, '1998-10-29' AS dt FROM DUAL UNION ALL

    SELECT 'Oliver Oakes'       AS full_name, '1988-01-11' AS dt FROM DUAL UNION ALL
    SELECT 'Pierre Gasly'       AS full_name, '1996-02-07' AS dt FROM DUAL UNION ALL
    SELECT 'Jack Doohan'        AS full_name, '2003-01-20' AS dt FROM DUAL UNION ALL

    SELECT 'James Vowles'       AS full_name, '1979-06-20' AS dt FROM DUAL UNION ALL
    SELECT 'Alex Albon'         AS full_name, '1996-03-23' AS dt FROM DUAL UNION ALL
    SELECT 'Carlos Sainz'       AS full_name, '1994-09-01' AS dt FROM DUAL UNION ALL

    SELECT 'Laurent Mekies'     AS full_name, '1977-04-28' AS dt FROM DUAL UNION ALL
    SELECT 'Yuki Tsunoda'       AS full_name, '2000-05-11' AS dt FROM DUAL UNION ALL
    SELECT 'Liam Lawson'        AS full_name, '2002-02-11' AS dt FROM DUAL UNION ALL

    SELECT 'Ayao Komatsu'       AS full_name, '1976-01-28' AS dt FROM DUAL UNION ALL
    SELECT 'Esteban Ocon'       AS full_name, '1996-09-17' AS dt FROM DUAL UNION ALL
    SELECT 'Oliver Bearman'     AS full_name, '2005-05-08' AS dt FROM DUAL UNION ALL

    SELECT 'Mattia Binotto'     AS full_name, '1969-11-03' AS dt FROM DUAL UNION ALL
    SELECT 'Nico Hulkenberg'    AS full_name, '1987-08-19' AS dt FROM DUAL UNION ALL
    SELECT 'Gabriel Bortoleto'  AS full_name, '2004-10-14' AS dt FROM DUAL UNION ALL

    SELECT 'Michael Andretti'   AS full_name, '1962-10-05' AS dt FROM DUAL UNION ALL
    SELECT 'Colton Herta'       AS full_name, '2000-03-30' AS dt FROM DUAL UNION ALL
    SELECT 'Logan Sargeant'     AS full_name, '2000-12-31' AS dt FROM DUAL UNION ALL

    SELECT 'Niels Wittich'      AS full_name, '1968-07-10' AS dt FROM DUAL UNION ALL
    SELECT 'Fabiana Flosi'      AS full_name, '1988-03-25' AS dt FROM DUAL
) LOOP
    -- Insere a figura real e captura o ID gerado na variável v_temp_cred
    INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
    VALUES (seq_credencial_fia.NEXTVAL, person.full_name, TO_DATE(person.dt, 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_temp_cred;

    -- Gera um Telefone Aleatório para o Piloto/Chefe
    INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) 
    VALUES ('+' || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 255))), TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(0, 255))), TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_temp_cred);

    -- Gera um Passaporte Aleatório para o Piloto/Chefe (Ex: 'A8B39X1Q')
    INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) 
    VALUES (DBMS_RANDOM.STRING('X', 8), 'Reino Unido', v_temp_cred, person.full_name, TO_DATE('2022-01-01','YYYY-MM-DD'), TO_DATE('2032-01-01','YYYY-MM-DD'));
END LOOP;                               -- Should also be random



-- ==========================================
-- 3. ENTIDADE: Pessoa (GERAÇÃO EM MASSA)
-- ==========================================
-- Staff Geral (5), Engenheiros (10) e Mecânicos (15) por
DECLARE
    v_cred Pessoa.credencial_FIA%TYPE;
    v_nome_gerado VARCHAR2(150);
BEGIN
    FOR eq IN (SELECT nome_equipe FROM Equipe) LOOP
        
        -- Gera 5 Gerais
        FOR i IN 1..5 LOOP
            v_nome_gerado := 'Staff Geral ' || i || ' ' || eq.nome_equipe;
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, TO_DATE('1985-06-15', 'YYYY-MM-DD')) RETURNING credencial_FIA INTO v_cred;
            
            -- Telefone e Passaporte gerados com DBMS_RANDOM para não haver duplicação de Primary Key
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) VALUES ('+44', '12', TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) VALUES (DBMS_RANDOM.STRING('X', 8), 'Reino Unido', v_cred, v_nome_gerado, TO_DATE('2020-01-01','YYYY-MM-DD'), TO_DATE('2030-01-01','YYYY-MM-DD'));
        END LOOP;
        
        -- Gera 10 Engenheiros
        FOR i IN 1..10 LOOP
            v_nome_gerado := 'Engenheiro ' || i || ' ' || eq.nome_equipe;
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, TO_DATE('1980-04-10', 'YYYY-MM-DD')) RETURNING credencial_FIA INTO v_cred;
            
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) VALUES ('+44', '13', TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) VALUES (DBMS_RANDOM.STRING('X', 8), 'Itália', v_cred, v_nome_gerado, TO_DATE('2021-01-01','YYYY-MM-DD'), TO_DATE('2031-01-01','YYYY-MM-DD'));
        END LOOP;
        
        -- Gera 15 Mecânicos
        FOR i IN 1..15 LOOP
            v_nome_gerado := 'Mecanico ' || i || ' ' || eq.nome_equipe;
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, TO_DATE('1992-11-22', 'YYYY-MM-DD')) RETURNING credencial_FIA INTO v_cred;
            
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) VALUES ('+44', '14', TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) VALUES (DBMS_RANDOM.STRING('X', 8), 'França', v_cred, v_nome_gerado, TO_DATE('2022-01-01','YYYY-MM-DD'), TO_DATE('2032-01-01','YYYY-MM-DD'));
        END LOOP;
        
    END LOOP;
END;

COMMIT;
END;
/