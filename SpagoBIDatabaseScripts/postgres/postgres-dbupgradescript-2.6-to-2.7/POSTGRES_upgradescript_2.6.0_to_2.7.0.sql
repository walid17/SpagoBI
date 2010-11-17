--Chiara 28/08/2010
CREATE SEQUENCE SBI_KPI_DOCUMENTS_SEQ INCREMENT 1 START  1 ;

Create table SBI_KPI_DOCUMENTS (
	ID_KPI_DOC INTEGER  DEFAULT nextval('SBI_KPI_DOCUMENTS_SEQ') NOT NULL,
	BIOBJ_ID INTEGER NOT NULL,
	KPI_ID INTEGER NOT NULL,
 Primary Key (ID_KPI_DOC)
)

Alter table SBI_KPI_DOCUMENTS add Foreign Key (BIOBJ_ID) references SBI_OBJECTS (BIOBJ_ID) ;
Alter table SBI_KPI_DOCUMENTS add Foreign Key (KPI_ID) references SBI_KPI (KPI_ID);

INSERT INTO SBI_KPI_DOCUMENTS(KPI_ID,BIOBJ_ID)
SELECT k.KPI_ID, o.BIOBJ_ID
FROM SBI_KPI k,SBI_OBJECTS o
WHERE
k.DOCUMENT_LABEL = o.LABEL
and k.DOCUMENT_LABEL IS NOT NULL;

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 08/09/2010: generic user data properties management
CREATE SEQUENCE SBI_UDP_SEQ INCREMENT 1 START  1 ;
CREATE TABLE SBI_UDP (
	UDP_ID	        INTEGER DEFAULT nextval('SBI_UDP_SEQ') NOT NULL,
	TYPE_ID			INTEGER NOT NULL,
	FAMILY_ID		INTEGER NOT NULL,
	LABEL           VARCHAR(20) NOT NULL,
	NAME            VARCHAR(40) NOT NULL,
	DESCRIPTION     VARCHAR(1000) NULL,
	IS_MULTIVALUE   BOOLEAN DEFAULT FALSE,    
 PRIMARY KEY (UDP_ID));
 
CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL);
CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID);
CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID);

ALTER TABLE SBI_UDP ADD FOREIGN KEY ( TYPE_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID );
ALTER TABLE SBI_UDP ADD FOREIGN KEY ( FAMILY_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID ) ;

CREATE SEQUENCE SBI_UDP_VALUE_SEQ INCREMENT 1 START  1 ;
CREATE TABLE SBI_UDP_VALUE (
	UDP_VALUE_ID       INTEGER DEFAULT nextval('SBI_UDP_SEQ') NOT NULL,
	UDP_ID			   INTEGER NOT NULL,
	VALUE              VARCHAR(1000) NOT NULL,
	PROG               INTEGER NULL,
	LABEL              VARCHAR(20) NULL,
	NAME               VARCHAR(40) NULL,
	FAMILY			   VARCHAR(40) NULL,
    BEGIN_TS           TIMESTAMP NOT NULL,
    END_TS             TIMESTAMP NULL,
    REFERENCE_ID	   INTEGER NULL,	
 PRIMARY KEY (UDP_VALUE_ID));
 
CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID);

ALTER TABLE SBI_UDP_VALUE ADD FOREIGN KEY ( UDP_ID ) REFERENCES SBI_UDP ( UDP_ID );

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');
INSERT INTO  SBI_ROLE_TYPE_USER_FUNC values((SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN'), (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'));
COMMIT;
--Monica: KPI RELATIONS
CREATE TABLE SBI_KPI_REL (
  KPI_REL_ID INTEGER DEFAULT nextval('SBI_KPI_REL_SEQ') NOT NULL,
  KPI_FATHER_ID INTEGER  NOT NULL,
  KPI_CHILD_ID INTEGER  NOT NULL,
  PARAMETER VARCHAR(100) NULL,
  PRIMARY KEY (KPI_REL_ID)
);

ALTER TABLE SBI_KPI_REL ADD FOREIGN KEY ( KPI_FATHER_ID ) REFERENCES SBI_KPI ( KPI_ID );
ALTER TABLE SBI_KPI_REL ADD FOREIGN KEY ( KPI_CHILD_ID ) REFERENCES SBI_KPI ( KPI_ID );

-- 28/09/2010 SbiKpiErrors
CREATE SEQUENCE SBI_KPI_ERROR_SEQ INCREMENT 1 START  1 ;

