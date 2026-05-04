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
    LEI          VARCHAR2(50)  NOT NULL,
    nome_empresa VARCHAR2(150) NOT NULL,
    pais_empresa VARCHAR2(50)  NOT NULL,         

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



CREATE TABLE Patrocina(
    LEI_patrocinador        VARCHAR2(50) NOT NULL,
    credencial_FIA_piloto   VARCHAR2(50) NOT NULL,
    data_inicio             DATE         NOT NULL, 
    data_fim                DATE,
    valor                   NUMBER(15, 2)NOT NULL,

    CONSTRAINT pk_patrocina PRIMARY KEY(LEI_patrocinador, credencial_FIA_piloto, data_inicio),
    CONSTRAINT fk_patrocina_patrocinador FOREIGN KEY(LEI_patrocinador)
        REFERENCES Patrocinador(LEI),
    CONSTRAINT fk_patrocina_piloto FOREIGN KEY(credencial_FIA_piloto)
        REFERENCES Piloto(credencial_FIA_pessoa),
    CONSTRAINT ck_patrocina_datas CHECK(data_fim IS NULL OR data_fim >= data_inicio)
);



-- Vai precisar de um trigger pra validar esse ano futuramente.
CREATE TABLE Modelo_carro(
    nome_modelo VARCHAR2(50)                NOT NULL,
    ano_projeto NUMBER(4)                   NOT NULL,
    nome_equipe_desenvolvedora VARCHAR2(50) NOT NULL,
    fabricante_motor VARCHAR2(50)           NOT NULL,

    CONSTRAINT pk_modelo_carro PRIMARY KEY(nome_modelo, ano_projeto),
    CONSTRAINT fk_modelo_carro_equipe FOREIGN KEY(nome_equipe_desenvolvedora)
        REFERENCES Equipe(nome_equipe)
);



CREATE TABLE Chassi(
    codigo_chassi      VARCHAR2(20) NOT NULL,
    nome_modelo        VARCHAR2(50) NOT NULL,
    ano_projeto_modelo NUMBER(4)    NOT NULL,
    numero_carro       NUMBER(2)    NOT NULL,
    status_carro       CHAR(2)      NOT NULL,           -- Adicionar um default aqui

    CONSTRAINT pk_chassi PRIMARY KEY(codigo_chassi, nome_modelo, ano_projeto_modelo),
    CONSTRAINT fk_chassi_modelo_carro_nome FOREIGN KEY(nome_modelo)
        REFERENCES Modelo_carro(nome_modelo),
    CONSTRAINT fk_chassi_modelo_carro_ano FOREIGN KEY(ano_projeto_modelo)
        REFERENCES Modelo_carro(ano_projeto)
);



CREATE TABLE Temporada(
    ano NUMBER(4) NOT NULL,

    CONSTRAINT pk_temporada PRIMARY KEY(ano)
);



CREATE TABLE Participa_temporada(
    nome_equipe_participante VARCHAR2(50) NOT NULL,
    ano_temporada            NUMBER(4)    NOT NULL,

    CONSTRAINT pk_participa_temporada PRIMARY KEY(nome_equipe_participante, ano_temporada),
    CONSTRAINT fk_participa_temporada_equipe FOREIGN KEY(nome_equipe_participante)
        REFERENCES Equipe(nome_equipe),
    CONSTRAINT fk_participa_temporada_temporada FOREIGN KEY(ano_temporada)
        REFERENCES Temporada(ano)
);



CREATE TABLE Grande_premio(
    nome_gp       VARCHAR2(50)    NOT NULL,
    ano_temporada NUMBER(4)       NOT NULL,
    pais          VARCHAR2(50)    NOT NULL,
    numero_voltas NUMBER(2)       NOT NULL,
    circuito      VARCHAR(50)     NOT NULL,

    CONSTRAINT pk_grande_premio PRIMARY KEY(nome_gp, ano_temporada),
    CONSTRAINT fk_grande_premio_temporada FOREIGN KEY(ano_temporada)
        REFERENCES Temporada(ano)
);


CREATE TABLE Sessao(
    tipo_sessao VARCHAR2(50) NOT NULL,
    nome_gp     VARCHAR2(50) NOT NULL,
    ano_gp      NUMBER(4)    NOT NULL,
    data_sessao DATE         NOT NULL,
    horario     TIMESTAMP    NOT NULL,

    CONSTRAINT pk_sessao PRIMARY KEY(tipo_sessao, nome_gp, ano_gp),
    CONSTRAINT fk_sessao_

);
