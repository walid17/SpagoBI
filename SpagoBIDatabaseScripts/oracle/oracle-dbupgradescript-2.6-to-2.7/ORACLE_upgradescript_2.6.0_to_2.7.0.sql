--Chiara 28/08/2010
Create table SBI_KPI_DOCUMENTS (
	ID_KPI_DOC INTEGER NOT NULL,
	BIOBJ_ID INTEGER NOT NULL,
	KPI_ID INTEGER NOT NULL,
 Primary Key ("ID_KPI_DOC")
)

CREATE SEQUENCE SBI_KPI_DOCUMENTS_SEQ INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER

CREATE TRIGGER TRG_SBI_KPI_DOCUMENTS
  BEFORE INSERT
  ON SBI_KPI_DOCUMENTS
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  DECLARE NUOVO_ID NUMBER;
BEGIN
IF :NEW.ID_KPI_DOC IS NULL THEN
     SELECT SBI_KPI_DOCUMENTS_SEQ.NEXTVAL INTO NUOVO_ID FROM DUAL;
     :NEW.ID_KPI_DOC:=NUOVO_ID;
END IF;
END;

Alter table SBI_KPI_DOCUMENTS add CONSTRAINT SBI_KPI_DOCUMENTS_1 Foreign Key (BIOBJ_ID) references SBI_OBJECTS (BIOBJ_ID);
Alter table SBI_KPI_DOCUMENTS add CONSTRAINT SBI_KPI_DOCUMENTS_2 Foreign Key (KPI_ID) references SBI_KPI (KPI_ID);

INSERT INTO SBI_KPI_DOCUMENTS(KPI_ID,BIOBJ_ID)
SELECT k.KPI_ID, o.BIOBJ_ID
FROM SBI_KPI k,SBI_OBJECTS o
WHERE
k.DOCUMENT_LABEL = o.LABEL
and k.DOCUMENT_LABEL IS NOT NULL;

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 09/09/2010: generic user data properties management
CREATE TABLE SBI_UDP (
	UDP_ID	        INTEGER  NOT NULL,
	TYPE_ID			INTEGER NOT NULL,
	FAMILY_ID		INTEGER NOT NULL,
	LABEL           VARCHAR2(20) NOT NULL,
	NAME            VARCHAR2(40) NOT NULL,
	DESCRIPTION     VARCHAR2(1000) NULL,
	IS_MULTIVALUE   SMALLINT DEFAULT 0,    
 PRIMARY KEY ("UDP_ID"));
 
CREATE SEQUENCE SBI_UDP_SEQ INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER;

CREATE TRIGGER TRG_SBI_UDP
  BEFORE INSERT
  ON SBI_UDP
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  DECLARE NUOVO_ID NUMBER;
BEGIN
IF :NEW.UDP_ID IS NULL THEN
     SELECT SBI_UDP_SEQ.NEXTVAL INTO NUOVO_ID FROM DUAL;
     :NEW.UDP_ID:=NUOVO_ID;
END IF;
END;

CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL  ASC);

CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID  ASC);

CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID ASC);

ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_1 FOREIGN KEY ( TYPE_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID );
ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_2 FOREIGN KEY ( FAMILY_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID );

CREATE TABLE SBI_UDP_VALUE (
	UDP_VALUE_ID       INTEGER  NOT NULL,
	UDP_ID			   INTEGER NOT NULL,
	VALUE              VARCHAR2(1000) NOT NULL,
	PROG               INTEGER NULL,
	LABEL              VARCHAR2(20) NULL,
	NAME               VARCHAR2(40) NULL,
	FAMILY			   VARCHAR2(40) NULL,
    BEGIN_TS           TIMESTAMP NOT NULL,
    END_TS             TIMESTAMP NULL,
    REFERENCE_ID	   INTEGER NULL,	
 PRIMARY KEY ("UDP_VALUE_ID"));

CREATE SEQUENCE SBI_UDP_VALUE_SEQ INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER;

CREATE TRIGGER TRG_SBI_UDP_VALUE
  BEFORE INSERT
  ON SBI_UDP_VALUE
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  DECLARE NUOVO_ID NUMBER;
BEGIN
IF :NEW.UDP_VALUE_ID IS NULL THEN
     SELECT SBI_UDP_VALUE_SEQ.NEXTVAL INTO NUOVO_ID FROM DUAL;
     :NEW.UDP_VALUE_ID:=NUOVO_ID;
END IF;
END;

CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID ASC);

