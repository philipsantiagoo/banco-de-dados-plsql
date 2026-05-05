-- =================================================================           
-- POVOAMENTO PARTE 1: FUNDAÇÃO 
-- Tabelas: Pessoa, Telefone, Passaporte, Equipe, Patrocinador, Temporada
-- =================================================================


-- 
DECLARE
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


-- 7. ENTIDADE: Funcionario_FIA

INSERT INTO Funcionario_FIA (credencial_FIA_pessoa, licenca_staff, cargo_exercido)
  VALUES (v_cred_juan, 'LS-JMC001', 'Race Steward');

INSERT INTO Funcionario_FIA (credencial_FIA_pessoa, licenca_staff, cargo_exercido)
  VALUES (v_cred_fabiana, 'LS-FF002', 'Race Control Officer');

INSERT INTO Funcionario_FIA (credencial_FIA_pessoa, licenca_staff, cargo_exercido)
  VALUES (v_cred_niels, 'LS-NW003', 'Race Director');

-- 8. ENTIDADE: Grande_premio

INSERT INTO Grande_premio (nome_gp, ano_temporada, pais, numero_voltas, circuito)
  VALUES ('Grand Prix da Austrália', 2024, 'Austrália', 58, 'Albert Park');

INSERT INTO Grande_premio (nome_gp, ano_temporada, pais, numero_voltas, circuito)
  VALUES ('Grand Prix de Mônaco', 2024, 'Mônaco', 78, 'Circuit de Monaco');

INSERT INTO Grande_premio (nome_gp, ano_temporada, pais, numero_voltas, circuito)
  VALUES ('Grand Prix da Grã-Bretanha', 2024, 'Reino Unido', 52, 'Silverstone');

INSERT INTO Grande_premio (nome_gp, ano_temporada, pais, numero_voltas, circuito)
  VALUES ('Grand Prix do Brasil', 2025, 'Brasil', 71, 'Interlagos');

-- 9. ENTIDADE: Sessao 

INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
  VALUES ('Treino Livre 1', 'Grand Prix da Austrália', 2024, TO_DATE('2024-03-22', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-03-22 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
  VALUES ('Treino Livre 2', 'Grand Prix da Austrália', 2024, TO_DATE('2024-03-22', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-03-22 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
  VALUES ('Qualificação', 'Grand Prix da Austrália', 2024, TO_DATE('2024-03-23', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-03-23 17:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
  VALUES ('Corrida', 'Grand Prix da Austrália', 2024, TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-03-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
  VALUES ('Qualificação', 'Grand Prix de Mônaco', 2024, TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-05-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- 10. ENTIDADE: Atua_em 

INSERT INTO Atua_em (credencial_FIA_funcionario, tipo_sessao, nome_gp, ano_gp)
  VALUES (v_cred_juan, 'Treino Livre 1', 'Grand Prix da Austrália', 2024);

INSERT INTO Atua_em (credencial_FIA_funcionario, tipo_sessao, nome_gp, ano_gp)
  VALUES (v_cred_juan, 'Treino Livre 2', 'Grand Prix da Austrália', 2024);

INSERT INTO Atua_em (credencial_FIA_funcionario, tipo_sessao, nome_gp, ano_gp)
  VALUES (v_cred_fabiana, 'Qualificação', 'Grand Prix da Austrália', 2024);

INSERT INTO Atua_em (credencial_FIA_funcionario, tipo_sessao, nome_gp, ano_gp)
  VALUES (v_cred_niels, 'Corrida', 'Grand Prix da Austrália', 2024);

INSERT INTO Atua_em (credencial_FIA_funcionario, tipo_sessao, nome_gp, ano_gp)
  VALUES (v_cred_niels, 'Qualificação', 'Grand Prix de Mônaco', 2024);

  COMMIT;
END;
/