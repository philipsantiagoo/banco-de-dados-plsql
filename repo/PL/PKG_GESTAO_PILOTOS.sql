CREATE OR REPLACE PACKAGE PKG_GESTAO_PILOTOS AS

    PROCEDURE pr_registrar_piloto(
    p_credencial IN Piloto.credencial_FIA_pessoa%TYPE,
    p_superlicenca IN Piloto.superlicenca%TYPE,
    p_nome IN Pessoa.nome%TYPE,
    p_data IN Pessoa.data_nascimento%TYPE);

    PROCEDURE pr_registrar_substituicao(
    p_piloto_oficial  IN Piloto.credencial_FIA_pessoa%TYPE,
    p_piloto_reserva  IN Piloto.credencial_FIA_pessoa%TYPE,
    p_sessao          IN Sessao.tipo_sessao%TYPE,
    p_gp              IN Grande_premio.nome_gp%TYPE,
    p_ano_gp          IN Grande_premio.ano_temporada%TYPE);

    FUNCTION fn_pontuacao_campeonato(
    p_piloto IN Piloto.credencial_FIA_pessoa%TYPE,
    p_ano    IN Temporada.ano%TYPE) RETURN NUMBER;
END PKG_GESTAO_PILOTOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_GESTAO_PILOTOS AS
    -----------Registra o piloto------------
    PROCEDURE pr_registrar_piloto(
        p_credencial   IN Piloto.credencial_FIA_pessoa%TYPE,
        p_superlicenca IN Piloto.superlicenca%TYPE,
        p_nome IN Pessoa.nome%TYPE,
        p_data IN Pessoa.data_nascimento%TYPE
    )
    IS
        v_existe NUMBER;
    BEGIN

        -- Verifica se a pessoa existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Pessoa
        WHERE credencial_FIA = p_credencial;

        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20010,
                'Pessoa não encontrada.'
            );
        END IF;

        -- Verifica se a superlicença já existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Piloto
        WHERE superlicenca = p_superlicenca;

        IF v_existe > 0 THEN
            RAISE_APPLICATION_ERROR(
                -20011,
                'Superlicença já cadastrada.'
            );
        END IF;

        -- Insere em Pessoa
        INSERT INTO Pessoa(
            credencial_FIA,
            nome,
            data_nascimento
        )
        VALUES(
            p_credencial,
            p_nome,
            p_data
        );

        -- Insere piloto
        INSERT INTO Piloto(
            credencial_FIA_pessoa,
            superlicenca
        )
        VALUES(
            p_credencial,
            p_superlicenca
        );

        DBMS_OUTPUT.PUT_LINE('Piloto registrado com sucesso.');

    EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE(
                'Erro: superlicença duplicada.'
            );

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(
                'Erro: ' || SQLERRM
            );
    END;

    ------------------registra substituição de pilotos---------------
    PROCEDURE pr_registrar_substituicao(
        p_piloto_oficial  IN Piloto.credencial_FIA_pessoa%TYPE,
        p_piloto_reserva  IN Piloto.credencial_FIA_pessoa%TYPE,
        p_sessao          IN Sessao.tipo_sessao%TYPE,
        p_gp              IN Grande_premio.nome_gp%TYPE,
        p_ano_gp          IN Grande_premio.ano_temporada%TYPE
    )
    IS
        v_existe          NUMBER;
    BEGIN

        -- Verifica se o piloto oficial existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Piloto
        WHERE credencial_FIA_pessoa = p_piloto_oficial;

        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20020,
                'Piloto oficial não encontrado.'
            );
        END IF;

        -- Verifica se o piloto reserva existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Piloto
        WHERE credencial_FIA_pessoa = p_piloto_reserva;

        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20021,
                'Piloto reserva não encontrado.'
            );
        END IF;

        -- Impede substituição do mesmo piloto
        IF p_piloto_oficial = p_piloto_reserva THEN
            RAISE_APPLICATION_ERROR(
                -20022,
                'Um piloto não pode substituir a si mesmo.'
            );
        END IF;

        -- Verifica se a sessão existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Sessao
        WHERE tipo_sessao = p_sessao
        AND nome_gp = p_gp
        AND ano_gp = p_ano_gp;

        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20023,
                'Sessão não encontrada.'
            );
        END IF;

        -- Registra substituição
        INSERT INTO Substitui(
            tipo_sessao,
            nome_gp,
            ano_gp,
            credencial_FIA_piloto_substituido,
            credencial_FIA_piloto_substituto
        )
        VALUES(
            p_sessao,
            p_gp,
            p_ano_gp,
            p_piloto_oficial,
            p_piloto_reserva
        );

        DBMS_OUTPUT.PUT_LINE(
            'Substituição registrada com sucesso.'
        );

    EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE(
                'Já existe uma substituição cadastrada.'
            );

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(
                'Erro: ' || SQLERRM
            );

    END;

    --------------soma os pontos das sessões de um ano--------------------
    FUNCTION fn_pontuacao_campeonato(
        p_piloto IN Piloto.credencial_FIA_pessoa%TYPE,
        p_ano    IN Temporada.ano%TYPE
    )
    RETURN NUMBER
    IS
        v_total_pontos NUMBER(6,1);
        v_existe       NUMBER;
    BEGIN

        -- Verifica se o piloto existe
        SELECT COUNT(*)
        INTO v_existe
        FROM Piloto
        WHERE credencial_FIA_pessoa = p_piloto;

        IF v_existe = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20030,
                'Piloto não encontrado.'
            );
        END IF;

        -- Soma dos pontos no campeonato
        SELECT NVL(SUM(pontos), 0)
        INTO v_total_pontos
        FROM Participa_sessao
        WHERE credencial_FIA_piloto = p_piloto
        AND ano_gp = p_ano;

        RETURN v_total_pontos;

    EXCEPTION

        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(
                'Erro: ' || SQLERRM
            );

            RETURN 0;

    END;

END PKG_GESTAO_PILOTOS;
/