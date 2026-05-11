-- ==========================================
-- ESPECIFICAÇÃO (HEADER)
-- PKG_UTIL_VALIDACAO
-- ==========================================

CREATE OR REPLACE PACKAGE PKG_UTIL_VALIDACAO AS

    -- ==========================================
    -- FUNÇÕES DE EXISTÊNCIA
    -- ==========================================

    FUNCTION fn_existe_piloto(
        p_credencial_piloto IN Piloto.credencial_FIA_pessoa%TYPE
    ) RETURN BOOLEAN;

    FUNCTION fn_existe_sessao(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE
    ) RETURN BOOLEAN;

    FUNCTION fn_existe_gp(
        p_nome_gp IN Grande_premio.nome_gp%TYPE,
        p_ano_gp  IN Grande_premio.ano_temporada%TYPE
    ) RETURN BOOLEAN;

    FUNCTION fn_existe_equipe(
        p_nome_equipe IN Equipe.nome_equipe%TYPE
    ) RETURN BOOLEAN;

    FUNCTION fn_existe_chassi(
        p_codigo_chassi      IN Chassi.codigo_chassi%TYPE,
        p_nome_modelo        IN Chassi.nome_modelo%TYPE,
        p_ano_projeto_modelo IN Chassi.ano_projeto_modelo%TYPE
    ) RETURN BOOLEAN;

    FUNCTION fn_existe_participacao(
        p_tipo_sessao IN Participa_sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Participa_sessao.nome_gp%TYPE,
        p_ano_gp      IN Participa_sessao.ano_gp%TYPE,
        p_piloto      IN Participa_sessao.credencial_FIA_piloto%TYPE
    ) RETURN BOOLEAN;

    -- ==========================================
    -- FUNÇÕES DE VALIDAÇÃO
    -- ==========================================

    FUNCTION fn_datas_validas(
        p_data_inicio IN DATE,
        p_data_fim    IN DATE
    ) RETURN BOOLEAN;

    FUNCTION fn_sessao_encerrada(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE
    ) RETURN BOOLEAN;

    -- ==========================================
    -- FUNÇÕES UTILITÁRIAS DE CONSULTA
    -- ==========================================

    FUNCTION fn_nome_piloto(
        p_credencial_piloto IN Piloto.credencial_FIA_pessoa%TYPE
    ) RETURN Pessoa.nome%TYPE;

    FUNCTION fn_nome_equipe_chassi(
        p_codigo_chassi      IN Chassi.codigo_chassi%TYPE,
        p_nome_modelo        IN Chassi.nome_modelo%TYPE,
        p_ano_projeto_modelo IN Chassi.ano_projeto_modelo%TYPE
    ) RETURN Equipe.nome_equipe%TYPE;

    -- ==========================================
    -- FUNÇÕES UTILITÁRIAS DE TEMPO
    -- ==========================================

    FUNCTION fn_intervalo_para_segundos(
        p_intervalo IN INTERVAL DAY TO SECOND
    ) RETURN NUMBER;

END PKG_UTIL_VALIDACAO;
/


-- ==========================================
-- CORPO (BODY)
-- PKG_UTIL_VALIDACAO
-- ==========================================

