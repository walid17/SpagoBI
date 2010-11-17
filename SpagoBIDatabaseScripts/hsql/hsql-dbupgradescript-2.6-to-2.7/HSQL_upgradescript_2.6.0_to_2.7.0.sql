--Chiara 28/08/2010
CREATE MEMORY TABLE SBI_KPI_DOCUMENTS(ID_KPI_DOC INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,BIOBJ_ID INTEGER NOT NULL,KPI_ID INTEGER NOT NULL,CONSTRAINT SBI_KPI_DOCUMENTS_IBFK_1 FOREIGN KEY(BIOBJ_ID) REFERENCES SBI_OBJECTS(BIOBJ_ID),CONSTRAINT SBI_KPI_DOCUMENTS_IBFK_2 FOREIGN KEY(KPI_ID) REFERENCES SBI_KPI(KPI_ID))

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 08/09/2010: generic user data properties management
CREATE MEMORY TABLE SBI_UDP (UDP_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY, TYPE_ID INTEGER NOT NULL, FAMILY_ID INTEGER NOT NULL, LABEL VARCHAR NOT NULL, NAME VARCHAR NOT NULL, DESCRIPTION VARCHAR NULL,	IS_MULTIVALUE BOOLEAN DEFAULT FALSE, CONSTRAINT FK_SBI_SBI_UDP_1 FOREIGN KEY(TYPE_ID) REFERENCES SBI_DOMAINS(VALUE_ID),	CONSTRAINT FK_SBI_SBI_UDP_2 FOREIGN KEY(FAMILY_ID) REFERENCES SBI_DOMAINS(VALUE_ID));
 
CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL);
CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID);
CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID);
 
CREATE MEMORY TABLE SBI_UDP_VALUE (UDP_VALUE_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,UDP_ID INTEGER NOT NULL, VALUE VARCHAR NOT NULL, PROG INTEGER NULL, LABEL VARCHAR NOT NULL,	NAME VARCHAR NULL, FAMILY VARCHAR NULL, BEGIN_TS TIMESTAMP NOT NULL, END_TS TIMESTAMP NULL, REFERENCE_ID INTEGER NULL, CONSTRAINT FK_SBI_UDP_VALUE_1 FOREIGN KEY(UDP_ID) REFERENCES SBI_UDP(UDP_ID));
 
CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID);

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');
INSERT INTO  SBI_ROLE_TYPE_USER_FUNC values((SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN'), (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'))
COMMIT;


CREATE MEMORY TABLE SBI_KPI_REL (KPI_REL_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,KPI_FATHER_ID INTEGER NOT NULL, KPI_CHILD_ID INTEGER NOT NULL, PARAMETER VARCHAR NULL, CONSTRAINT FK_SBI_KPI_REL_1 FOREIGN KEY(KPI_CHILD_ID) REFERENCES SBI_KPI(KPI_ID), CONSTRAINT FK_SBI_KPI_REL_2 FOREIGN KEY(KPI_FATHER_ID) REFERENCES SBI_KPI(KPI_ID));
CREATE MEMORY TABLE SBI_KPI_ERROR(KPI_ERROR_ID INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,KPI_MODEL_INST_ID INTEGER NOT NULL,USER_MSG VARCHAR(1000) DEFAULT NULL,FULL_MSG VARCHAR DEFAULT NULL,TS_DATE TIMESTAMP DEFAULT NULL, LABEL_MOD_INST VARCHAR(100) DEFAULT NULL,PARAMETERS VARCHAR(1000),CONSTRAINT FK_SBI_KPI_ERROR_MODEL_1 FOREIGN KEY(KPI_MODEL_INST_ID) REFERENCES SBI_KPI_MODEL_INST(KPI_MODEL_INST))


--Delete old Attribute tables
DROP TABLE SBI_KPI_MODEL_ATTR_VAL;
DROP TABLE SBI_KPI_MODEL_ATTR;

-- Organization Unit
CREATE MEMORY TABLE SBI_ORG_UNIT (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(100) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  UNIQUE (LABEL, NAME),
  PRIMARY KEY (ID)
);

