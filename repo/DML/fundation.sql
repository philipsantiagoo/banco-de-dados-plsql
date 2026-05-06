-- =================================================================           
-- POVOAMENTO PARTE 1: FUNDAÇÃO 
-- Tabelas: Pessoa, Telefone, Passaporte, Equipe, Patrocinador, Temporada
-- =================================================================


-- 
DECLARE
  v_cred Pessoa.credencial_FIA%TYPE;
  v_nome_gerado VARCHAR2(150);
  
  -- 1. Aumentamos o VARRAY para suportar até 20 itens
  TYPE t_array_texto IS VARRAY(20) OF VARCHAR2(50);
  
  -- Arrays de Países e DDIS (20 opções sincronizadas)
  v_paises t_array_texto := t_array_texto('Itália', 'Alemanha', 'França', 'Brasil', 'Japão', 'EUA', 'Espanha', 'Austrália', 'Canadá', 'Holanda', 'Bélgica', 'México', 'Suíça', 'Áustria', 'Finlândia', 'Portugal', 'Argentina', 'Polônia', 'Suécia', 'Noruega');
  v_ddis   t_array_texto := t_array_texto('+39', '+49', '+33', '+55', '+81', '+1', '+34', '+61', '+1', '+31', '+32', '+52', '+41', '+43', '+358', '+351', '+54', '+48', '+46', '+47');
  
  -- Arrays de Nomes e Sobrenomes (20 opções de cada)
  v_nomes      t_array_texto := t_array_texto('Arthur', 'Felipe', 'Gabriel', 'Philip', 'Vinicius', 'Lucas', 'Mateus', 'Ana', 'Julia', 'Mariana', 'Carlos', 'João', 'Pedro', 'Laura', 'Sofia', 'Liam', 'Emma', 'Oliver', 'Ava', 'Noah');
  v_sobrenomes t_array_texto := t_array_texto('Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Alves', 'Pereira', 'Lima', 'Gomes', 'Costa', 'Ribeiro', 'Martins', 'Carvalho', 'Almeida', 'Smith', 'Johnson', 'Williams', 'Brown', 'Jones');
  
  -- Variáveis auxiliares para os sorteios
  v_idx_pais      NUMBER;
  v_idx_nome      NUMBER;
  v_idx_sobrenome NUMBER;
  v_data_nasc     DATE;
  v_cod_regiao    VARCHAR2(5);
  v_data_emissao  DATE;
  v_data_validade DATE;

  v_cred_max     Pessoa.credencial_FIA%TYPE;
  v_cred_lewis   Pessoa.credencial_FIA%TYPE;
  v_cred_charles Pessoa.credencial_FIA%TYPE;
  v_cred_lando   Pessoa.credencial_FIA%TYPE;
  v_cred_juan    Pessoa.credencial_FIA%TYPE;
  v_cred_fabiana Pessoa.credencial_FIA%TYPE;
  v_cred_niels   Pessoa.credencial_FIA%TYPE;
BEGIN

--1. ENTIDADE: Pessoa

-- Max Verstappen
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Max Verstappen', TO_DATE('1997-09-30', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_max;

-- Lewis Hamilton
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Lewis Hamilton', TO_DATE('1985-01-07', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_lewis;

-- Charles Leclerc
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Charles Leclerc', TO_DATE('1997-10-16', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_charles;

-- Lando Norris
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Lando Norris', TO_DATE('1999-11-13', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_lando;

-- Juan Manuel Correa
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Juan Manuel Correa', TO_DATE('1990-05-12', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_juan;

-- Fabiana Flosi
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Fabiana Flosi', TO_DATE('1988-03-25', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_fabiana;

-- Niels Wittich
INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento)
  VALUES (seq_credencial_fia.NEXTVAL, 'Niels Wittich', TO_DATE('1968-07-10', 'YYYY-MM-DD'))
    RETURNING credencial_FIA INTO v_cred_niels;



--2. ENTIDADE: Telefone

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+31', '6', '912345678', v_cred_max);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+44', '20', '987654321', v_cred_lewis);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+64', '76', '989273401', v_cred_charles);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+51', '25', '973097990', v_cred_lando);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+593', '2', '998877665', v_cred_juan);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+39', '06', '887766554', v_cred_fabiana);

INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
  VALUES ('+49', '89', '776655443', v_cred_niels);    

