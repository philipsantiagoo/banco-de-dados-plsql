-- ==========================================
-- ESPECIFICAÇÃO (HEADER)
-- PKG_TELEMETRIA_ANALISE
-- ==========================================

CREATE OR REPLACE PACKAGE PKG_TELEMETRIA_ANALISE AS

    -- ==========================================
    -- MELHOR VOLTA DA SESSÃO
    -- Retorna o menor tempo registrado
    -- ==========================================

    FUNCTION fn_melhor_volta_sessao(
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN INTERVAL DAY TO SECOND;



    -- ==========================================
    -- PILOTO DA MELHOR VOLTA
    -- Retorna o nome do piloto com a melhor volta
    -- ==========================================

    FUNCTION fn_piloto_melhor_volta(
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN Pessoa.nome%TYPE;



    -- ==========================================
    -- VELOCIDADE MÁXIMA DO PILOTO
    -- ==========================================

    FUNCTION fn_velocidade_maxima_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE,
        p_nome_gp IN Telemetria.nome_gp%TYPE
    ) RETURN Telemetria.velocidade%TYPE;



    -- ==========================================
    -- MÉDIA DE RPM DO PILOTO
    -- ==========================================

    FUNCTION fn_media_rpm_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- MÉDIA DE VELOCIDADE DO PILOTO
    -- ==========================================

    FUNCTION fn_media_velocidade_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- TOTAL DE VOLTAS DO PILOTO
    -- ==========================================

    FUNCTION fn_total_voltas_piloto(
        p_piloto IN Volta.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- PICO DE ACELERAÇÃO
    -- ==========================================

    FUNCTION fn_pico_aceleracao(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- MÉDIA DE DESGASTE DOS PNEUS
    -- ==========================================

    FUNCTION fn_media_desgaste_pneus(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- CONSISTÊNCIA DO PILOTO
    -- Mede a variação média dos tempos
    -- Quanto menor, mais consistente
    -- ==========================================

    FUNCTION fn_consistencia_piloto(
        p_piloto      IN Volta.credencial_FIA_piloto%TYPE,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- TOTAL DE AMOSTRAS DE TELEMETRIA
    -- ==========================================

    FUNCTION fn_total_amostras_telemetria(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER;



    -- ==========================================
    -- MELHOR SETOR DO PILOTO
    -- p_setor = 1, 2 ou 3
    -- ==========================================

    FUNCTION fn_melhor_setor(
        p_piloto      IN Volta.credencial_FIA_piloto%TYPE,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE,
        p_setor       IN NUMBER
    ) RETURN INTERVAL DAY TO SECOND;



    -- ==========================================
    -- LISTAR PILOTOS COM TEMPOS (LEFT OUTER JOIN)
    -- Retorna todos os pilotos com seus tempos de volta
    -- Inclui pilotos sem tempos registrados
    -- ==========================================

    TYPE rec_piloto_tempo IS RECORD (
        credencial_fia  Piloto.credencial_FIA_pessoa%TYPE,
        nome_piloto     Pessoa.nome%TYPE,
        nome_gp         Volta.nome_gp%TYPE,
        tipo_sessao     Volta.tipo_sessao%TYPE,
        tempo_volta     Volta.tempo_volta%TYPE
    );
    TYPE t_pilotos_tempos IS TABLE OF rec_piloto_tempo INDEX BY BINARY_INTEGER;

    FUNCTION fn_listar_pilotos_com_tempos(
        p_nome_gp     IN Volta.nome_gp%TYPE DEFAULT NULL,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE DEFAULT NULL
    ) RETURN t_pilotos_tempos;


    -- ==========================================
    -- CHECAR SUPERAÇÕES
    -- ==========================================
    TYPE t_tabela_telemetria IS TABLE OF Telemetria%ROWTYPE INDEX BY PLS_INTEGER;

    FUNCTION fn_vel_superou_algum_rival(p_piloto IN Telemetria.credencial_FIA_piloto%TYPE, p_equipe_alvo IN Equipe.nome_equipe%TYPE) RETURN t_tabela_telemetria;
    FUNCTION fn_vel_superou_todos_rivais(p_piloto IN Telemetria.credencial_FIA_piloto%TYPE, p_equipe_alvo IN Equipe.nome_equipe%TYPE) RETURN t_tabela_telemetria;

END PKG_TELEMETRIA_ANALISE;
/


-- ==========================================
-- CORPO (BODY)
-- PKG_TELEMETRIA_ANALISE
-- ==========================================

CREATE OR REPLACE PACKAGE BODY PKG_TELEMETRIA_ANALISE AS

    -- ==========================================
    -- MELHOR VOLTA DA SESSÃO
    -- ==========================================

    FUNCTION fn_melhor_volta_sessao(
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN INTERVAL DAY TO SECOND
    IS
        v_melhor_volta INTERVAL DAY TO SECOND;
    BEGIN

        IF NOT PKG_UTIL_VALIDACAO.fn_existe_sessao(
            p_tipo_sessao,
            p_nome_gp,
            p_ano_gp
        ) THEN
            RAISE_APPLICATION_ERROR(
                -20100,
                'Sessao nao encontrada.'
            );
        END IF;

        SELECT MIN(tempo_volta)
        INTO v_melhor_volta
        FROM Volta
        WHERE tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp;

        RETURN v_melhor_volta;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20101,
                'Erro ao calcular melhor volta: ' || SQLERRM
            );
    END fn_melhor_volta_sessao;



    -- ==========================================
    -- PILOTO DA MELHOR VOLTA
    -- ==========================================

    FUNCTION fn_piloto_melhor_volta(
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN Pessoa.nome%TYPE
    IS
        v_nome_piloto Pessoa.nome%TYPE;
    BEGIN

        SELECT P.nome
        INTO v_nome_piloto
        FROM Pessoa P
        INNER JOIN Piloto PI
            ON P.credencial_FIA = PI.credencial_FIA_pessoa
        INNER JOIN Volta V
            ON PI.credencial_FIA_pessoa = V.credencial_FIA_piloto
        WHERE V.tipo_sessao = p_tipo_sessao
          AND V.nome_gp = p_nome_gp
          AND V.ano_gp = p_ano_gp
          AND V.tempo_volta = (
                SELECT MIN(tempo_volta)
                FROM Volta
                WHERE tipo_sessao = p_tipo_sessao
                  AND nome_gp = p_nome_gp
                  AND ano_gp = p_ano_gp
          );

        RETURN v_nome_piloto;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20102,
                'Nenhuma volta encontrada.'
            );

        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(
                -20103,
                'Empate de melhor volta entre pilotos.'
            );

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20104,
                'Erro ao buscar piloto da melhor volta: ' || SQLERRM
            );
    END fn_piloto_melhor_volta;



    -- ==========================================
    -- VELOCIDADE MÁXIMA
    -- ==========================================

    FUNCTION fn_velocidade_maxima_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE,
        p_nome_gp IN Telemetria.nome_gp%TYPE
    ) RETURN Telemetria.velocidade%TYPE
    IS
        v_velocidade_maxima Telemetria.velocidade%TYPE;
    BEGIN

        IF NOT PKG_UTIL_VALIDACAO.fn_existe_piloto(p_piloto) THEN
            RAISE_APPLICATION_ERROR(
                -20105,
                'Piloto nao encontrado.'
            );
        END IF;

        SELECT MAX(velocidade)
        INTO v_velocidade_maxima
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto
          AND nome_gp = p_nome_gp;

        RETURN v_velocidade_maxima;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20106,
                'Erro ao calcular velocidade maxima: ' || SQLERRM
            );
    END fn_velocidade_maxima_piloto;



    -- ==========================================
    -- MÉDIA RPM
    -- ==========================================

    FUNCTION fn_media_rpm_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_media_rpm NUMBER;
    BEGIN

        SELECT AVG(rpm)
        INTO v_media_rpm
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN ROUND(v_media_rpm, 2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20107,
                'Erro ao calcular media de RPM: ' || SQLERRM
            );
    END fn_media_rpm_piloto;



    -- ==========================================
    -- MÉDIA VELOCIDADE
    -- ==========================================

    FUNCTION fn_media_velocidade_piloto(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_media_velocidade NUMBER;
    BEGIN

        SELECT AVG(velocidade)
        INTO v_media_velocidade
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN ROUND(v_media_velocidade, 2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20108,
                'Erro ao calcular media de velocidade: ' || SQLERRM
            );
    END fn_media_velocidade_piloto;



    -- ==========================================
    -- TOTAL DE VOLTAS
    -- ==========================================

    FUNCTION fn_total_voltas_piloto(
        p_piloto IN Volta.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_total_voltas NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_total_voltas
        FROM Volta
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN v_total_voltas;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20109,
                'Erro ao calcular total de voltas: ' || SQLERRM
            );
    END fn_total_voltas_piloto;



    -- ==========================================
    -- PICO DE ACELERAÇÃO
    -- ==========================================

    FUNCTION fn_pico_aceleracao(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_pico_aceleracao NUMBER;
    BEGIN

        SELECT MAX(aceleracao)
        INTO v_pico_aceleracao
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN v_pico_aceleracao;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20110,
                'Erro ao calcular pico de aceleracao: ' || SQLERRM
            );
    END fn_pico_aceleracao;



    -- ==========================================
    -- MÉDIA DESGASTE DOS PNEUS
    -- ==========================================

    FUNCTION fn_media_desgaste_pneus(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_media_desgaste NUMBER;
    BEGIN

        SELECT AVG(
            (temperatura_pneus * 0.7)
            +
            ((32 - pressao_pneus) * 0.3)
        )
        INTO v_media_desgaste
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN ROUND(v_media_desgaste, 2);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20111,
                'Erro ao calcular desgaste medio dos pneus: ' || SQLERRM
            );
    END fn_media_desgaste_pneus;



    -- ==========================================
    -- CONSISTÊNCIA DO PILOTO
    -- ==========================================

    FUNCTION fn_consistencia_piloto(
        p_piloto      IN Volta.credencial_FIA_piloto%TYPE,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE
    ) RETURN NUMBER
    IS
        v_consistencia NUMBER;
    BEGIN

        SELECT STDDEV(
            PKG_UTIL_VALIDACAO.fn_intervalo_para_segundos(tempo_volta)
        )
        INTO v_consistencia
        FROM Volta
        WHERE credencial_FIA_piloto = p_piloto
          AND tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp;

        RETURN ROUND(v_consistencia, 3);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20112,
                'Erro ao calcular consistencia do piloto: ' || SQLERRM
            );
    END fn_consistencia_piloto;



    -- ==========================================
    -- TOTAL DE AMOSTRAS DE TELEMETRIA
    -- ==========================================

    FUNCTION fn_total_amostras_telemetria(
        p_piloto IN Telemetria.credencial_FIA_piloto%TYPE
    ) RETURN NUMBER
    IS
        v_total_amostras NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_total_amostras
        FROM Telemetria
        WHERE credencial_FIA_piloto = p_piloto;

        RETURN v_total_amostras;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20113,
                'Erro ao calcular total de amostras: ' || SQLERRM
            );
    END fn_total_amostras_telemetria;



    -- ==========================================
    -- MELHOR SETOR
    -- ==========================================

    FUNCTION fn_melhor_setor(
        p_piloto      IN Volta.credencial_FIA_piloto%TYPE,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE,
        p_nome_gp     IN Volta.nome_gp%TYPE,
        p_ano_gp      IN Volta.ano_gp%TYPE,
        p_setor       IN NUMBER
    ) RETURN INTERVAL DAY TO SECOND
    IS
        v_melhor_setor INTERVAL DAY TO SECOND;
    BEGIN

        IF p_setor NOT IN (1, 2, 3) THEN
            RAISE_APPLICATION_ERROR(
                -20114,
                'Setor invalido. Utilize apenas 1, 2 ou 3.'
            );
        END IF;

        IF p_setor = 1 THEN

            SELECT MIN(setor1)
            INTO v_melhor_setor
            FROM Volta
            WHERE credencial_FIA_piloto = p_piloto
              AND tipo_sessao = p_tipo_sessao
              AND nome_gp = p_nome_gp
              AND ano_gp = p_ano_gp;

        ELSIF p_setor = 2 THEN

            SELECT MIN(setor2)
            INTO v_melhor_setor
            FROM Volta
            WHERE credencial_FIA_piloto = p_piloto
              AND tipo_sessao = p_tipo_sessao
              AND nome_gp = p_nome_gp
              AND ano_gp = p_ano_gp;

        ELSE

            SELECT MIN(setor3)
            INTO v_melhor_setor
            FROM Volta
            WHERE credencial_FIA_piloto = p_piloto
              AND tipo_sessao = p_tipo_sessao
              AND nome_gp = p_nome_gp
              AND ano_gp = p_ano_gp;

        END IF;

        RETURN v_melhor_setor;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20115,
                'Erro ao calcular melhor setor: ' || SQLERRM
            );
    END fn_melhor_setor;



    -- ==========================================
    -- LISTAR PILOTOS COM TEMPOS (LEFT OUTER JOIN)
    -- ==========================================

    FUNCTION fn_listar_pilotos_com_tempos(
        p_nome_gp     IN Volta.nome_gp%TYPE DEFAULT NULL,
        p_tipo_sessao IN Volta.tipo_sessao%TYPE DEFAULT NULL
    ) RETURN t_pilotos_tempos
    IS
        v_resultado t_pilotos_tempos;
        v_idx       BINARY_INTEGER := 1;
    BEGIN
        -- LEFT OUTER JOIN: Todos os pilotos aparecem, mesmo aqueles sem tempos
        FOR r IN (
            SELECT 
                pi.credencial_FIA_pessoa,
                pes.nome,
                v.nome_gp,
                v.tipo_sessao,
                v.tempo_volta
            FROM Piloto pi
            LEFT OUTER JOIN Pessoa pes 
                ON pi.credencial_FIA_pessoa = pes.credencial_FIA
            LEFT OUTER JOIN Volta v 
                ON pi.credencial_FIA_pessoa = v.credencial_FIA_piloto
                AND (p_nome_gp IS NULL OR v.nome_gp = p_nome_gp)
                AND (p_tipo_sessao IS NULL OR v.tipo_sessao = p_tipo_sessao)
            ORDER BY pes.nome, v.nome_gp, v.tipo_sessao
        ) LOOP
            v_resultado(v_idx).credencial_fia  := r.credencial_FIA_pessoa;
            v_resultado(v_idx).nome_piloto     := r.nome;
            v_resultado(v_idx).nome_gp         := r.nome_gp;
            v_resultado(v_idx).tipo_sessao     := r.tipo_sessao;
            v_resultado(v_idx).tempo_volta     := r.tempo_volta;
            v_idx := v_idx + 1;
        END LOOP;

        RETURN v_resultado;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20116,
                'Erro ao listar pilotos com tempos: ' || SQLERRM
            );
    END fn_listar_pilotos_com_tempos;


    -- ==========================================
    -- CHECAR SUPERAÇÕES
    -- ==========================================
    FUNCTION fn_vel_superou_algum_rival(p_piloto IN Telemetria.credencial_FIA_piloto%TYPE, p_equipe_alvo IN Equipe.nome_equipe%TYPE) RETURN t_tabela_telemetria IS
        v_tabela t_tabela_telemetria;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r IN (
            SELECT * FROM Telemetria
            WHERE credencial_FIA_piloto = p_piloto
              AND velocidade > ANY (
                  SELECT t.velocidade
                  FROM Telemetria t
                  INNER JOIN Participa_sessao ps ON t.credencial_FIA_piloto = ps.credencial_FIA_piloto
                  INNER JOIN Chassi c ON ps.codigo_chassi = c.codigo_chassi
                  INNER JOIN Modelo_carro mc ON c.nome_modelo = mc.nome_modelo
                  WHERE mc.nome_equipe_desenvolvedora = p_equipe_alvo
              )
        ) LOOP
            v_tabela(v_idx) := r;
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_vel_superou_algum_rival;


    FUNCTION fn_vel_superou_todos_rivais(p_piloto IN Telemetria.credencial_FIA_piloto%TYPE, p_equipe_alvo IN Equipe.nome_equipe%TYPE) RETURN t_tabela_telemetria IS
        v_tabela t_tabela_telemetria;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r IN (
            SELECT * FROM Telemetria
            WHERE credencial_FIA_piloto = p_piloto
              AND velocidade > ALL (
                  SELECT t.velocidade
                  FROM Telemetria t
                  INNER JOIN Participa_sessao ps ON t.credencial_FIA_piloto = ps.credencial_FIA_piloto
                  INNER JOIN Chassi c ON ps.codigo_chassi = c.codigo_chassi
                  INNER JOIN Modelo_carro mc ON c.nome_modelo = mc.nome_modelo
                  WHERE mc.nome_equipe_desenvolvedora = p_equipe_alvo
              )
        ) LOOP
            v_tabela(v_idx) := r;
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_vel_superou_todos_rivais;

END PKG_TELEMETRIA_ANALISE;
/