CREATE TABLE SBI_KPI_ERROR (
  KPI_ERROR_ID        INTEGER     DEFAULT nextval('SBI_KPI_ERROR') NOT NULL,
  KPI_MODEL_INST_ID   INTEGER NOT NULL,
  USER_MSG            VARCHAR(1000),
  FULL_MSG             TEXT,
  TS_DATE             TIMESTAMP ,
  LABEL_MOD_INST      VARCHAR(100) ,
  PARAMETERS	       VARCHAR(1000),
  PRIMARY KEY (KPI_ERROR_ID)) WITHOUT OIDS;
  
ALTER TABLE SBI_KPI_ERROR ADD FOREIGN KEY (KPI_MODEL_INST_ID) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST );  
--Delete old Attribute tables
DROP TABLE SBI_KPI_MODEL_ATTR_VAL;
DROP TABLE SBI_KPI_MODEL_ATTR;


--new column on SBI_KPI
ALTER TABLE SBI_KPI ADD COLUMN IS_ADDITIVE CHAR(1);

-- Organization Unit
CREATE TABLE SBI_ORG_UNIT (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(100) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT UNIQUE (LABEL, NAME),
  CONSTRAINT XPKSBI_ORG_UNIT PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ORG_UNIT_HIERARCHIES (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(200) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  TARGET     VARCHAR(1000),
  COMPANY    VARCHAR(100),
  CONSTRAINT XAK1SBI_ORG_UNIT_HIERARCHIES UNIQUE (LABEL, COMPANY),
  CONSTRAINT XPKSBI_ORG_UNIT_HIERARCHIES PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ORG_UNIT_NODES (
  NODE_ID            INTEGER NOT NULL,
  OU_ID           INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  PARENT_NODE_ID INTEGER NULL,
  PATH VARCHAR(4000) NOT NULL,
  CONSTRAINT XPKSBI_ORG_UNIT_NODES PRIMARY KEY(NODE_ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ORG_UNIT_GRANT (
  ID INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  START_DATE  DATE,
  END_DATE  DATE,
  LABEL            VARCHAR(200) NOT NULL,
  NAME             VARCHAR(400) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  CONSTRAINT XAK1SBI_ORG_UNIT_GRANT UNIQUE (LABEL),
  CONSTRAINT XPKSBI_ORG_UNIT_GRANT PRIMARY KEY(ID)
) WITHOUT OIDS;

CREATE TABLE SBI_ORG_UNIT_GRANT_NODES (
  NODE_ID INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  GRANT_ID INTEGER NOT NULL,
  CONSTRAINT XPKSBI_ORG_UNIT_GRANT_NODES PRIMARY KEY(NODE_ID, KPI_MODEL_INST_NODE_ID, GRANT_ID)
) WITHOUT OIDS;


ALTER TABLE SBI_ORG_UNIT_NODES ADD FOREIGN KEY ( OU_ID ) REFERENCES SBI_ORG_UNIT ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_NODES ADD FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_NODES ADD FOREIGN KEY ( PARENT_NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT ADD FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT ADD FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD FOREIGN KEY ( NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD FOREIGN KEY ( GRANT_ID ) REFERENCES SBI_ORG_UNIT_GRANT ( ID ) ON DELETE CASCADE;
 --MONICA 18/10/10: KPI OU
ALTER TABLE SBI_KPI_VALUE add COLUMN ORG_UNIT_ID integer;
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_3 FOREIGN KEY (ORG_UNIT_ID) REFERENCES SBI_ORG_UNIT (ID) ON DELETE CASCADE;

 --analytical drivers are visible by default
UPDATE SBI_OBJ_PAR SET VIEW_FL = 1;
COMMIT;

--MONICA  05/11/2010: BUG ON DUPLICATE ROLE NAMES
ALTER TABLE SBI_EXT_ROLES ALTER COLUMN NAME SET NOT NULL;
ALTER TABLE SBI_EXT_ROLES ADD CONSTRAINT XPGNAME UNIQUE (NAME);
--kpi_value added columns hierarchy_id and company
ALTER TABLE SBI_KPI_VALUE add COLUMN HIERARCHY_ID integer;
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_4 FOREIGN KEY (HIERARCHY_ID) REFERENCES SBI_ORG_UNIT_HIERARCHIES (ID) ON DELETE CASCADE;
ALTER TABLE SBI_KPI_VALUE add COLUMN COMPANY VARCHAR(200);

-- added url to external application in menu configuration
ALTER TABLE SBI_MENU ADD COLUMN EXT_APP_URL VARCHAR(1000);