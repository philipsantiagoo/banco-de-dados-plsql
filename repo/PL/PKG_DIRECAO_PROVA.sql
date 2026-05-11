CREATE OR REPLACE PACKAGE PKG_DIRECAO_PROVA AS
    -- Tipo para o Array em Memória (Collection) dos resultados do pódio
    TYPE rec_podio IS RECORD (
        posicao       NUMBER(2),
        nome_piloto   VARCHAR2(150),
        nome_equipe   VARCHAR2(50),
        tempo_final   INTERVAL DAY TO SECOND(3)
    );
    TYPE t_podio IS TABLE OF rec_podio INDEX BY BINARY_INTEGER;

    -- Procedimento para agendar sessões (Treinos, Quali, Corrida)
    PROCEDURE pr_agendar_sessao(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE,
        p_data_sessao IN Sessao.data_sessao%TYPE,
        p_horario     IN Sessao.horario%TYPE
    );

    -- Procedimento para registrar o resultado final de um piloto
    PROCEDURE pr_registrar_resultado_corrida(
        p_tipo_sessao         IN Participa_sessao.tipo_sessao%TYPE,
        p_nome_gp             IN Participa_sessao.nome_gp%TYPE,
        p_ano_gp              IN Participa_sessao.ano_gp%TYPE,
        p_credencial_piloto   IN Participa_sessao.credencial_FIA_piloto%TYPE,
        p_codigo_chassi       IN Participa_sessao.codigo_chassi%TYPE,
        p_nome_modelo         IN Participa_sessao.nome_modelo%TYPE,
        p_ano_projeto_modelo  IN Participa_sessao.ano_projeto_modelo%TYPE,
        p_posicao             IN Participa_sessao.posicao_final%TYPE,
        p_tempo               IN Participa_sessao.tempo_final%TYPE,
        p_pontos              IN Participa_sessao.pontos%TYPE,
        p_status              IN Participa_sessao.status_participacao%TYPE
    );

    -- Função que retorna o pódio (Top 3)
    FUNCTION fn_listar_podio(
        p_gp  IN Grande_premio.nome_gp%TYPE, 
        p_ano IN Grande_premio.ano_temporada%TYPE
    ) RETURN t_podio;

END PKG_DIRECAO_PROVA;
/



CREATE OR REPLACE PACKAGE BODY PKG_DIRECAO_PROVA AS

    PROCEDURE pr_agendar_sessao(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE,
        p_data_sessao IN Sessao.data_sessao%TYPE,
        p_horario     IN Sessao.horario%TYPE
    ) IS
        v_existe_gp NUMBER;
    BEGIN
        -- Valida se o Grande_premio existe
        SELECT 1 INTO v_existe_gp
        FROM Grande_premio
        WHERE nome_gp = p_nome_gp AND ano_temporada = p_ano_gp;

        -- Se chegou aqui, o Grande_premio existe, procede com o INSERT
        INSERT INTO Sessao (tipo_sessao, nome_gp, ano_gp, data_sessao, horario)
        VALUES (p_tipo_sessao, p_nome_gp, p_ano_gp, p_data_sessao, p_horario);
        
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004, 'Grande Prêmio não encontrado.');
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002, 'Erro: Esta sessão já está agendada para este GP.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'Erro ao agendar sessão: ' || SQLERRM);
    END pr_agendar_sessao;


    PROCEDURE pr_registrar_resultado_corrida(
        p_tipo_sessao         IN Participa_sessao.tipo_sessao%TYPE,
        p_nome_gp             IN Participa_sessao.nome_gp%TYPE,
        p_ano_gp              IN Participa_sessao.ano_gp%TYPE,
        p_credencial_piloto   IN Participa_sessao.credencial_FIA_piloto%TYPE,
        p_codigo_chassi       IN Participa_sessao.codigo_chassi%TYPE,
        p_nome_modelo         IN Participa_sessao.nome_modelo%TYPE,
        p_ano_projeto_modelo  IN Participa_sessao.ano_projeto_modelo%TYPE,
        p_posicao             IN Participa_sessao.posicao_final%TYPE,
        p_tempo               IN Participa_sessao.tempo_final%TYPE,
        p_pontos              IN Participa_sessao.pontos%TYPE,
        p_status              IN Participa_sessao.status_participacao%TYPE
    ) IS
        v_existe_chassi NUMBER;
        v_existe_sessao NUMBER;
    BEGIN
        -- Valida se o chassi existe
        SELECT 1 INTO v_existe_chassi
        FROM Chassi
        WHERE codigo_chassi = p_codigo_chassi
          AND nome_modelo = p_nome_modelo
          AND ano_projeto_modelo = p_ano_projeto_modelo;

        -- Valida se a sessão existe
        SELECT 1 INTO v_existe_sessao
        FROM Sessao
        WHERE tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp;

        -- Insere o registro de participação com os dados da sessão e resultado final
        INSERT INTO Participa_sessao (
            tipo_sessao, nome_gp, ano_gp, credencial_FIA_piloto,
            codigo_chassi, nome_modelo, ano_projeto_modelo,
            posicao_final, tempo_final, pontos, status_participacao
        ) VALUES (
            p_tipo_sessao, p_nome_gp, p_ano_gp, p_credencial_piloto,
            p_codigo_chassi, p_nome_modelo, p_ano_projeto_modelo,
            p_posicao, p_tempo, p_pontos, p_status
        );

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20005, 'Chassi ou sessão não encontrado para registro do resultado.');
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004, 'Erro: Este piloto já está registrado nesta sessão.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'Erro ao registrar resultado: ' || SQLERRM);
    END pr_registrar_resultado_corrida;


    FUNCTION fn_listar_podio(
        p_gp  IN Grande_premio.nome_gp%TYPE, 
        p_ano IN Grande_premio.ano_temporada%TYPE
    ) RETURN t_podio IS
        v_podio t_podio;
        v_idx   BINARY_INTEGER := 1;
        
        -- Cursor para buscar os 3 primeiros da "Corrida"
        -- Usa a relação estrutural garantida: Participa_sessao → Chassi → Modelo_carro
        CURSOR c_resultados IS
            SELECT ps.posicao_final, pes.nome, mc.nome_equipe_desenvolvedora, ps.tempo_final
            FROM Participa_sessao ps
            JOIN Pessoa pes ON ps.credencial_FIA_piloto = pes.credencial_FIA
            JOIN Chassi c ON ps.codigo_chassi = c.codigo_chassi 
                          AND ps.nome_modelo = c.nome_modelo 
                          AND ps.ano_projeto_modelo = c.ano_projeto_modelo
            JOIN Modelo_carro mc ON c.nome_modelo = mc.nome_modelo 
                                 AND c.ano_projeto_modelo = mc.ano_projeto
            WHERE ps.nome_gp = p_gp
              AND ps.ano_gp  = p_ano
              AND ps.tipo_sessao = 'Corrida'
              AND ps.posicao_final BETWEEN 1 AND 3
            ORDER BY ps.posicao_final ASC;
    BEGIN
        FOR r IN c_resultados LOOP
            v_podio(v_idx).posicao     := r.posicao_final;
            v_podio(v_idx).nome_piloto := r.nome;
            v_podio(v_idx).nome_equipe := r.nome_equipe_desenvolvedora;
            v_podio(v_idx).tempo_final := r.tempo_final;
            v_idx := v_idx + 1;
        END LOOP;

        RETURN v_podio;
    END fn_listar_podio;

END PKG_DIRECAO_PROVA;
/