-- 3. ENTIDADE: Passaporte

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('NV123456', 'Holanda', v_cred_max, 'Max Emilian Verstappen', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2032-01-01', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('LH987654', 'Reino Unido', v_cred_lewis, 'Lewis Carl Davidson Hamilton', TO_DATE('2021-05-15', 'YYYY-MM-DD'), TO_DATE('2031-05-15', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('MC778899', 'Mônaco', v_cred_charles, 'Charles Marc Hervé Perceval Leclerc', TO_DATE('2023-02-10', 'YYYY-MM-DD'), TO_DATE('2033-02-10', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('GB554433', 'Reino Unido', v_cred_lando, 'Lando Norris', TO_DATE('2022-11-20', 'YYYY-MM-DD'), TO_DATE('2032-11-20', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('JC112233', 'Equador', v_cred_juan, 'Juan Manuel Correa', 
        TO_DATE('2021-03-10', 'YYYY-MM-DD'), TO_DATE('2031-03-10', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('FF445566', 'Itália', v_cred_fabiana, 'Fabiana Flosi', 
        TO_DATE('2020-07-18', 'YYYY-MM-DD'), TO_DATE('2030-07-18', 'YYYY-MM-DD'));

INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade)
  VALUES ('NW778899', 'Alemanha', v_cred_niels, 'Niels Wittich', 
        TO_DATE('2019-11-25', 'YYYY-MM-DD'), TO_DATE('2029-11-25', 'YYYY-MM-DD'));

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




-- ==========================================
-- 7. ENTIDADE: Pessoa (GERAÇÃO EM MASSA COM DADOS 100% RANDÔMICOS)
-- ==========================================
    FOR eq IN (SELECT nome_equipe FROM Equipe) LOOP
        
        FOR i IN 1..5 LOOP
            -- Sorteia Nomes e Países
            v_idx_nome      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_sobrenome := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_pais      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            
            -- Combina o nome completo
            v_nome_gerado := v_nomes(v_idx_nome) || ' ' || v_sobrenomes(v_idx_sobrenome);
            
            -- Sorteios de Datas e Números
            v_data_nasc  := TO_DATE('1970-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 9125));
            v_cod_regiao := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
            
            -- Sorteia a emissão do passaporte para algum dia nos últimos 5 anos
            v_data_emissao  := TO_DATE('2019-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 1825));
            v_data_validade := ADD_MONTHS(v_data_emissao, 120); -- Adiciona 10 anos exatos à emissão
            
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) 
            VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, v_data_nasc) 
            RETURNING credencial_FIA INTO v_cred;
            
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) 
            VALUES (v_ddis(v_idx_pais), v_cod_regiao, TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) 
            VALUES (DBMS_RANDOM.STRING('X', 8), v_paises(v_idx_pais), v_cred, v_nome_gerado, v_data_emissao, v_data_validade);
        END LOOP;
        
        FOR i IN 1..10 LOOP
            v_idx_nome      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_sobrenome := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_pais      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            
            v_nome_gerado := v_nomes(v_idx_nome) || ' ' || v_sobrenomes(v_idx_sobrenome);
            
            v_data_nasc  := TO_DATE('1975-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 9125));
            v_cod_regiao := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
            v_data_emissao  := TO_DATE('2019-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 1825));
            v_data_validade := ADD_MONTHS(v_data_emissao, 120);
            
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) 
            VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, v_data_nasc) 
            RETURNING credencial_FIA INTO v_cred;
            
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) 
            VALUES (v_ddis(v_idx_pais), v_cod_regiao, TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) 
            VALUES (DBMS_RANDOM.STRING('X', 8), v_paises(v_idx_pais), v_cred, v_nome_gerado, v_data_emissao, v_data_validade);
        END LOOP;
        
        FOR i IN 1..15 LOOP
            v_idx_nome      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_sobrenome := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            v_idx_pais      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
            
            v_nome_gerado := v_nomes(v_idx_nome) || ' ' || v_sobrenomes(v_idx_sobrenome);
            
            v_data_nasc  := TO_DATE('1980-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 9125));
            v_cod_regiao := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
            v_data_emissao  := TO_DATE('2019-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 1825));
            v_data_validade := ADD_MONTHS(v_data_emissao, 120);
            
            INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) 
            VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, v_data_nasc) 
            RETURNING credencial_FIA INTO v_cred;
            
            INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) 
            VALUES (v_ddis(v_idx_pais), v_cod_regiao, TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
            
            INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) 
            VALUES (DBMS_RANDOM.STRING('X', 8), v_paises(v_idx_pais), v_cred, v_nome_gerado, v_data_emissao, v_data_validade);
        END LOOP;        
    END LOOP;

  COMMIT;
END;
/