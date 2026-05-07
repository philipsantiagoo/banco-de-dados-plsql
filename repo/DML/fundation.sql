-- =================================================================           
-- POVOAMENTO PARTE 1: FUNDAÇÃO 
-- Tabelas: Pessoa, Telefone, Passaporte, Equipe, Patrocinador, Temporada
-- =================================================================

DECLARE
  v_cred Pessoa.credencial_FIA%TYPE;
  v_nome_gerado VARCHAR2(150);
  
  TYPE t_array_texto IS VARRAY(20) OF VARCHAR2(50);
  
  v_paises t_array_texto := t_array_texto('Itália', 'Alemanha', 'França', 'Brasil', 'Japão', 'EUA', 'Espanha', 'Austrália', 'Canadá', 'Holanda', 'Bélgica', 'México', 'Suíça', 'Áustria', 'Finlândia', 'Portugal', 'Argentina', 'Polônia', 'Suécia', 'Noruega');
  v_ddis   t_array_texto := t_array_texto('+39', '+49', '+33', '+55', '+81', '+1', '+34', '+61', '+1', '+31', '+32', '+52', '+41', '+43', '+358', '+351', '+54', '+48', '+46', '+47');
  
  v_nomes      t_array_texto := t_array_texto('Arthur', 'Felipe', 'Gabriel', 'Philip', 'Vinicius', 'Lucas', 'Mateus', 'Ana', 'Julia', 'Mariana', 'Carlos', 'João', 'Pedro', 'Laura', 'Sofia', 'Liam', 'Emma', 'Oliver', 'Ava', 'Noah');
  v_sobrenomes t_array_texto := t_array_texto('Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Alves', 'Pereira', 'Lima', 'Gomes', 'Costa', 'Ribeiro', 'Martins', 'Carvalho', 'Almeida', 'Smith', 'Johnson', 'Williams', 'Brown', 'Jones');
  
  v_idx_pais      NUMBER;
  v_idx_nome      NUMBER;
  v_idx_sobrenome NUMBER;
  v_data_nasc     DATE;
  v_cod_regiao    VARCHAR2(5);
  v_data_emissao  DATE;
  v_data_validade DATE;

BEGIN