CREATE MEMORY TABLE SBI_ORG_UNIT_HIERARCHIES (
  ID            INTEGER NOT NULL,
  LABEL            VARCHAR(100) NOT NULL,
  NAME             VARCHAR(200) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  TARGET     VARCHAR(1000),
  COMPANY    VARCHAR(100),
  UNIQUE (LABEL, COMPANY),
  PRIMARY KEY (ID)
);

CREATE MEMORY TABLE SBI_ORG_UNIT_NODES (
  NODE_ID            INTEGER NOT NULL,
  OU_ID           INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  PARENT_NODE_ID INTEGER NULL,
  PATH VARCHAR(4000) NOT NULL,
  PRIMARY KEY (NODE_ID)
);

CREATE MEMORY TABLE SBI_ORG_UNIT_GRANT (
  ID INTEGER NOT NULL,
  HIERARCHY_ID  INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  START_DATE  DATE,
  END_DATE  DATE,
  LABEL            VARCHAR(200) NOT NULL,
  NAME             VARCHAR(400) NOT NULL,
  DESCRIPTION      VARCHAR(1000),
  UNIQUE (LABEL),
  PRIMARY KEY (ID)
);

CREATE MEMORY TABLE SBI_ORG_UNIT_GRANT_NODES (
  NODE_ID INTEGER NOT NULL,
  KPI_MODEL_INST_NODE_ID INTEGER NOT NULL,
  GRANT_ID INTEGER NOT NULL,
  PRIMARY KEY (NODE_ID, KPI_MODEL_INST_NODE_ID, GRANT_ID)
);

ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_1 FOREIGN KEY ( OU_ID ) REFERENCES SBI_ORG_UNIT ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_NODES_3 FOREIGN KEY ( PARENT_NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_2 FOREIGN KEY ( HIERARCHY_ID ) REFERENCES SBI_ORG_UNIT_HIERARCHIES ( ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_3 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_1 FOREIGN KEY ( NODE_ID ) REFERENCES SBI_ORG_UNIT_NODES ( NODE_ID ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_2 FOREIGN KEY ( KPI_MODEL_INST_NODE_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE CASCADE;
ALTER TABLE SBI_ORG_UNIT_GRANT_NODES ADD CONSTRAINT FK_SBI_ORG_UNIT_GRANT_NODES_3 FOREIGN KEY ( GRANT_ID ) REFERENCES SBI_ORG_UNIT_GRANT ( ID ) ON DELETE CASCADE;


--new column on SBI_KPI
ALTER TABLE SBI_KPI ADD COLUMN IS_ADDITIVE CHAR(1);

--Add column org_unit_id
ALTER TABLE SBI_KPI_VALUE add COLUMN ORG_UNIT_ID integer;
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_3 FOREIGN KEY (ORG_UNIT_ID) REFERENCES SBI_ORG_UNIT (ID) ON DELETE CASCADE;
--analytical drivers are visible by default
UPDATE SBI_OBJ_PAR SET VIEW_FL = 1;
COMMIT;
--BUG ON DUPLICATE ROLE NAMES
ALTER TABLE SBI_EXT_ROLES ALTER COLUMN NAME SET NOT NULL; 
ALTER TABLE SBI_EXT_ROLES ADD CONSTRAINT XHANAME UNIQUE (NAME);
 --KPI ENGINE : added hierarchy as parameter to filter grants
 --added company 
ALTER TABLE SBI_KPI_VALUE add COLUMN HIERARCHY_ID integer;
ALTER TABLE SBI_KPI_VALUE ADD CONSTRAINT FK_SBI_KPI_VALUE_4 FOREIGN KEY (HIERARCHY_ID) REFERENCES SBI_ORG_UNIT_HIERARCHIES (ID) ON DELETE CASCADE;
ALTER TABLE SBI_KPI_VALUE add COLUMN COMPANY VARCHAR(200);

-- added url to external application in menu configuration
ALTER TABLE SBI_MENU ADD COLUMN EXT_APP_URL VARCHAR(1000);