ALTER TABLE SBI_UDP_VALUE ADD CONSTRAINT FK_SBI_UDP_VALUE_1 FOREIGN KEY ( UDP_ID ) REFERENCES SBI_UDP ( UDP_ID );

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');
INSERT INTO  SBI_ROLE_TYPE_USER_FUNC values((SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN'), (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'));
COMMIT;
---kpi links
CREATE TABLE SBI_KPI_REL (
  KPI_REL_ID INTEGER NOT NULL,
  KPI_FATHER_ID INTEGER  NOT NULL,
  KPI_CHILD_ID INTEGER  NOT NULL,
  PARAMETER VARCHAR2(100),
  PRIMARY KEY ("KPI_REL_ID")
);
CREATE SEQUENCE SBI_KPI_REL_SEQ INCREMENT BY 1 START WITH 1 MAXVALUE 999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER;
CREATE TRIGGER TRG_SBI_KPI_REL
  BEFORE INSERT
  ON SBI_KPI_REL
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  DECLARE NUOVO_ID NUMBER;
BEGIN
IF :NEW.KPI_REL_ID IS NULL THEN
     SELECT SBI_KPI_REL_SEQ.NEXTVAL INTO NUOVO_ID FROM DUAL;
     :NEW.KPI_REL_ID:=NUOVO_ID;
END IF;
END;

ALTER TABLE SBI_KPI_REL ADD CONSTRAINT FK_SBI_KPI_REL_3 FOREIGN KEY  ( KPI_FATHER_ID ) REFERENCES SBI_KPI ( KPI_ID );
ALTER TABLE SBI_KPI_REL ADD CONSTRAINT FK_SBI_KPI_REL_4 FOREIGN KEY ( KPI_CHILD_ID ) REFERENCES SBI_KPI ( KPI_ID );

-- 28/09/2010 SBI_KPI_ERROR

 CREATE TABLE SBI_KPI_ERROR (
  KPI_ERROR_ID        INTEGER   NOT NULL,
  KPI_MODEL_INST_ID   INTEGER   NOT NULL,
  USER_MSG            VARCHAR2(1000) NULL,
  FULL_MSG            CLOB   NULL,
  TS_DATE             TIMESTAMP NULL,
  LABEL_MOD_INST VARCHAR(100) ,
  PARAMETERS	   VARCHAR(1000),
  PRIMARY KEY ("KPI_ERROR_ID"))
  /

ALTER TABLE SBI_KPI_ERROR ADD CONSTRAINT FK_SBI_KPI_ERROR_MODEL_1 FOREIGN KEY ( KPI_MODEL_INST_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST )
/

--Delete old Attribute tables
DROP TABLE SBI_KPI_MODEL_ATTR_VAL;
DROP TABLE SBI_KPI_MODEL_ATTR;


-- Organizational Unit
CREATE TABLE SBI_ORG_UNIT (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR2(400) NOT NULL,
  NAME             VARCHAR2(400) NOT NULL,
  DESCRIPTION      VARCHAR2(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT UNIQUE (LABEL),
  PRIMARY KEY(ID)
)
/

CREATE TABLE SBI_ORG_UNIT_HIERARCHIES (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR2(400) NOT NULL,
  NAME             VARCHAR2(400) NOT NULL,
  DESCRIPTION      VARCHAR2(1000),
  TARGET     VARCHAR2(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT_HIERARCHIES UNIQUE (LABEL),
  PRIMARY KEY(ID)
)
/

CREATE TABLE SBI_ORG_UNIT_NODES (
  NODE_ID            INTEGER NOT NULL,
  OU_ID           INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  PARENT_NODE_ID INTEGER NULL,
  PATH VARCHAR2(4000) NOT NULL,
  PRIMARY KEY(NODE_ID)
)
/

CREATE TABLE SBI_ORG_UNIT_GRANT (
  ID INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  START_DATE  DATE,
  END_DATE  DATE,
  LABEL            VARCHAR2(400) NOT NULL,
  NAME             VARCHAR2(400) NOT NULL,
  DESCRIPTION      VARCHAR2(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT_GRANT UNIQUE (LABEL),
  PRIMARY KEY(ID)
)
/

CREATE TABLE SBI_ORG_UNIT_GRANT_NODES (
  NODE_ID INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  GRANT_ID INTEGER NOT NULL,
  PRIMARY KEY(NODE_ID, KPI_MODEL_INST_NODE_ID, GRANT_ID)
)
/

ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_1 FOREIGN KEY ( OU_ID ) REFERENCES SBI_ORG_UNIT ( ID ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_3 FOREIGN KEY ( PARENT_NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_3 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_1 FOREIGN KEY ( NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_2 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE
/
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_3 FOREIGN KEY ( GRANT_ID ) REFERENCES SBI_ORG_UNIT_GRANT ( ID ) ON DELETE CASCADE
/
COMMIT;