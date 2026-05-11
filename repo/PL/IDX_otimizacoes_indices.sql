-- Acelera todas as funções do PKG_GESTAO_EQUIPE
CREATE INDEX idx_func_equipe_nome ON Funcionario_equipe(nome_equipe_contratante);

-- Evita a leitura de disco inteiro na tabela mais pesada do sistema
CREATE INDEX idx_telemetria_piloto_gp ON Telemetria(credencial_FIA_piloto, nome_gp);

-- Otimiza a renovação de passaportes
CREATE INDEX idx_passaporte_validade ON Passaporte(data_validade);