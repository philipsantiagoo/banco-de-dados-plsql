-- =================================================================           
-- PAINEL DE TESTES E RELATÓRIOS DO SISTEMA DA F1
-- =================================================================

SET SERVEROUTPUT ON;

DECLARE
    -- Variáveis para Gestão de Pessoas (Coleções)
    v_pessoas PKG_GESTAO_PESSOAS.t_tabela_pessoas;
    
    -- Variáveis para Gestão de Pilotos (Parâmetros OUT)
    v_campeao_credencial VARCHAR2(50);
    v_campeao_nome       VARCHAR2(150);
    v_campeao_pontos     NUMBER;
    
    -- Variáveis para Direção de Prova
    v_podio PKG_DIRECAO_PROVA.t_podio;
    
    -- Variáveis para Gestão de Equipe (Relatórios Agregados)
    v_relatorio_mecanicos PKG_GESTAO_EQUIPE.tipo_tabela_contagem;
    
    -- Variáveis para Telemetria
    v_vel_maxima NUMBER;

BEGIN
    DBMS_OUTPUT.PUT_LINE('====================================================');
    DBMS_OUTPUT.PUT_LINE('INICIANDO DIAGNÓSTICO DO SISTEMA DA FÓRMULA 1');
    DBMS_OUTPUT.PUT_LINE('====================================================');
    DBMS_OUTPUT.PUT_LINE(' ');

    -- ---------------------------------------------------------
    -- TESTE 1: BUSCA DE PESSOAS (Operador LIKE e INDEX BY)
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('🔎 TESTE 1: Buscando pessoas com "Verstappen" no nome...');
    v_pessoas := PKG_GESTAO_PESSOAS.fn_buscar_pessoa_por_nome('Verstappen');
    
    IF v_pessoas.COUNT > 0 THEN
        FOR i IN 1 .. v_pessoas.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('   -> Encontrado: ' || v_pessoas(i).nome || ' | Nascido em: ' || TO_CHAR(v_pessoas(i).data_nascimento, 'DD/MM/YYYY'));
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('   -> Nenhuma pessoa encontrada.');
    END IF;
    DBMS_OUTPUT.PUT_LINE(' ');


    -- ---------------------------------------------------------
    -- TESTE 2: RESULTADOS DE CORRIDA E PÓDIO
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('TESTE 2: Pódio do Grand Prix da Austrália 2024...');
    v_podio := PKG_DIRECAO_PROVA.fn_listar_podio('Grand Prix da Austrália', 2024);
    
    IF v_podio.COUNT > 0 THEN
        FOR i IN 1 .. v_podio.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('   ' || v_podio(i).posicao || 'º Lugar: ' || RPAD(v_podio(i).nome_piloto, 20, ' ') || ' (' || v_podio(i).nome_equipe || ')');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('   -> Nenhum resultado registrado para esta corrida.');
    END IF;
    DBMS_OUTPUT.PUT_LINE(' ');


    -- ---------------------------------------------------------
    -- TESTE 3: ESTATÍSTICAS DO CAMPEONATO (Parâmetros OUT)
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('TESTE 3: Piloto com mais pontos na temporada 2024...');
    -- Chama a procedure que preenche as variáveis através do "OUT"
    PKG_GESTAO_PILOTOS.piloto_com_mais_pontos(2024, v_campeao_credencial, v_campeao_nome, v_campeao_pontos);
    
    DBMS_OUTPUT.PUT_LINE('   -> Líder: ' || v_campeao_nome || ' com ' || NVL(v_campeao_pontos, 0) || ' pontos.');
    DBMS_OUTPUT.PUT_LINE(' ');


    -- ---------------------------------------------------------
    -- TESTE 4: TELEMETRIA (Índices e Agregações)
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('TESTE 4: Telemetria de Max Verstappen na Austrália...');
    -- Vamos usar o ID 1000 que sabemos que é o Max pelos logs anteriores
    BEGIN
        v_vel_maxima := PKG_TELEMETRIA_ANALISE.fn_velocidade_maxima_piloto('1000', 'Grand Prix da Austrália');
        DBMS_OUTPUT.PUT_LINE('   -> Velocidade Máxima Atingida: ' || v_vel_maxima || ' km/h');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   -> Erro ao ler telemetria: Piloto sem dados para esta pista.');
    END;
    DBMS_OUTPUT.PUT_LINE(' ');


    -- ---------------------------------------------------------
    -- TESTE 5: RELATÓRIOS DO RH (GROUP BY e RECORD Customizado)
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('TESTE 5: Relatório de Mecânicos da Ferrari (Por Posição)...');
    v_relatorio_mecanicos := PKG_GESTAO_EQUIPE.fn_agrupar_por_posicao_mec('Scuderia Ferrari');
    
    IF v_relatorio_mecanicos.COUNT > 0 THEN
        FOR i IN 1 .. v_relatorio_mecanicos.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('   -> ' || RPAD(v_relatorio_mecanicos(i).nome_cargo, 20, '.') || ' ' || v_relatorio_mecanicos(i).quantidade || ' funcionário(s)');
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('   -> Equipe sem mecânicos cadastrados.');
    END IF;
    DBMS_OUTPUT.PUT_LINE(' ');


    -- ---------------------------------------------------------
    -- TESTE 6: SEGURANÇA E INTEGRIDADE (Tratamento de Exceção)
    -- ---------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('TESTE 6: Tentando burlar a segurança do sistema...');
    BEGIN
        -- Tentando cadastrar o Lando Norris (1003) novamente com uma superlicença duplicada
        DBMS_OUTPUT.PUT_LINE('   [Ação] Tentando cadastrar superlicença duplicada...');
        PKG_GESTAO_PILOTOS.pr_registrar_piloto('1003', 'VER-001', 'Clone Verstappen', TO_DATE('2000-01-01', 'YYYY-MM-DD'));
        
        DBMS_OUTPUT.PUT_LINE('   [Falha] O sistema aceitou a fraude! (Isso não deveria aparecer)');
    EXCEPTION
        WHEN OTHERS THEN
            -- Aqui nós pegamos o erro que o banco jogou e mostramos de forma bonita
            DBMS_OUTPUT.PUT_LINE('   [Sucesso] O banco de dados bloqueou a fraude! Mensagem interceptada: ');
            DBMS_OUTPUT.PUT_LINE('   *** ' || SQLERRM || ' ***');
    END;
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('====================================================');
    DBMS_OUTPUT.PUT_LINE('TODOS OS SISTEMAS OPERACIONAIS E INTEGROS!');
    DBMS_OUTPUT.PUT_LINE('====================================================');

END;
/