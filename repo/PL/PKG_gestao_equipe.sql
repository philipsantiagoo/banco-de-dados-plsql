-- ==========================================
-- ESPECIFICAÇÃO: PACKAGE "PKG_GESTAO_EQUIPE"
-- ==========================================
CREATE OR REPLACE PACKAGE PKG_GESTAO_EQUIPE AS
    ---------------------------------------------------------
    -- SEÇÃO 0: TIPOS ESPECIAIS (Público)
    ---------------------------------------------------------

    TYPE tipo_tabela_funcionarios IS TABLE OF Funcionario_equipe%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE tipo_tabela_engenheiros  IS TABLE OF Engenheiro%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE tipo_tabela_mecanicos    IS TABLE OF Mecanico%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE tipo_tabela_chefes       IS TABLE OF Chefe%ROWTYPE INDEX BY PLS_INTEGER;

    ---------------------------------------------------------
    -- SEÇÃO 1: REGRAS DE NEGÓCIO E VALIDAÇÕES (Públicas)
    ---------------------------------------------------------
    
    -- Valida se a equipe já possui um Chefe
    FUNCTION fn_equipe_tem_chefe(
        p_credencial_fia IN Funcionario_equipe.credencial_FIA_pessoa%TYPE
    ) RETURN BOOLEAN;

    -- Valida a especialização disjunta (Usável por Triggers externos se necessário)
    PROCEDURE pr_validar_disjuncao(
        p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE
    );


    ---------------------------------------------------------
    -- SEÇÃO 2: CONTRATAÇÃO E ALOCAÇÃO DE STAFF
    ---------------------------------------------------------

    -- Contratar um novo funcionário geral
    PROCEDURE pr_contratar_staff(
        p_credencial_fia IN Funcionario_equipe.credencial_FIA_pessoa%TYPE,
        p_equipe         IN Funcionario_equipe.nome_equipe_contratante%TYPE,
        p_licenca        IN Funcionario_equipe.licenca_staff%TYPE,
        p_funcao         IN Funcionario_equipe.funcao_equipe%TYPE DEFAULT 'A Definir',
        p_depto          IN Funcionario_equipe.departamento%TYPE DEFAULT NULL
    );

    -- Especializar um funcionário existente em Engenheiro
    PROCEDURE pr_alocar_engenheiro(
        p_credencial_fia IN Engenheiro.credencial_FIA_funcionario%TYPE,
        p_especialidade  IN Engenheiro.especialidade%TYPE DEFAULT NULL
    );

    -- Especializar um funcionário existente em Mecânico
    PROCEDURE pr_alocar_mecanico(
        p_credencial_fia IN Mecanico.credencial_FIA_funcionario%TYPE,
        p_posicao        IN Mecanico.posicao_pit_stop%TYPE DEFAULT NULL,
        p_especialidade  IN Mecanico.especialidade%TYPE DEFAULT NULL
    );

    -- Especializar um funcionário existente em Chefe
    PROCEDURE pr_alocar_chefe(
        p_credencial_fia IN Chefe.credencial_FIA_funcionario%TYPE,
        p_data           IN Chefe.data_assuncao_equipe%TYPE DEFAULT SYSDATE,
        p_cargo_chefe    IN Chefe.cargo_chefe%TYPE
    );


    ---------------------------------------------------------
    -- SEÇÃO 3: MOVIMENTAÇÃO E DESLIGAMENTO
    ---------------------------------------------------------

    -- Transfere um funcionario de uma equipe para outra
    PROCEDURE pr_transferir_funcionario(
        p_credencial  IN Funcionario_equipe.credencial_FIA_pessoa%TYPE, 
        p_nova_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE    
    );

    -- Desliga (remove) funcionario 
    PROCEDURE pr_desligar_funcionario(
        p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE
    );

    -- Atualiza o departamento de um funcionario 
    PROCEDURE pr_mudar_departamento_funcionario(
        p_credencial        IN Funcionario_equipe.credencial_FIA_pessoa%TYPE,
        p_novo_departamento IN Funcionario_equipe.departamento%TYPE
    );

    -- Muda chefe de uma equipe
    PROCEDURE pr_mudar_chefe(
        p_credencial_fia IN Chefe.credencial_FIA_funcionario%TYPE,
        p_data           IN Chefe.data_assuncao_equipe%TYPE DEFAULT SYSDATE,
        p_cargo_chefe    IN Chefe.cargo_chefe%TYPE
    );


    ---------------------------------------------------------
    -- SEÇÃO 4: CONSULTAS E RELATÓRIOS (Funções)
    ---------------------------------------------------------
    
    FUNCTION fn_numero_total_staff(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER;
    FUNCTION fn_numero_total_engenheiros(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER;
    FUNCTION fn_numero_total_mecanicos(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER;

    FUNCTION fn_listar_funcionarios(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_funcionarios;
    FUNCTION fn_listar_engenheiros(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_engenheiros;
    FUNCTION fn_listar_mecanicos(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_mecanicos;
    FUNCTION fn_listar_chefes(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_chefes;


    ---------------------------------------------------------
    -- LISTAR EQUIPES COM FUNCIONÁRIOS (RIGHT OUTER JOIN)
    -- Retorna todas as equipes com seus funcionários
    -- Inclui equipes sem funcionários atribuídos
    -- Prioridade: Alta
    ---------------------------------------------------------

    TYPE rec_equipe_funcionario IS RECORD (
        nome_equipe         Funcionario_equipe.nome_equipe_contratante%TYPE,
        credencial_fia      Funcionario_equipe.credencial_FIA_pessoa%TYPE,
        nome_funcionario    Pessoa.nome%TYPE,
        funcao              Funcionario_equipe.funcao_equipe%TYPE,
        departamento        Funcionario_equipe.departamento%TYPE
    );
    TYPE t_equipes_funcionarios IS TABLE OF rec_equipe_funcionario INDEX BY BINARY_INTEGER;

    FUNCTION fn_listar_equipes_com_funcionarios(
        p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL
    ) RETURN t_equipes_funcionarios;

END PKG_GESTAO_EQUIPE;
/




-- ==========================================
-- CORPO: PACKAGE "PKG_GESTAO_EQUIPE"
-- ==========================================
CREATE OR REPLACE PACKAGE BODY PKG_GESTAO_EQUIPE AS

    ---------------------------------------------------------
    -- SEÇÃO 1: REGRAS DE NEGÓCIO E VALIDAÇÕES
    ---------------------------------------------------------
    
    FUNCTION fn_equipe_tem_chefe(p_credencial_fia IN Funcionario_equipe.credencial_FIA_pessoa%TYPE) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM Chefe ch 
        INNER JOIN Funcionario_equipe fun ON ch.credencial_FIA_funcionario = fun.credencial_FIA_pessoa
        WHERE fun.nome_equipe_contratante = (
            SELECT nome_equipe_contratante FROM Funcionario_equipe WHERE credencial_FIA_pessoa = p_credencial_fia
        );
        RETURN v_count > 0;
    END fn_equipe_tem_chefe;


    PROCEDURE pr_validar_disjuncao(p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE) IS
        v_check NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_check FROM (
            SELECT credencial_FIA_funcionario FROM Mecanico WHERE credencial_FIA_funcionario = p_credencial
            UNION ALL
            SELECT credencial_FIA_funcionario FROM Engenheiro WHERE credencial_FIA_funcionario = p_credencial
            UNION ALL
            SELECT credencial_FIA_funcionario FROM Chefe WHERE credencial_FIA_funcionario = p_credencial
        );

        IF v_check > 0 THEN
            RAISE_APPLICATION_ERROR(-20100, 'Violação de Especialização Disjunta: Funcionário já possui um cargo específico.');
        END IF; 
    END pr_validar_disjuncao;


    ---------------------------------------------------------
    -- SEÇÃO 2: CONTRATAÇÃO E ALOCAÇÃO DE STAFF
    ---------------------------------------------------------

    PROCEDURE pr_contratar_staff(
        p_credencial_fia IN Funcionario_equipe.credencial_FIA_pessoa%TYPE,
        p_equipe         IN Funcionario_equipe.nome_equipe_contratante%TYPE,
        p_licenca        IN Funcionario_equipe.licenca_staff%TYPE,
        p_funcao         IN Funcionario_equipe.funcao_equipe%TYPE DEFAULT 'A Definir',
        p_depto          IN Funcionario_equipe.departamento%TYPE DEFAULT NULL
    ) IS
        e_fk_nao_encontrada EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_nao_encontrada, -2291);
    BEGIN
        INSERT INTO Funcionario_equipe (credencial_FIA_pessoa, nome_equipe_contratante, licenca_staff, funcao_equipe, departamento) 
        VALUES (p_credencial_fia, p_equipe, p_licenca, p_funcao, p_depto);
        COMMIT;
    EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20001, 'Erro: Licença staff ou funcionário já cadastrado.');
        WHEN e_fk_nao_encontrada THEN RAISE_APPLICATION_ERROR(-20002, 'Erro: Impossível alocar. Credencial não pertence a uma pessoa.');
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20003, 'Erro inesperado: ' || SQLERRM);
    END pr_contratar_staff;


    PROCEDURE pr_alocar_engenheiro(p_credencial_fia IN Engenheiro.credencial_FIA_funcionario%TYPE, p_especialidade IN Engenheiro.especialidade%TYPE DEFAULT NULL) IS
        e_fk_nao_encontrada EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_nao_encontrada, -2291);
    BEGIN
        pr_validar_disjuncao(p_credencial_fia);
        INSERT INTO Engenheiro (credencial_FIA_funcionario, especialidade) VALUES (p_credencial_fia, p_especialidade);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20004, 'Erro: Funcionário já é engenheiro.');
        WHEN e_fk_nao_encontrada THEN RAISE_APPLICATION_ERROR(-20005, 'Erro: Credencial não pertence a um funcionário de equipe.');
    END pr_alocar_engenheiro;


    PROCEDURE pr_alocar_mecanico(p_credencial_fia IN Mecanico.credencial_FIA_funcionario%TYPE, p_posicao IN Mecanico.posicao_pit_stop%TYPE DEFAULT NULL, p_especialidade IN Mecanico.especialidade%TYPE DEFAULT NULL) IS
        e_fk_nao_encontrada EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_nao_encontrada, -2291);
    BEGIN
        pr_validar_disjuncao(p_credencial_fia);
        INSERT INTO Mecanico (credencial_fia_funcionario, posicao_pit_stop, especialidade) VALUES (p_credencial_fia, p_posicao, p_especialidade);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20007, 'Erro: Funcionário já é mecânico.');
        WHEN e_fk_nao_encontrada THEN RAISE_APPLICATION_ERROR(-20008, 'Erro: Credencial não pertence a um funcionário de equipe.');
    END pr_alocar_mecanico;


    PROCEDURE pr_alocar_chefe(p_credencial_fia IN Chefe.credencial_FIA_funcionario%TYPE, p_data IN Chefe.data_assuncao_equipe%TYPE DEFAULT SYSDATE, p_cargo_chefe IN Chefe.cargo_chefe%TYPE) IS
        e_fk_nao_encontrada EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_nao_encontrada, -2291);
    BEGIN 
        pr_validar_disjuncao(p_credencial_fia);
        INSERT INTO Chefe (credencial_FIA_funcionario, data_assuncao_equipe, cargo_chefe) VALUES (p_credencial_fia, p_data, p_cargo_chefe);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20010, 'Erro: Funcionário já é chefe.');
        WHEN e_fk_nao_encontrada THEN RAISE_APPLICATION_ERROR(-20011, 'Erro: Credencial não pertence a um funcionário de equipe.');
    END pr_alocar_chefe;


    ---------------------------------------------------------
    -- SEÇÃO 3: MOVIMENTAÇÃO E DESLIGAMENTO
    ---------------------------------------------------------

    PROCEDURE pr_transferir_funcionario(p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE, p_nova_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) IS
    BEGIN
        UPDATE Funcionario_equipe SET nome_equipe_contratante = p_nova_equipe WHERE credencial_FIA_pessoa = p_credencial;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20013, 'Erro inesperado ao transferir funcionario: ' || SQLERRM);
    END pr_transferir_funcionario;


    PROCEDURE pr_desligar_funcionario(p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE) IS
        v_chefe NUMBER;
    BEGIN        
        SELECT COUNT(*) INTO v_chefe FROM Chefe WHERE credencial_FIA_funcionario = p_credencial;

        IF v_chefe > 0 THEN
            RAISE_APPLICATION_ERROR(-20015, 'Funcionário Chefe não pode ser deletado diretamente. Substitua-o primeiro.');
        ELSE
            -- Deleta os filhos primeiro para não violar chaves estrangeiras
            DELETE FROM Engenheiro WHERE credencial_FIA_funcionario = p_credencial;
            DELETE FROM Mecanico   WHERE credencial_FIA_funcionario = p_credencial;
            DELETE FROM Funcionario_equipe WHERE credencial_FIA_pessoa = p_credencial;
            COMMIT;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20016, 'Erro inesperado ao deletar funcionário: ' || SQLERRM);
    END pr_desligar_funcionario;


    PROCEDURE pr_mudar_chefe(p_credencial_fia IN Chefe.credencial_FIA_funcionario%TYPE, p_data IN Chefe.data_assuncao_equipe%TYPE DEFAULT SYSDATE, p_cargo_chefe IN Chefe.cargo_chefe%TYPE) IS
        v_equipe_nova Funcionario_equipe.nome_equipe_contratante%TYPE;
        v_chefe_antigo Chefe.credencial_FIA_funcionario%TYPE;
    BEGIN
        pr_validar_disjuncao(p_credencial_fia);

        -- Descobre a equipe do novo chefe
        SELECT nome_equipe_contratante INTO v_equipe_nova FROM Funcionario_equipe WHERE credencial_FIA_pessoa = p_credencial_fia;
        
        -- Descobre quem é o chefe antigo dessa equipe
        BEGIN
            SELECT c.credencial_FIA_funcionario INTO v_chefe_antigo 
            FROM Chefe c INNER JOIN Funcionario_equipe f ON c.credencial_FIA_funcionario = f.credencial_FIA_pessoa 
            WHERE f.nome_equipe_contratante = v_equipe_nova;
            
            -- Deleta o chefe antigo
            DELETE FROM Chefe WHERE credencial_FIA_funcionario = v_chefe_antigo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL; -- Se a equipe não tinha chefe, segue normalmente
        END;

        -- Insere o chefe novo
        INSERT INTO Chefe (credencial_FIA_funcionario, data_assuncao_equipe, cargo_chefe) VALUES (p_credencial_fia, p_data, p_cargo_chefe);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20017, 'Erro inesperado ao atualizar o chefe: ' || SQLERRM);
    
    END pr_mudar_chefe;

    PROCEDURE pr_mudar_departamento_funcionario(p_credencial IN Funcionario_equipe.credencial_FIA_pessoa%TYPE, p_novo_departamento IN Funcionario_equipe.departamento%TYPE) IS
    BEGIN 
        UPDATE Funcionario_equipe SET departamento = p_novo_departamento WHERE credencial_FIA_pessoa = p_credencial;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20018, 'Erro inesperado ao mudar departamento: ' || SQLERRM);
    END pr_mudar_departamento_funcionario;


    ---------------------------------------------------------
    -- SEÇÃO 4: CONSULTAS E RELATÓRIOS
    ---------------------------------------------------------

    -- ======================================================
    -- FUNÇÕES DE CONTAGEM
    -- ======================================================

    FUNCTION fn_numero_total_staff(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM Funcionario_equipe WHERE nome_equipe_contratante = p_nome_equipe;
        RETURN v_total;
    END fn_numero_total_staff;
    

    FUNCTION fn_numero_total_engenheiros(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM Engenheiro eng INNER JOIN Funcionario_equipe fun ON eng.credencial_FIA_funcionario = fun.credencial_FIA_pessoa WHERE fun.nome_equipe_contratante = p_nome_equipe;
        RETURN v_total;
    END fn_numero_total_engenheiros;


    FUNCTION fn_numero_total_mecanicos(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total FROM Mecanico mec INNER JOIN Funcionario_equipe fun ON mec.credencial_FIA_funcionario = fun.credencial_FIA_pessoa WHERE fun.nome_equipe_contratante = p_nome_equipe;
        RETURN v_total;
    END fn_numero_total_mecanicos;

    -- ======================================================
    -- FUNÇÕES DE LISTAGEM
    -- ======================================================

    FUNCTION fn_listar_funcionarios(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_funcionarios IS
        v_tabela tipo_tabela_funcionarios;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r_func IN (
            SELECT * FROM Funcionario_equipe 
            WHERE (p_nome_equipe IS NULL OR nome_equipe_contratante = p_nome_equipe)
            ORDER BY nome_equipe_contratante, departamento, funcao_equipe
        ) LOOP
            v_tabela(v_idx) := r_func; 
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_listar_funcionarios;


    FUNCTION fn_listar_engenheiros(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_engenheiros IS
        v_tabela tipo_tabela_engenheiros;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r_eng IN (
            SELECT eng.* FROM Engenheiro eng
            INNER JOIN Funcionario_equipe fun ON eng.credencial_FIA_funcionario = fun.credencial_FIA_pessoa
            WHERE (p_nome_equipe IS NULL OR fun.nome_equipe_contratante = p_nome_equipe)
            ORDER BY eng.especialidade
        ) LOOP
            v_tabela(v_idx) := r_eng;
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_listar_engenheiros;


    FUNCTION fn_listar_mecanicos(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_mecanicos IS
        v_tabela tipo_tabela_mecanicos;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r_mec IN (
            SELECT mec.* FROM Mecanico mec
            INNER JOIN Funcionario_equipe fun ON mec.credencial_FIA_funcionario = fun.credencial_FIA_pessoa
            WHERE (p_nome_equipe IS NULL OR fun.nome_equipe_contratante = p_nome_equipe)
            ORDER BY mec.especialidade, mec.posicao_pit_stop
        ) LOOP
            v_tabela(v_idx) := r_mec;
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_listar_mecanicos;
    
    
    FUNCTION fn_listar_chefes(p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL) RETURN tipo_tabela_chefes IS
        v_tabela tipo_tabela_chefes;
        v_idx    PLS_INTEGER := 1;
    BEGIN
        FOR r_chefe IN (
            SELECT ch.* FROM Chefe ch
            INNER JOIN Funcionario_equipe fun ON ch.credencial_FIA_funcionario = fun.credencial_FIA_pessoa
            WHERE (p_nome_equipe IS NULL OR fun.nome_equipe_contratante = p_nome_equipe)
            ORDER BY ch.cargo_chefe, ch.data_assuncao_equipe
        ) LOOP
            v_tabela(v_idx) := r_chefe;
            v_idx := v_idx + 1;
        END LOOP;
        
        RETURN v_tabela;
    END fn_listar_chefes;


    ---------------------------------------------------------
    -- LISTAR EQUIPES COM FUNCIONÁRIOS (RIGHT OUTER JOIN)
    ---------------------------------------------------------

    FUNCTION fn_listar_equipes_com_funcionarios(
        p_nome_equipe IN Funcionario_equipe.nome_equipe_contratante%TYPE DEFAULT NULL
    ) RETURN t_equipes_funcionarios
    IS
        v_resultado t_equipes_funcionarios;
        v_idx       PLS_INTEGER := 1;
    BEGIN
        -- RIGHT OUTER JOIN: Todas as equipes aparecem, mesmo aquelas sem funcionários
        FOR r IN (
            SELECT 
                fk.nome_equipe_contratante,
                fk.credencial_FIA_pessoa,
                pes.nome,
                fk.funcao_equipe,
                fk.departamento
            FROM Funcionario_equipe fk
            RIGHT OUTER JOIN (
                SELECT DISTINCT nome_equipe_contratante FROM Funcionario_equipe
                WHERE (p_nome_equipe IS NULL OR nome_equipe_contratante = p_nome_equipe)
            ) eq ON fk.nome_equipe_contratante = eq.nome_equipe_contratante
            LEFT OUTER JOIN Pessoa pes ON fk.credencial_FIA_pessoa = pes.credencial_FIA
            ORDER BY eq.nome_equipe_contratante, pes.nome
        ) LOOP
            v_resultado(v_idx).nome_equipe         := r.nome_equipe_contratante;
            v_resultado(v_idx).credencial_fia      := r.credencial_FIA_pessoa;
            v_resultado(v_idx).nome_funcionario    := r.nome;
            v_resultado(v_idx).funcao              := r.funcao_equipe;
            v_resultado(v_idx).departamento        := r.departamento;
            v_idx := v_idx + 1;
        END LOOP;

        RETURN v_resultado;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20019, 'Erro ao listar equipes com funcionários: ' || SQLERRM);
    END fn_listar_equipes_com_funcionarios;


END PKG_GESTAO_EQUIPE;
/





-- ==========================================
-- SEGURANÇA: TRIGGER "TRG_CHEFE_UNICO"
-- ==========================================
CREATE OR REPLACE TRIGGER TRG_CHEFE_UNICO
BEFORE INSERT ON Chefe
FOR EACH ROW
BEGIN
    -- Chama a função do pacote para validar se o cargo de chefe já está ocupado na equipe do candidato
    IF PKG_GESTAO_EQUIPE.fn_equipe_tem_chefe(:NEW.credencial_FIA_funcionario) THEN
        RAISE_APPLICATION_ERROR(-20200, 'Esta equipe já possui um chefe ativo. A F1 permite apenas um chefe por vez para cada equipe.');
    END IF;
    
END;
/