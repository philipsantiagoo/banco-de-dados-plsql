
# 📚 Guia de Desenvolvimento: Packages PL/SQL (Projeto F1)

Este documento estabelece as diretrizes e os padrões de arquitetura para a criação de Pacotes (Packages), Procedimentos (Procedures) e Funções (Functions) no nosso banco de dados Oracle. O objetivo é manter o código limpo, seguro e performático.

## 🚨 Regra de Ouro: O Uso Correto da Inteligência Artificial

A Inteligência Artificial é uma excelente ferramenta de mentoria, mas **não deve ser usada como um gerador cego de código**. No passado, tivemos problemas com scripts que utilizavam sintaxe de PostgreSQL (ex: `generate_series`, `random()`) ou que violavam nossas restrições de integridade.

Se você for utilizar a IA para ajudar no desenvolvimento do seu pacote, **siga este protocolo estrito**:

1. **Contexto é Tudo:** Nunca peça para a IA "fazer uma função" do zero. Você **DEVE** anexar no seu prompt o nosso arquivo `create_tables.sql` atualizado, o documento [`Diagrama relaciona normalizado - Grupo 4`](https://docs.google.com/document/d/1A6MuPYdcdNPu8xVRheoijSO7KBQ5WA7rxx7jjkfOYSI/edit?usp=sharing) e, opcionalmente, o documento [`Minimundo - Grupo 4`](https://docs.google.com/document/d/1DTdQI8sqKN9eT458IctIbvUe73GMCltyed-9ulKsTL8/edit?usp=sharing) e imagens do [`Diagrama ER F1`](https://app.diagrams.net/#G1gXOCiqZZbSRdPnAja9J5Dvy3uCz893tW#%7B%22pageId%22%3A%22IvqcS34_7M81-bfpJvCH%22%7D) . Sem isso, a IA vai inventar colunas que não existem e quebrar o banco.
2. **Especifique o SGBD:** Sempre inicie o prompt deixando claro: *"Estamos utilizando Oracle SQL e PL/SQL"*.
3. **Teste antes de abrir PR:** Nunca assuma que um código gerado está certo. Valide as foreign keys, teste inserções inválidas e veja se o tratamento de exceções funciona.

---

## 🏛️ Padrão de Arquitetura do Código

Todos os pacotes do nosso projeto devem ser divididos em **duas partes** e seguir o padrão de nomenclatura abaixo:

* **Prefixos:** `PKG_` para pacotes, `pr_` para procedures, `fn_` para functions, `p_` para parâmetros de entrada, `v_` para variáveis locais.
* **Tipagem Dinâmica:** Sempre utilize `%TYPE` para parâmetros. Ex: `p_nome IN Pessoa.nome%TYPE`. Nunca "chumbe" o tamanho do dado (ex: `VARCHAR2(50)`).
* **Tratamento de Exceções:** Nenhuma procedure deve estourar um erro cru do Oracle (como `ORA-02291`). Use blocos `EXCEPTION` e `RAISE_APPLICATION_ERROR(-20xxx, 'Sua mensagem');`.

### Exemplo de Estrutura Esperada:

```sql
-- ==========================================
-- ESPECIFICAÇÃO (HEADER): O que o pacote faz
-- ==========================================
CREATE OR REPLACE PACKAGE PKG_EXEMPLO AS
    PROCEDURE pr_acao_exemplo(p_id IN Tabela.coluna%TYPE);
    FUNCTION fn_calculo_exemplo(p_id IN Tabela.coluna%TYPE) RETURN NUMBER;
END PKG_EXEMPLO;
/

-- ==========================================
-- CORPO (BODY): Como o pacote faz
-- ==========================================
CREATE OR REPLACE PACKAGE BODY PKG_EXEMPLO AS
    PROCEDURE pr_acao_exemplo(p_id IN Tabela.coluna%TYPE) IS
        -- Variáveis locais aqui
    BEGIN
        -- Lógica de INSERT/UPDATE/DELETE aqui
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro amigável: ' || SQLERRM);
    END pr_acao_exemplo;
    
    -- (Implementação da Função aqui...)
END PKG_EXEMPLO;
/

```

---

## 💡 Temas e Escopos para os Novos Pacotes

Para dividirmos as tarefas, aqui estão sugestões de pacotes que precisamos desenvolver, com ideias de lógicas que cada um pode abraçar, mas não se limitar. Adicionem tudo o que estiverem afim e que acharem válido para o pacote:

### 1. `PKG_GESTAO_PESSOAS` (Foco: Burocracia e Documentação)

Gerencia a tabela `Pessoa` e seus agregados diretos (`Telefone`, `Passaporte`).

* `fn_dias_vencimento_passaporte(p_credencial)`: Retorna quantos dias faltam para o passaporte de alguém vencer.
* `pr_renovar_passaporte(p_credencial, p_anos_validade)`: Atualiza a data de emissão e validade.
* `pr_adicionar_telefone(p_credencial, p_ddi, p_ddd, p_numero)`: Insere um novo contato, com tratamento caso a pessoa já tenha muitos números.

### 2. `PKG_GESTAO_PILOTOS` (Foco: Vida Esportiva do Piloto)

Gerencia a tabela `Piloto` e suas substituições.

* `pr_registrar_piloto(p_credencial, p_superlicenca)`: Insere o piloto e já valida se a superlicença é única.
* `pr_registrar_substituicao(p_piloto_oficial, p_piloto_reserva, p_sessao, p_gp)`: Efetiva a troca de pilotos em um fim de semana (inserindo na tabela `Substitui`).
* `fn_pontuacao_campeonato(p_piloto, p_ano)`: Calcula a soma de todos os pontos ganhos nas sessões de um ano específico.

### 3. `PKG_ENGENHARIA_FROTA` (Foco: Carros e Desenvolvimento)

Gerencia as tabelas `Modelo_carro` e `Chassi`.

* `pr_homologar_modelo(p_modelo, p_ano, p_equipe, p_motor)`: Cria o projeto base do carro para a temporada.
* `pr_fabricar_chassi(p_codigo, p_modelo, p_numero_carro)`: Instancia um novo chassi físico para a pista.
* `pr_atualizar_status_chassi(p_codigo, p_novo_status)`: Muda o status do carro (ex: de 'Ativo' para 'Destruído/Acidentado').

### 4. `PKG_GESTAO_FINANCEIRA` (Foco: Patrocínios)

Gerencia as relações financeiras (`Patrocinador`, `Contrato`, `Patrocina`).

* `pr_assinar_contrato_equipe(p_equipe, p_lei_patrocinador, p_valor, p_data_inicio, p_data_fim)`: Insere o vínculo com validações de data.
* `pr_renovar_patrocinio_piloto(p_piloto, p_patrocinador, p_adicional_valor, p_nova_data_fim)`: Atualiza a tabela `Patrocina`.
* `fn_receita_total_equipe(p_equipe, p_ano)`: Soma o valor de todos os contratos ativos da equipe naquele ano.

### 5. `PKG_DIRECAO_PROVA` (Foco: Eventos e Resultados)

Gerencia `Temporada`, `Grande_premio`, `Sessao`, `Participa_sessao`.

* `pr_agendar_sessao(...)`: Cadastra horários (Treinos, Quali, Corrida).
* `pr_registrar_resultado_corrida(p_piloto, p_gp, p_posicao, p_tempo, p_pontos)`: Insere a posição final de um piloto na tabela `Participa_sessao`.
* `fn_listar_podio(p_gp, p_ano)`: Retorna um *Array em Memória* (Collection/INDEX BY) com os 3 primeiros colocados da corrida.

### 6. `PKG_TELEMETRIA_ANALISE` (Foco: Big Data e Voltas)

Gerencia as tabelas pesadas de `Volta` e `Telemetria`.

* `fn_melhor_volta_sessao(p_sessao, p_gp, p_ano)`: Varre a tabela `Volta` e retorna qual piloto fez o tempo mais baixo.
* `fn_velocidade_maxima_piloto(p_piloto, p_gp)`: Lê a tabela `Telemetria` e retorna o pico de velocidade atingido.
* `fn_media_desgaste_pneus(...)`: Função analítica baseada na temperatura e pressão coletada na telemetria.

---
