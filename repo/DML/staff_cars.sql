-- =================================================================           
-- POVOAMENTO PARTE 2: ESTRUTURA TÉCNICA
-- =================================================================

BEGIN
-- Funcionario_equipe (Pilotos)
INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Max Verstappen'), 'Oracle Red Bull Racing', '1200-3000', 'Piloto', 'Equipe de Corrida');
INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lewis Hamilton'), 'Scuderia Ferrari', '1200-3001', 'Piloto', 'Equipe de Corrida');
INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Charles Leclerc'), 'Scuderia Ferrari', '1200-3002', 'Piloto', 'Equipe de Corrida');
INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Lando Norris'), 'McLaren Formula 1 Team', '1200-3003', 'Piloto', 'Equipe de Corrida');

-- Funcionario_equipe e Chefe
INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Frederic Vasseur'), 'Scuderia Ferrari', 'CH-001', 'Team Principal', NULL);
INSERT INTO Chefe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Frederic Vasseur'), 'Scuderia Ferrari', TO_DATE('1992-03-22', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Andrea Stella'), 'McLaren Formula 1 Team', 'CH-002', 'Team Principal', NULL);
INSERT INTO Chefe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Andrea Stella'), 'McLaren Formula 1 Team', TO_DATE('2005-09-01', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Christian Horner'), 'Oracle Red Bull Racing', 'CH-003', 'Team Principal', NULL);
INSERT INTO Chefe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Christian Horner'), 'Oracle Red Bull Racing', TO_DATE('2023-06-13', 'YYYY-MM-DD'), 'Chefe');

INSERT INTO Funcionario_equipe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Toto Wolff'), 'Mercedes-AMG Petronas', 'CH-004', 'Team Principal', NULL);
INSERT INTO Chefe VALUES((SELECT credencial_FIA FROM Pessoa WHERE nome = 'Toto Wolff'), 'Mercedes-AMG Petronas', TO_DATE('2011-02-24', 'YYYY-MM-DD'), 'Chefe');

-- Modelo_carro
INSERT INTO Modelo_carro VALUES('McQueen', 1993, 'Scuderia Ferrari', 'Latveria Produtos');
INSERT INTO Modelo_carro VALUES('Mojangui', 2022, 'Mercedes-AMG Petronas', 'ACME');
INSERT INTO Modelo_carro VALUES('Falcon', 1999, 'Oracle Red Bull Racing', 'Oscorp');
INSERT INTO Modelo_carro VALUES('UltraSpeed', 2007, 'McLaren Formula 1 Team', 'DeLorean');

-- Chassi (Corrigido o erro de digitação e os nomes das colunas)
INSERT INTO Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status_carro) VALUES('1111', 'McQueen', 1993, 1, 'DS');
INSERT INTO Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status_carro) VALUES('1112', 'Mojangui', 2022, 2, 'AT');
INSERT INTO Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status_carro) VALUES('1113', 'Falcon', 1999, 3, 'DS');
INSERT INTO Chassi(codigo_chassi, nome_modelo, ano_projeto_modelo, numero_carro, status_carro) VALUES('1114', 'UltraSpeed', 2007, 4, 'AT');

-- Participa_temporada (Ano é NUMBER, não TO_DATE)
INSERT INTO Participa_temporada VALUES('Oracle Red Bull Racing', 2024);
INSERT INTO Participa_temporada VALUES('Mercedes-AMG Petronas', 2025);
INSERT INTO Participa_temporada VALUES('Scuderia Ferrari', 2026);

END;
/

-- ALOCAÇÃO DOS ENGENHEIROS E MECÂNICOS (Pega as pessoas aleatórias geradas no arquivo 1)
DECLARE
    CURSOR c_staff IS SELECT credencial_FIA FROM Pessoa WHERE nome NOT IN ('Max Verstappen', 'Lewis Hamilton', 'Charles Leclerc', 'Lando Norris', 'Juan Manuel Correa', 'Fabiana Flosi', 'Niels Wittich', 'Christian Horner', 'Frederic Vasseur', 'Andrea Stella', 'Toto Wolff');
    v_cont NUMBER := 1;
BEGIN
    FOR p IN c_staff LOOP
        IF v_cont <= 4 THEN
            -- Transforma os 4 primeiros em Engenheiros
            INSERT INTO Funcionario_equipe VALUES(p.credencial_FIA, 'Scuderia Ferrari', 'ENG-'||seq_credencial_fia.NEXTVAL, 'Engenheiro', 'Engenharia');
            INSERT INTO Engenheiro VALUES(p.credencial_FIA, CASE v_cont WHEN 1 THEN 'Chassi' WHEN 2 THEN 'Motor' WHEN 3 THEN 'Aerofolio' ELSE 'Sistema Elétrico' END);
        ELSIF v_cont <= 8 THEN
            -- Transforma os 4 seguintes em Mecânicos
            INSERT INTO Funcionario_equipe VALUES(p.credencial_FIA, 'Scuderia Ferrari', 'MEC-'||seq_credencial_fia.NEXTVAL, 'Mecânico', 'Garagem');
            INSERT INTO Mecanico VALUES(p.credencial_FIA, CASE v_cont WHEN 5 THEN 'Gunners' WHEN 6 THEN 'Jack Men' WHEN 7 THEN 'Tire Off' ELSE 'Tire On' END, CASE v_cont WHEN 6 THEN 'Macaco Hidráulico' ELSE 'Pneus' END);
        END IF;
        v_cont := v_cont + 1;
    END LOOP;
    COMMIT;
END;
/