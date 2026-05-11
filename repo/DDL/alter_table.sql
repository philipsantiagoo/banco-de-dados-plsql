
-- modificações que poderiamos ter no futuro

ALTER TABLE Substitui
ADD motivo_substituicao VARCHAR2(200);

ALTER TABLE Piloto
ADD nacionalidade VARCHAR2(50);

ALTER TABLE Telemetria
ADD desgaste_pneus NUMBER(5,2);

-- esse aqui é só adição de constraint, pode ser útil talvez
ALTER TABLE Telemetria
ADD CONSTRAINT ck_velocidade
CHECK (velocidade >= 0);

-- renomeação 
ALTER TABLE Chassi
RENAME COLUMN status_carro TO status_operacional;

-- aumenta tamanho da coluna nome 
ALTER TABLE Pessoa
MODIFY nome VARCHAR2(200);