-- 1. ENTIDADE: Pessoa (Figuras Fixas: Pilotos, Chefes e FIA)
  FOR p IN (
      SELECT 'Max Verstappen' AS n, '1997-09-30' AS dt FROM DUAL UNION ALL
      SELECT 'Lewis Hamilton', '1985-01-07' FROM DUAL UNION ALL
      SELECT 'Charles Leclerc', '1997-10-16' FROM DUAL UNION ALL
      SELECT 'Lando Norris', '1999-11-13' FROM DUAL UNION ALL
      SELECT 'Juan Manuel Correa', '1990-05-12' FROM DUAL UNION ALL
      SELECT 'Fabiana Flosi', '1988-03-25' FROM DUAL UNION ALL
      SELECT 'Niels Wittich', '1968-07-10' FROM DUAL UNION ALL
      SELECT 'Christian Horner', '1973-11-16' FROM DUAL UNION ALL
      SELECT 'Frederic Vasseur', '1968-05-28' FROM DUAL UNION ALL
      SELECT 'Andrea Stella', '1971-02-22' FROM DUAL UNION ALL
      SELECT 'Toto Wolff', '1972-01-12' FROM DUAL
  ) LOOP
      INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) VALUES (seq_credencial_fia.NEXTVAL, p.n, TO_DATE(p.dt, 'YYYY-MM-DD')) RETURNING credencial_FIA INTO v_cred;
      INSERT INTO Telefone (codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa) VALUES ('+44', '11', TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
      INSERT INTO Passaporte (numero, pais_emissor, credencial_FIA_pessoa, nome_registrado, data_emissao, data_validade) VALUES (DBMS_RANDOM.STRING('X', 8), 'Reino Unido', v_cred, p.n, TO_DATE('2022-01-01','YYYY-MM-DD'), TO_DATE('2032-01-01','YYYY-MM-DD'));
  END LOOP;

-- 2. ENTIDADE: Equipe
  INSERT INTO Localidade (id_localidade, cidade, estado, pais) VALUES (seq_localidade.NEXTVAL, 'Milton Keynes', 'Buckinghamshire', 'Reino Unido');
  INSERT INTO Equipe (nome_equipe, id_localidade) VALUES ('Oracle Red Bull Racing', seq_localidade.CURRVAL);

  INSERT INTO Localidade (id_localidade, cidade, estado, pais) VALUES (seq_localidade.NEXTVAL, 'Maranello', 'Emilia-Romagna', 'Itália');
  INSERT INTO Equipe (nome_equipe, id_localidade) VALUES ('Scuderia Ferrari', seq_localidade.CURRVAL);

  INSERT INTO Localidade (id_localidade, cidade, estado, pais) VALUES (seq_localidade.NEXTVAL, 'Brackley', 'Northamptonshire', 'Reino Unido');
  INSERT INTO Equipe (nome_equipe, id_localidade) VALUES ('Mercedes-AMG Petronas', seq_localidade.CURRVAL);

  INSERT INTO Localidade (id_localidade, cidade, estado, pais) VALUES (seq_localidade.NEXTVAL, 'Woking', 'Surrey', 'Reino Unido');
  INSERT INTO Equipe (nome_equipe, id_localidade) VALUES ('McLaren Formula 1 Team', seq_localidade.CURRVAL);
  
  -- 3. ENTIDADE: Patrocinador
  INSERT INTO Patrocinador VALUES ('5493006M94867W22V98', 'Oracle Corporation', 'EUA');
  INSERT INTO Patrocinador VALUES ('RE8900006M94867W22V11', 'Santander', 'Espanha');
  INSERT INTO Patrocinador VALUES ('PET770006M94867W22V33', 'Petronas', 'Malásia');
  INSERT INTO Patrocinador VALUES ('ARAMCO006M94867W22V55', 'Aramco', 'Arábia Saudita');
  INSERT INTO Patrocinador VALUES ('AWS110006M94867W22V99', 'Amazon Web Services', 'EUA');

-- 4. ENTIDADE: Temporada
  INSERT INTO Temporada VALUES (2024);
  INSERT INTO Temporada VALUES (2025);
  INSERT INTO Temporada VALUES (2026);

-- 5. GERAÇÃO EM MASSA (Apenas 4 pessoas aleatórias por equipe com nomes puramente humanos)
  FOR eq IN (SELECT nome_equipe FROM Equipe) LOOP
      FOR i IN 1..4 LOOP
          v_idx_nome      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
          v_idx_sobrenome := TRUNC(DBMS_RANDOM.VALUE(1, 21));
          v_idx_pais      := TRUNC(DBMS_RANDOM.VALUE(1, 21));
          
          -- Nome puramente humano (ex: "Arthur Silva")
          v_nome_gerado := v_nomes(v_idx_nome) || ' ' || v_sobrenomes(v_idx_sobrenome);
          
          v_data_nasc  := TO_DATE('1980-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 9125));
          v_cod_regiao := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(10, 99)));
          v_data_emissao  := TO_DATE('2019-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 1825));
          
          INSERT INTO Pessoa (credencial_FIA, nome, data_nascimento) VALUES (seq_credencial_fia.NEXTVAL, v_nome_gerado, v_data_nasc) RETURNING credencial_FIA INTO v_cred;
          INSERT INTO Telefone VALUES (v_ddis(v_idx_pais), v_cod_regiao, TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999))), v_cred);
          INSERT INTO Passaporte VALUES (DBMS_RANDOM.STRING('X', 8), v_paises(v_idx_pais), v_cred, v_nome_gerado, v_data_emissao, ADD_MONTHS(v_data_emissao, 120));
      END LOOP;
  END LOOP;
  
  COMMIT;
END;
/