CREATE OR REPLACE PACKAGE BODY PKG_UTIL_VALIDACAO AS

    -- ==========================================
    -- FUNÇÃO: Verifica existência de piloto
    -- ==========================================

    FUNCTION fn_existe_piloto(
        p_credencial_piloto IN Piloto.credencial_FIA_pessoa%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Piloto
        WHERE credencial_FIA_pessoa = p_credencial_piloto;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Erro ao verificar existencia do piloto: ' || SQLERRM
            );
    END fn_existe_piloto;



    -- ==========================================
    -- FUNÇÃO: Verifica existência de sessão
    -- ==========================================

    FUNCTION fn_existe_sessao(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Sessao
        WHERE tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20002,
                'Erro ao verificar existencia da sessao: ' || SQLERRM
            );
    END fn_existe_sessao;



    -- ==========================================
    -- FUNÇÃO: Verifica existência de GP
    -- ==========================================

    FUNCTION fn_existe_gp(
        p_nome_gp IN Grande_premio.nome_gp%TYPE,
        p_ano_gp  IN Grande_premio.ano_temporada%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Grande_premio
        WHERE nome_gp = p_nome_gp
          AND ano_temporada = p_ano_gp;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20003,
                'Erro ao verificar existencia do GP: ' || SQLERRM
            );
    END fn_existe_gp;



    -- ==========================================
    -- FUNÇÃO: Verifica existência de equipe
    -- ==========================================

    FUNCTION fn_existe_equipe(
        p_nome_equipe IN Equipe.nome_equipe%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Equipe
        WHERE nome_equipe = p_nome_equipe;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20004,
                'Erro ao verificar existencia da equipe: ' || SQLERRM
            );
    END fn_existe_equipe;



    -- ==========================================
    -- FUNÇÃO: Verifica existência de chassi
    -- ==========================================

    FUNCTION fn_existe_chassi(
        p_codigo_chassi      IN Chassi.codigo_chassi%TYPE,
        p_nome_modelo        IN Chassi.nome_modelo%TYPE,
        p_ano_projeto_modelo IN Chassi.ano_projeto_modelo%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Chassi
        WHERE codigo_chassi = p_codigo_chassi
          AND nome_modelo = p_nome_modelo
          AND ano_projeto_modelo = p_ano_projeto_modelo;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20005,
                'Erro ao verificar existencia do chassi: ' || SQLERRM
            );
    END fn_existe_chassi;



    -- ==========================================
    -- FUNÇÃO: Verifica existência de participação
    -- ==========================================

    FUNCTION fn_existe_participacao(
        p_tipo_sessao IN Participa_sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Participa_sessao.nome_gp%TYPE,
        p_ano_gp      IN Participa_sessao.ano_gp%TYPE,
        p_piloto      IN Participa_sessao.credencial_FIA_piloto%TYPE
    ) RETURN BOOLEAN
    IS
        v_quantidade NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_quantidade
        FROM Participa_sessao
        WHERE tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp
          AND credencial_FIA_piloto = p_piloto;

        RETURN v_quantidade > 0;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20006,
                'Erro ao verificar existencia da participacao: ' || SQLERRM
            );
    END fn_existe_participacao;



    -- ==========================================
    -- FUNÇÃO: Validação de datas
    -- ==========================================

    FUNCTION fn_datas_validas(
        p_data_inicio IN DATE,
        p_data_fim    IN DATE
    ) RETURN BOOLEAN
    IS
    BEGIN

        IF p_data_fim IS NULL THEN
            RETURN TRUE;
        END IF;

        RETURN p_data_fim >= p_data_inicio;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20007,
                'Erro ao validar datas: ' || SQLERRM
            );
    END fn_datas_validas;



    -- ==========================================
    -- FUNÇÃO: Verifica se sessão já ocorreu
    -- ==========================================

    FUNCTION fn_sessao_encerrada(
        p_tipo_sessao IN Sessao.tipo_sessao%TYPE,
        p_nome_gp     IN Sessao.nome_gp%TYPE,
        p_ano_gp      IN Sessao.ano_gp%TYPE
    ) RETURN BOOLEAN
    IS
        v_data_sessao Sessao.data_sessao%TYPE;
    BEGIN

        SELECT data_sessao
        INTO v_data_sessao
        FROM Sessao
        WHERE tipo_sessao = p_tipo_sessao
          AND nome_gp = p_nome_gp
          AND ano_gp = p_ano_gp;

        RETURN v_data_sessao < SYSDATE;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20008,
                'Sessao nao encontrada.'
            );

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20009,
                'Erro ao verificar encerramento da sessao: ' || SQLERRM
            );
    END fn_sessao_encerrada;



    -- ==========================================
    -- FUNÇÃO: Retorna nome do piloto
    -- ==========================================

    FUNCTION fn_nome_piloto(
        p_credencial_piloto IN Piloto.credencial_FIA_pessoa%TYPE
    ) RETURN Pessoa.nome%TYPE
    IS
        v_nome Pessoa.nome%TYPE;
    BEGIN

        SELECT P.nome
        INTO v_nome
        FROM Pessoa P
        INNER JOIN Piloto PI
            ON P.credencial_FIA = PI.credencial_FIA_pessoa
        WHERE PI.credencial_FIA_pessoa = p_credencial_piloto;

        RETURN v_nome;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20010,
                'Piloto nao encontrado.'
            );

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20011,
                'Erro ao buscar nome do piloto: ' || SQLERRM
            );
    END fn_nome_piloto;



    -- ==========================================
    -- FUNÇÃO: Retorna equipe responsável pelo chassi
    -- ==========================================

    FUNCTION fn_nome_equipe_chassi(
        p_codigo_chassi      IN Chassi.codigo_chassi%TYPE,
        p_nome_modelo        IN Chassi.nome_modelo%TYPE,
        p_ano_projeto_modelo IN Chassi.ano_projeto_modelo%TYPE
    ) RETURN Equipe.nome_equipe%TYPE
    IS
        v_nome_equipe Equipe.nome_equipe%TYPE;
    BEGIN

        SELECT MC.nome_equipe_desenvolvedora
        INTO v_nome_equipe
        FROM Chassi C
        INNER JOIN Modelo_carro MC
            ON C.nome_modelo = MC.nome_modelo
           AND C.ano_projeto_modelo = MC.ano_projeto
        WHERE C.codigo_chassi = p_codigo_chassi
          AND C.nome_modelo = p_nome_modelo
          AND C.ano_projeto_modelo = p_ano_projeto_modelo;

        RETURN v_nome_equipe;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(
                -20012,
                'Chassi nao encontrado.'
            );

        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20013,
                'Erro ao buscar equipe do chassi: ' || SQLERRM
            );
    END fn_nome_equipe_chassi;



    -- ==========================================
    -- FUNÇÃO: Converte INTERVAL para segundos
    -- ==========================================

    FUNCTION fn_intervalo_para_segundos(
        p_intervalo IN INTERVAL DAY TO SECOND
    ) RETURN NUMBER
    IS
        v_total_segundos NUMBER;
    BEGIN

        v_total_segundos :=
              EXTRACT(DAY FROM p_intervalo) * 86400
            + EXTRACT(HOUR FROM p_intervalo) * 3600
            + EXTRACT(MINUTE FROM p_intervalo) * 60
            + EXTRACT(SECOND FROM p_intervalo);

        RETURN v_total_segundos;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(
                -20014,
                'Erro ao converter intervalo para segundos: ' || SQLERRM
            );
    END fn_intervalo_para_segundos;

END PKG_UTIL_VALIDACAO;
/