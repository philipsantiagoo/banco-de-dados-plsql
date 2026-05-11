
-- algumas funcionalidades: 
--   1. fn_dias_vencimento_passaporte: calcula dias até vencimento do passaporte
--   2. pr_renovar_passaporte: atualiza data de emissão e validade do passaporte
--   3. pr_adicionar_telefone: insere novo contato telefônico
CREATE OR REPLACE PACKAGE PKG_GESTAO_PESSOAS AS
    
    FUNCTION fn_dias_vencimento_passaporte(p_credencial IN Pessoa.credencial_FIA%TYPE) RETURN NUMBER;
    
    
    
    PROCEDURE pr_renovar_passaporte(
        p_credencial IN Pessoa.credencial_FIA%TYPE,
        p_anos_validade IN NUMBER
    );
    
    -- Adiciona um novo telefone para uma pessoa
    -- Entrada: p_credencial, p_ddi (código do país), p_ddd (código da região), p_numero (número do telefone)
    PROCEDURE pr_adicionar_telefone(
        p_credencial IN Pessoa.credencial_FIA%TYPE,
        p_ddi IN Telefone.codigo_pais%TYPE,
        p_ddd IN Telefone.codigo_regiao%TYPE,
        p_numero IN Telefone.fone%TYPE
    );
    
END PKG_GESTAO_PESSOAS;
/

CREATE OR REPLACE PACKAGE BODY PKG_GESTAO_PESSOAS AS
    
    -- constante para limite máximo de telefones por pessoa
    c_max_telefones CONSTANT NUMBER := 3;
    
    FUNCTION fn_dias_vencimento_passaporte(p_credencial IN Pessoa.credencial_FIA%TYPE) RETURN NUMBER IS
        v_dias_vencimento NUMBER;
        v_data_validade Passaporte.data_validade%TYPE;
    BEGIN
        -- busca a data de validade do passaporte da pessoa
        SELECT data_validade
        INTO v_data_validade
        FROM Passaporte
        WHERE credencial_FIA_pessoa = p_credencial;
        
        -- calcula a diferença entre a data de validade e hoje
        v_dias_vencimento := TRUNC(v_data_validade) - TRUNC(SYSDATE);
        
        RETURN v_dias_vencimento;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro: Nenhum passaporte encontrado para a credencial ' || p_credencial);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Erro ao consultar passaporte: ' || SQLERRM);
    END fn_dias_vencimento_passaporte;
    
    PROCEDURE pr_renovar_passaporte(
        p_credencial IN Pessoa.credencial_FIA%TYPE,
        p_anos_validade IN NUMBER
    ) IS
        v_nova_emissao Passaporte.data_emissao%TYPE;
        v_nova_validade Passaporte.data_validade%TYPE;
    BEGIN
        -- validação da entrada
        IF p_anos_validade <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Erro: A validade do passaporte deve ser maior que 0');
        END IF;
        
        -- define datas de emissão e validade
        v_nova_emissao := SYSDATE;
        v_nova_validade := SYSDATE + (p_anos_validade * 365);
        
        -- atualiza o passaporte
        UPDATE Passaporte
        SET data_emissao = v_nova_emissao,
            data_validade = v_nova_validade
        WHERE credencial_FIA_pessoa = p_credencial;
        
        -- verifica se o passaporte foi encontrado e atualizado
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Erro: Nenhum passaporte encontrado para a credencial ' || p_credencial);
        END IF;
        
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20005, 'Erro ao renovar passaporte: ' || SQLERRM);
    END pr_renovar_passaporte;
    
    
    -- IMPLEMENTAÇÃO: pr_adicionar_telefone
    PROCEDURE pr_adicionar_telefone(
        p_credencial IN Pessoa.credencial_FIA%TYPE,
        p_ddi IN Telefone.codigo_pais%TYPE,
        p_ddd IN Telefone.codigo_regiao%TYPE,
        p_numero IN Telefone.fone%TYPE
    ) IS
        v_qtd_telefones NUMBER;
    BEGIN
        -- valida entrada
        IF p_ddi IS NULL OR TRIM(p_ddi) = '' THEN
            RAISE_APPLICATION_ERROR(-20006, 'Erro: Código do país (DDI) não pode ser vazio');
        END IF;
        IF p_ddd IS NULL OR TRIM(p_ddd) = '' THEN
            RAISE_APPLICATION_ERROR(-20007, 'Erro: Código da região (DDD) não pode ser vazio');
        END IF;
        IF p_numero IS NULL OR TRIM(p_numero) = '' THEN
            RAISE_APPLICATION_ERROR(-20008, 'Erro: Número do telefone não pode ser vazio');
        END IF;
        
        -- verifica se a pessoa existe
        BEGIN
            SELECT COUNT(*)
            INTO v_qtd_telefones
            FROM Pessoa
            WHERE credencial_FIA = p_credencial;
            
            IF v_qtd_telefones = 0 THEN
                RAISE_APPLICATION_ERROR(-20009, 'Erro: Pessoa com credencial ' || p_credencial || ' não encontrada');
            END IF;
        END;
        
        -- conta quantos telefones a pessoa já tem
        SELECT COUNT(*)
        INTO v_qtd_telefones
        FROM Telefone
        WHERE credencial_FIA_pessoa = p_credencial;
        
        -- verifica se não ultrapassou o limite de telefones
        IF v_qtd_telefones >= c_max_telefones THEN
            RAISE_APPLICATION_ERROR(
                -20010, 
                'Erro: Pessoa já possui ' || v_qtd_telefones || ' telefones (limite máximo: ' || c_max_telefones || ')'
            );
        END IF;
        
        -- insere o novo telefone
        INSERT INTO Telefone(codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa)
        VALUES (p_ddi, p_ddd, p_numero, p_credencial);
        
        COMMIT;
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20011, 'Erro: Este telefone já está registrado para a pessoa');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20012, 'Erro ao adicionar telefone: ' || SQLERRM);
    END pr_adicionar_telefone;

END PKG_GESTAO_PESSOAS;
/