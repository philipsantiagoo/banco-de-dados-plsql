# 🗄️ bd-plsql

Scripts PL/SQL desenvolvidos para a disciplina de **Banco de Dados**.

---

## 📋 Sobre o repositório

Este repositório reúne todos os scripts SQL e PL/SQL produzidos ao longo da disciplina, organizados por categoria. O banco de dados utilizado é o **Oracle Database**, e os scripts seguem a sintaxe compatível com **Oracle SQL e PL/SQL**.

---

## 📁 Estrutura

```
bd-plsql/
├── DDL/              # Definição da estrutura do banco
├── DML/              # Manipulação de dados
├── queries/          # Consultas e relatórios
└── procedures/       # Objetos PL/SQL (procedures, functions, triggers, packages)
```

### 📂 DDL — Data Definition Language
Scripts responsáveis por **definir e estruturar** o banco de dados. Devem ser executados **primeiro**, antes de qualquer outro script.

Inclui:
- `CREATE TABLE` — criação das tabelas
- `ALTER TABLE` — modificações na estrutura
- `DROP TABLE` — remoção de tabelas
- Sequências (`CREATE SEQUENCE`)
- Índices (`CREATE INDEX`)
- Constraints (PK, FK, UNIQUE, CHECK)

---

### 📂 DML — Data Manipulation Language
Scripts responsáveis por **popular e manipular os dados** das tabelas. Dependem do DDL já ter sido executado.

Inclui:
- `INSERT` — inserção de registros
- `UPDATE` — atualização de dados
- `DELETE` — remoção de registros
- Scripts de carga inicial (seed)

---

### 📂 queries
Consultas SQL para **leitura e análise dos dados**. Não alteram nada no banco, apenas retornam informações.

Inclui:
- `SELECT` simples e complexos
- Junções (`JOIN`)
- Subconsultas
- Agrupamentos (`GROUP BY`, `HAVING`)
- Relatórios e visões (`VIEW`)

---

### 📂 procedures
Objetos PL/SQL que encapsulam **lógica de negócio** dentro do banco de dados.

Inclui:
- **Stored Procedures** — blocos de código reutilizáveis
- **Functions** — retornam um valor específico
- **Triggers** — executados automaticamente em eventos (INSERT, UPDATE, DELETE)
- **Packages** — agrupamento de procedures e functions relacionadas
- Blocos PL/SQL anônimos

---

## ▶️ Ordem de execução

Para configurar o banco do zero, execute os scripts nesta ordem:

1. `DDL/` — cria a estrutura
2. `DML/` — popula os dados
3. `procedures/` — cria os objetos PL/SQL
4. `queries/` — executa as consultas

---

## 🛠️ Ferramentas

- **Oracle Database Free** (ou Oracle XE)
- **Oracle SQL Developer** ou **DBeaver**
- Alternativa online: [Oracle Live SQL](https://livesql.oracle.com)

---

## 👥 Integrantes

| Nome | GitHub |
|------|--------|
| Philip Santiago | [@philipsantiagoo](https://github.com/philipsantiagoo) |
| Arthur Dias | [@ado-938](https://github.com/ado-938) |
| Felipe Augusto | [@lipek6](https://github.com/lipek6) |
| Gabriel André | [@GabrielAndreSFC](https://github.com/GabrielAndreSFC) |
| Vinícius Arraes | [@viniciusarraes](https://github.com/viniciusarraes) |
| Felipe Mateus | [@fel201](https://github.com/fel201) |

---

## 📚 Disciplina

> Banco de Dados — *Ciência da Computação*