CREATE TABLE Pessoa(
    credencial_FIA  VARCHAR2(50)  NOT NULL,
    nome            VARCHAR2(150) NOT NULL,
    data_nascimento DATE          NOT NULL,

    CONSTRAINT pk_pessoa PRIMARY KEY(credencial_FIA),
    CONSTRAINT ck_pessoa_data_nascimento CHECK(data_nascimento <= SYSDATE)
);



CREATE TABLE Telefone(
    codigo_pais           VARCHAR2(10)  NOT NULL,
    codigo_regiao         VARCHAR2(10)  NOT NULL,
    fone                  VARCHAR2(20)  NOT NULL,
    credencial_FIA_pessoa VARCHAR2(50)  NOT NULL,

    CONSTRAINT pk_telefone PRIMARY KEY(codigo_pais, codigo_regiao, fone, credencial_FIA_pessoa),        -- LEMBRAR DE ATUALIZAR ISSO NO DIAGRAMA RELACIONAL (isso foi comentado pelo monitor)
    CONSTRAINT fk_telefone_pessoa FOREIGN KEY(credencial_FIA_pessoa)
        REFERENCES Pessoa(credencial_FIA)
);



CREATE TABLE Passaporte(
    numero                VARCHAR2(50)  NOT NULL,
    pais_emissor          VARCHAR2(50)  NOT NULL,
    credencial_FIA_pessoa VARCHAR2(50)  NOT NULL,
    nome_registrado       VARCHAR2(150) NOT NULL,
    data_emissao          DATE          NOT NULL,
    data_validade         DATE          NOT NULL,

    CONSTRAINT pk_passaporte PRIMARY KEY(numero, pais_emissor),
    CONSTRAINT fk_passaporte_pessoa FOREIGN KEY(credencial_FIA_pessoa)
        REFERENCES Pessoa(credencial_FIA),
    CONSTRAINT ck_passaporte_data_emissao  CHECK(data_emissao <= SYSDATE),
    CONSTRAINT ck_passaporte_data_validade CHECK(data_validade > data_emissao)
);



CREATE TABLE Equipe(
    nome_equipe VARCHAR2(50) NOT NULL,
    cidade      VARCHAR2(50) NOT NULL,
    pais        VARCHAR2(50) NOT NULL,

    CONSTRAINT pk_equipe PRIMARY KEY(nome_equipe)
);



CREATE TABLE Funcionario_FIA(
    credencial_FIA_pessoa VARCHAR2(50) NOT NULL,
    licenca_staff         VARCHAR2(50) NOT NULL UNIQUE,
    cargo_exercido        VARCHAR2(50) DEFAULT 'A Definir' NOT NULL,

    CONSTRAINT pk_funcionario_fia PRIMARY KEY(credencial_FIA_pessoa),
    CONSTRAINT fk_funcionario_fia_pessoa FOREIGN KEY(credencial_FIA_pessoa)
        REFERENCES Pessoa(credencial_FIA)
);



CREATE TABLE Funcionario_equipe(
    credencial_FIA_pessoa   VARCHAR2(50) NOT NULL,
    nome_equipe_contratante VARCHAR2(50) NOT NULL,
    licenca_staff           VARCHAR2(50) NOT NULL UNIQUE,
    funcao_equipe           VARCHAR2(50) DEFAULT 'A Definir' NOT NULL,
    departamento            VARCHAR2(50),

    CONSTRAINT pk_funcionario_equipe PRIMARY KEY(credencial_FIA_pessoa),
    CONSTRAINT fk_funcionario_equipe_pessoa FOREIGN KEY(credencial_FIA_pessoa)
        REFERENCES Pessoa(credencial_FIA),
    CONSTRAINT fk_funcionario_equipe_equipe FOREIGN KEY(nome_equipe_contratante)
        REFERENCES Equipe(nome_equipe)
);



CREATE TABLE Engenheiro(
    credencial_FIA_funcionario VARCHAR2(50) NOT NULL,
    especialidade              VARCHAR2(50),

    CONSTRAINT pk_engenheiro PRIMARY KEY(credencial_FIA_funcionario),
    CONSTRAINT fk_engenheiro_funcionario_equipe FOREIGN KEY(credencial_FIA_funcionario)
        REFERENCES Funcionario_equipe(credencial_FIA_pessoa)
);



CREATE TABLE Mecanico(
    credencial_FIA_funcionario VARCHAR2(50) NOT NULL,
    posicao_pit_stop           VARCHAR2(50),
    especialidade              VARCHAR2(50),

    CONSTRAINT pk_mecanico PRIMARY KEY(credencial_FIA_funcionario),
    CONSTRAINT fk_mecanico_funcionario FOREIGN KEY(credencial_FIA_funcionario)
        REFERENCES Funcionario_equipe(credencial_FIA_pessoa)
);



CREATE TABLE Chefe(
    credencial_FIA_funcionario VARCHAR2(50) NOT NULL,
    nome_equipe_liderada       VARCHAR2(50) NOT NULL,
    data_assuncao_equipe       VARCHAR2(50) NOT NULL,
    cargo_chefe                VARCHAR2(50) NOT NULL,
    
    CONSTRAINT pk_chefe PRIMARY KEY(credencial_FIA_funcionario),
    CONSTRAINT fk_chefe_funcionario_equipe FOREIGN KEY(credencial_FIA_funcionario)
        REFERENCES Funcionario_equipe(credencial_FIA_pessoa),

    CONSTRAINT fk_chefe_equipe FOREIGN KEY(nome_equipe_liderada)
        REFERENCES Equipe(nome_equipe)
);



CREATE TABLE Piloto(
    credencial_FIA_pessoa VARCHAR2(50) NOT NULL,
    superlicenca          VARCHAR2(50) NOT NULL UNIQUE,

    CONSTRAINT pk_piloto PRIMARY KEY(credencial_FIA_pessoa),
    CONSTRAINT fk_piloto_pessoa FOREIGN KEY(credencial_FIA_pessoa)
        REFERENCES Pessoa(credencial_FIA)
);



CREATE TABLE Patrocinador(
    LEI          VARCHAR2(50) NOT NULL,
    nome_empresa VARCHAR2(150) NOT NULL,
    pais_empresa VARCHAR2(50) NOT NULL,         -- Pais deveria ser not null? devemos nos importar com patrocinadores sem pais?

    CONSTRAINT pk_patrocinador PRIMARY KEY(LEI)
);



CREATE TABLE Contrato(
    nome_equipe_patrocinada VARCHAR2(50)  NOT NULL,
    LEI_patrocinador        VARCHAR2(50)  NOT NULL,
    data_inicio             DATE          NOT NULL,
    data_fim                DATE,
    valor                   NUMBER(15, 2) NOT NULL,

    CONSTRAINT pk_contrato PRIMARY KEY(nome_equipe_patrocinada, LEI_patrocinador, data_inicio),
    CONSTRAINT fk_contrato_equipe FOREIGN KEY(nome_equipe_patrocinada)
        REFERENCES Equipe(nome_equipe),
    CONSTRAINT fk_contrato_patrocinador FOREIGN KEY(LEI_patrocinador)
        REFERENCES Patrocinador(LEI),
    CONSTRAINT ck_contrato_datas CHECK(data_fim IS NULL OR data_fim >= data_inicio)
);



-- CREATE TABLE Patrocina();