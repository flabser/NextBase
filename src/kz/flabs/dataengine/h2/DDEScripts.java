package kz.flabs.dataengine.h2;

public class DDEScripts {

    public static String getMainDocsDDE() {
        String createString = "CREATE TABLE MAINDOCS(" +
                " DOCID INT generated by default as identity PRIMARY KEY, " +
                " AUTHOR varchar(32)," +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " REGDATE timestamp," +
                " DOCTYPE int, " +
                " LASTUPDATE timestamp, " +
                " VIEWTEXT varchar(2048), " +
                " VIEWICON varchar(16), " +
                " FORM varchar(32), " +
                " HAS_ATTACHMENT int, " +
                " HAS_RESPONSE int default 0, " +
                " DEFAULTRULEID varchar(32), " +
                " DEL int," +
                getViewTextFragment() +
                " SIGN varchar(6144)," +
                " TOPICID bigint, " +
                " DDBID varchar(16)," +
                " PARENTDOCDDBID varchar(16)," +
                " APPID varchar(16), " +
                " SIGNEDFIELDS varchar(1200)," +
                " FOREIGN KEY(TOPICID) REFERENCES TOPICS(DOCID) ON UPDATE CASCADE ON DELETE CASCADE)";
        return createString;
    }

    public static String getSyncDDE() {
        String createString = "CREATE TABLE SYNC " +
                "( " +
                " REGDATE timestamp, " +
                " NEXTTIME timestamp, " +
                " CUTOFTIME timestamp, " +
                " TRIGGER int, " +
                " DOCCOUNT int, " +
                " TYPE int, " +
                " ERRORCOUNT int, " +
                " DESCRIPTION varchar(1024)" +
                ")";
        return createString;
    }

    public static String getTopicsDDE() {
        String createString = "CREATE TABLE TOPICS( " +
                " DOCID int generated by default as identity primary key, " +
                " DOCTYPE int, " +
                " AUTHOR varchar(32), " +
                " THEME varchar(256), " +
                " CONTENT varchar(2048), " +
                " REGDATE timestamp, " +
                " SIGN varchar(1600), " +
                " SIGNEDFIELDS varchar(2048), " +
                " CITATIONINDEX int, " +
                " ISPUBLIC int, " +
                " STATUS int, " +
                " PARENTDOCID int, " +
                " PARENTDOCTYPE int, " +
                getViewTextFragment() +
                " DEFAULTRULEID varchar(32), " +
                " LASTUPDATE timestamp, " +
                " TOPICDATE timestamp, " +
                " DDBID varchar(16)," +
                " VIEWTEXT varchar(2048), " +
                " FORM varchar(32)) ";
        return createString;
    }

    public static String getForumTreePath() {
        String createString = "CREATE TABLE FORUM_TREE_PATH (" +
                " ANCESTOR BIGINT NOT NULL, " +
                " DESCENDANT BIGINT NOT NULL, " +
                " LENGTH int, " +
                " PRIMARY KEY(ANCESTOR, DESCENDANT), " +
                " FOREIGN KEY (ANCESTOR) REFERENCES POSTS(DOCID), " +
                " FOREIGN KEY (DESCENDANT) REFERENCES POSTS(DOCID))";
        return createString;
    }

    public static String getStructureView() {
        String createString = "create view structure as " +
                "select o.ddbid, o.viewtext from organizations o " +
                "union " +
                "select e.ddbid, e.viewtext from employers e " +
                "union " +
                "select d.ddbid, d.viewtext from departments d ";
        return createString;
    }

    public static String getStructureCollectionView() {
        return "create or replace view structurecollection as (\n" +
                "select 0 as empid, 0 as depid, o.orgid, o.orgid as docid, o.regdate, o.author, o.doctype, o.parentdocid, o.parentdoctype, o.viewtext, o.ddbid, o.form, o.fullname, o.shortname,     o.address,     o.defaultserver, o.comment, o.ismain, o.bin,  0 as hits, '' as indexnumber, 0 as rank, 0 as type,\n" +
                "'' as userid, 0 as post,  '' as phone, now() as birthdate, \n" +
                "o.viewtext1, o.viewtext2, o.viewtext3, o.viewtext4, o.viewtext5, o.viewtext6, o.viewtext7, o.viewnumber, o.viewdate from organizations o\n" +
                "union\n" +
                "select 0 as empid, d.depid, 0 as orgid, d.depid as docid, d.regdate, d.author, d.doctype, d.parentdocid, d.parentdoctype, d.viewtext, d.ddbid, d.form, d.fullname, d.shortname, '' as address, '' as defaultserver, d.comment, 0 as ismain, '' as bin, d.hits, d.indexnumber, d.rank, d.type, \n" +
                "'' as userid, 0 as post,  '' as phone, now() as birthdate, \n" +
                "d.viewtext1, d.viewtext2, d.viewtext3, d.viewtext4, d.viewtext5, d.viewtext6, d.viewtext7, d.viewnumber, d.viewdate from departments d\n" +
                "union \n" +
                "select e.empid, 0 as depid, 0 as orgid, e.empid as docid, e.regdate, e.author, e.doctype, e.parentdocid, e.parentdoctype, e.viewtext, e.ddbid, e.form, e.fullname, e.shortname, '' as address, '' as defaultserver, e.comment, 0 as ismain, '' as bin, e.hits, e.indexnumber, e.rank, 0 as type, \n" +
                "e.userid, e.post, e.phone, e.birthdate,  \n" +
                "e.viewtext1, e.viewtext2, e.viewtext3, e.viewtext4, e.viewtext5, e.viewtext6, e.viewtext7, e.viewnumber, e.viewdate from employers e\n" +
                ")\n";
    }

    public static String getStructureTreePath() {
        String createString = "CREATE TABLE STRUCTURE_TREE_PATH (" +
                " ANCESTOR VARCHAR(16) NOT NULL, " +
                " DESCENDANT VARCHAR(16) NOT NULL, " +
                " LENGTH int, " +
                " PRIMARY KEY(ANCESTOR, DESCENDANT))";
        return createString;
    }

    public static String getGlossaryTreePath() {
        String createString = "CREATE TABLE GLOSSARY_TREE_PATH (" +
                " ANCESTOR VARCHAR(16) NOT NULL, " +
                " DESCENDANT VARCHAR(16) NOT NULL, " +
                " LENGTH int, " +
                " PRIMARY KEY(ANCESTOR, DESCENDANT), " +
                " FOREIGN KEY (ANCESTOR) REFERENCES GLOSSARY(DDBID), " +
                " FOREIGN KEY (DESCENDANT) REFERENCES GLOSSARY(DDBID))";
        return createString;
    }

    public static String getPostsDDE() {
        String createString = "CREATE TABLE POSTS( " +
                " DOCID int generated by default as identity primary key, " +
                " DOCTYPE int, " +
                " AUTHOR varchar(32), " +
                " CONTENT varchar(2048), " +
                " REGDATE timestamp, " +
                " SIGN varchar(1600), " +
                " SIGNEDFIELDS varchar(2048), " +
                " CITATIONINDEX int, " +
                " ISPUBLIC int, " +
                " STATUS int, " +
                " PARENTDOCID int, " +
                " PARENTDOCTYPE int, " +
                getViewTextFragment() +
                " DEFAULTRULEID varchar(32), " +
                " POSTDATE timestamp, " +
                " LASTUPDATE timestamp, " +
                " VIEWTEXT varchar(2048), " +
                " DDBID varchar(16)," +
                " FORM varchar(32)) ";
        return createString;
    }

    public static String getPatchesDDE() {
        String dde = "create table PATCHES(" +
                " ID int generated by default as identity PRIMARY KEY, " +
                " PROCESSEDTIME timestamp, " +
                " HASH int, " +
                " DESCRIPTION varchar(512)," +
                " NAME varchar(64))";
        return dde;
    }

    public static String getFilterDDE() {
        String dde = "CREATE TABLE filter (id int generated by default as identity PRIMARY KEY, " +
                " userid varchar(128) NOT NULL, " +
                " name varchar(128) NOT NULL, " +
                " enable int not null, " +
                " CONSTRAINT filter_userid_fkey FOREIGN KEY (userid) " +
                " REFERENCES employers (userid))";
        return dde;
    }

    public static String getConditionDDE() {
        String dde = "CREATE TABLE condition ( fid integer not null, " +
                " name varchar(128) NOT NULL, " +
                " value varchar(256) NOT NULL, " +
                " CONSTRAINT condition_fid_fkey FOREIGN KEY (fid) " +
                " REFERENCES filter (id) ON DELETE CASCADE)";
        return dde;
    }

    public static String getTasksDDE() {
        String dde = "create table TASKS(" +
                "DOCID int generated by default as identity PRIMARY KEY," +
                " LASTUPDATE timestamp," +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " TASKAUTHOR varchar(64)," +
                " AUTHOR varchar(32)," +
                " REGDATE timestamp," +
                " TASKVN varchar(32)," +
                " TASKDATE timestamp," +
                " CONTENT varchar(2048)," +
                " COMMENT varchar(164)," +
                " CONTROLTYPE int," +
                " CTRLDATE timestamp," +
                " DBD int DEFAULT 0," +
                " CYCLECONTROL int," +
                " ALLCONTROL int," +
                " VIEWTEXT varchar(2048), " +
                " VIEWICON varchar(16), " +
                " FORM varchar(32), " +
                " DOCTYPE int," +
                " TASKTYPE int," +
                " ISOLD int, " +
                " HAS_ATTACHMENT int, " +
                " DEL int," +
                " PROJECT int," +
                " HAR int," +
                " DEFAULTRULEID varchar(32), " +
                " BRIEFCONTENT varchar(512), " +
                getViewTextFragment() +
                " SIGN varchar(1600)," +
                " APPS int, " +
                " CUSTOMER int, " +
                " TOPICID bigint, " +
                " DDBID varchar(16)," +
                " SIGNEDFIELDS varchar(1200)," +
                " CATEGORY int, " +
                " FOREIGN KEY(TOPICID) REFERENCES TOPICS(DOCID) ON UPDATE CASCADE ON DELETE CASCADE)";
        return dde;
    }

    public static String getTasksExecutorsDDE() {
        String dde = "create table TASKSEXECUTORS(ID int generated by default as identity PRIMARY KEY, " +
                " DOCID int," +
                " EXECUTOR varchar(256)," +
                " RESETDATE timestamp," +
                " RESETAUTHOR varchar(32)," +
                " COMMENT varchar(164), " +
                " RESPONSIBLE int, " +
                " EXECPERCENT int, " +
                " FOREIGN KEY (DOCID) REFERENCES TASKS(DOCID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getAuthorReadersDDE(String tableName, String mainTableNames, String docID) {
        String dde = "CREATE TABLE " + tableName +
                " (ID INT generated by default as identity PRIMARY KEY, " +
                " USERNAME VARCHAR(32)," +
                "DOCID INT, FAVORITES INT, FOREIGN KEY (DOCID) REFERENCES " + mainTableNames + "(" + docID + ") ON DELETE CASCADE," +
                "CONSTRAINT " + tableName.substring(0, 3) + "_" + mainTableNames + "_USR_UNIQUE UNIQUE (USERNAME, DOCID))";
        return dde;
    }

    public static String getIndexDDE(String tableName, String colName) {
        String dde = "CREATE INDEX " + tableName + "_" + colName + "_idx ON " + tableName + "(" + colName + ")";
        return dde;
    }

    public static String getProjecsDDE() {
        String dde = "create table PROJECTS(DOCID int generated by default as identity PRIMARY KEY," +
                " LASTUPDATE timestamp," +
                " AUTHOR varchar(32)," +
                " AUTOSENDAFTERSIGN SMALLINT," +
                " AUTOSENDTOSIGN SMALLINT," +
                " BRIEFCONTENT varchar(512)," +
                " CONTENTSOURCE clob(500M), " +
                " COORDSTATUS int," +
                " REGDATE timestamp," +
                " PROJECTDATE timestamp," +
                " VN varchar(16)," +
                " VNNUMBER int," +
                " DOCVERSION int," +
                " ISREJECTED int," +
                " RECIPIENT varchar(512)," +
                " DOCTYPE int, " +
                " VIEWTEXT varchar(2048), " +
                " VIEWICON varchar(16), " +
                " FORM varchar(32), " +
                " DOCFOLDER varchar(64)," +
                " DELIVERYTYPE varchar(64)," +
                " SENDER varchar(32), " +
                " NOMENTYPE int," +
                " HAS_ATTACHMENT int," +
                " DEL int," +
                " REGDOCID int," +
                " DEFAULTRULEID varchar(32), " +
                getViewTextFragment() +
                " HAR int, " +
                " PROJECT int, " +
                " SIGN varchar(1600)," +
                " SIGNEDFIELDS varchar(1200)," +
                " ORIGIN varchar(1024), " +
                " COORDINATS varchar(256), " +
                " CITY int, " +
                " STREET varchar(256), " +
                " HOUSE varchar(256), " +
                " PORCH varchar(256), " +
                " FLOOR varchar(256), " +
                " APARTMENT varchar(256), " +
                " RESPONSIBLE varchar(32), " +
                " CTRLDATE timestamp, " +
                " SUBCATEGORY int, " +
                " CONTRAGENT varchar(256), " +
                " PODRYAD varchar(256), " +
                " SUBPODRYAD varchar(256), " +
                " EXECUTOR varchar(32), " +
                " TOPICID bigint, " +
                " RESPOST varchar(256), " +
                " DDBID varchar(16)," +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " DBD int DEFAULT 0," +
                " CATEGORY INT, " +
                " AMOUNTDAMAGE VARCHAR(1024), " +
                " FOREIGN KEY(REGDOCID) REFERENCES MAINDOCS(DOCID) ON DELETE RESTRICT, " +
                " FOREIGN KEY(TOPICID) REFERENCES TOPICS(DOCID) ON UPDATE CASCADE ON DELETE CASCADE)";
        return dde;
    }

    public static String getExecutionsDDE() {
        String dde = "create table EXECUTIONS(DOCID int generated by default as identity PRIMARY KEY," +
                " LASTUPDATE timestamp," +
                " AUTHOR varchar(32)," +
                " REGDATE timestamp," +
                " EXECUTOR varchar(32)," +
                " REPORT varchar(2048)," +
                " FINISHDATE timestamp, " +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " VIEWTEXT varchar(2048), " +
                " VIEWICON varchar(16), " +
                " DOCTYPE int," +
                " FORM varchar(32), " +
                " SYNCSTATUS int, " +
                " NOMENTYPE int, " +
                " HAS_ATTACHMENT int, " +
                " DEFAULTRULEID varchar(32), " +
                " DEL int, " +
                getViewTextFragment() +
                " SIGN varchar(1600)," +
                " DDBID varchar(16)," +
                " SIGNEDFIELDS varchar(1200))";
        return dde;
    }

    public static String getCustomBlobsDDE(String mainTableName) {
        String dde = "create table CUSTOM_BLOBS_" + mainTableName + " (ID int generated by default as identity PRIMARY KEY, " +
                "DOCID int," +
                "NAME varchar(32)," +
                "TYPE int, " +
                "ORIGINALNAME varchar(128), " +
                "CHECKSUM varchar(40), " +
                "COMMENT varchar(256), " +
                "VALUE blob, " +
                "REGDATE timestamp, " +
                "FOREIGN KEY (DOCID) REFERENCES " + mainTableName + "(DOCID) ON DELETE CASCADE)";
        return dde;
    }


    public static String getCustomBlobsDDEForStruct(String mainTableName) {
        String dde = "create table CUSTOM_BLOBS_" + mainTableName + " (ID int generated by default as identity PRIMARY KEY, " +
                "DOCID int," +
                "NAME varchar(32)," +
                "TYPE int, " +
                "ORIGINALNAME varchar(128), " +
                "CHECKSUM varchar(40), " +
                "VALUE blob, " +
                "REGDATE timestamp, " +
                "FOREIGN KEY (DOCID) REFERENCES " + mainTableName + "(EMPID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getCustomFieldsDDE() {
        String dde = "create table CUSTOM_FIELDS(ID INT generated by default as identity PRIMARY KEY," +
                "DOCID int, " +
                "NAME varchar(32), " +
                "VALUE varchar(2048), " +
                "TYPE int, " +
                "VALUEASDATE timestamp, " +
                "VALUEASNUMBER numeric(19,4), " +
                "VALUEASGLOSSARY int, " +
                "VALUEASOBJECT clob(500M), " +
                "VALUEASCLOB clob(500M), " +
                "FOREIGN KEY (DOCID) REFERENCES MAINDOCS(DOCID) ON DELETE CASCADE, " +
                "FOREIGN KEY (VALUEASGLOSSARY) REFERENCES GLOSSARY(DOCID) ON DELETE RESTRICT, " +
                "CONSTRAINT CUSTOM_FIELDS_UIQ UNIQUE (DOCID, NAME, VALUE))";
        return dde;
    }

    public static String getCountersTableDDE() {
        String dde = "create table COUNTERS(ID int generated by default as identity PRIMARY KEY," +
                " KEYS varchar(32) CONSTRAINT COUNTERS_KEYS UNIQUE," +
                " LASTNUM int)";
        return dde;
    }

    public static String getGlossaryDDE() {
        String dde = "create table GLOSSARY(" +
                "DOCID INT generated by default as identity PRIMARY KEY, " +
                " AUTHOR varchar(32), " +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " REGDATE TIMESTAMP, " +
                " DOCTYPE int, " +
                " LASTUPDATE TIMESTAMP," +
                " VIEWTEXT varchar_ignorecase(512)," +
                " VIEWICON varchar(16), " +
                " FORM varchar(32), " +
                " RANK int, " +
                " SYNCSTATUS int," +
                " DEFAULTRULEID varchar(32), " +
                " DEL int, " +
                " HAS_ATTACHMENT int, " +
                getViewTextFragment() +
                " DDBID varchar(16)," +
                " PARENTDOCDDBID varchar(16)," +
                " APPID varchar(16), " +
                " TOPICID bigint, " +
                " SIGN varchar(1600), " +
                " SIGNEDFIELDS varchar(1200))";
        return dde;
    }

    public static String getCustomFieldGlossary() {
        String dde = "create table CUSTOM_FIELDS_GLOSSARY(" +
                " ID INT generated by default as identity PRIMARY KEY," +
                " DOCID int," +
                " NAME varchar(32)," +
                " VALUE varchar_ignorecase(512)," +
                " TYPE int," +
                " VALUEASDATE timestamp," +
                " VALUEASNUMBER numeric(19,4)," +
                " VALUEASGLOSSARY int," +
                " FOREIGN KEY (DOCID) REFERENCES GLOSSARY(DOCID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getProjectRecipientsDDE() {
        String dde = "CREATE TABLE PROJECTRECIPIENTS(" +
                " ID INT generated by default as identity PRIMARY KEY," +
                " DOCID int," +
                " RECIPIENT varchar(32)," +
                " FOREIGN KEY (DOCID) REFERENCES PROJECTS(DOCID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getCoordBlockDDE() {
        String dde = "CREATE TABLE COORDBLOCKS(" +
                " ID INT generated by default as identity PRIMARY KEY," +
                " DOCID int," +
                " TYPE int," +
                " DELAYTIME int," +
                " BLOCKNUMBER int," +
                " STATUS int," +
                " COORDATE timestamp, " +
                " FOREIGN KEY (DOCID) REFERENCES MAINDOCS(DOCID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getCoordinatorsDDE() {
        String dde = "create table COORDINATORS(" +
                " ID INT generated by default as identity PRIMARY KEY," +
                " BLOCKID int," +
                " COORDTYPE int," +
                " COORDINATOR varchar(256)," +
                " COORDNUMBER int," +
                " DECISION int," +
                " COMMENT varchar(164)," +
                " ISCURRENT int," +
                " DECISIONDATE timestamp," +
                " COORDATE timestamp," +
                " FOREIGN KEY (BLOCKID) REFERENCES COORDBLOCKS(ID) ON DELETE CASCADE)";
        return dde;
    }

    public static String getOrganizationDDE() {
        String dde = "create table ORGANIZATIONS(" +
                " ORGID INT generated by default as identity PRIMARY KEY," +
                getSystemFragment("ORG") +
                " FULLNAME varchar(256)," +
                " SHORTNAME varchar(48)," +
                " ADDRESS varchar(128)," +
                " DEFAULTSERVER varchar(128)," +
                " COMMENT varchar(164)," +
                " ISMAIN int," +
                " BIN varchar(12)," +
                getViewTextFragment() +
                " DEL int)";

        return dde;
    }

    public static String getDepartmentDDE() {
        String dde = "create table DEPARTMENTS(" +
                " DEPID INT generated by default as identity PRIMARY KEY," +
                " ORGID int," +
                " EMPID int," +
                " MAINID int," +
                getSystemFragment("DEP") +
                " FULLNAME varchar(128)," +
                " SHORTNAME varchar(64)," +
                " COMMENT varchar(164)," +
                " HITS int," +
                " INDEXNUMBER varchar(32)," +
                " RANK int," +
                " TYPE int," +
                " DEL int," +
                getViewTextFragment() +
                " FOREIGN KEY (ORGID) REFERENCES ORGANIZATIONS(ORGID) ON DELETE CASCADE," +
                " FOREIGN KEY (MAINID) REFERENCES DEPARTMENTS(DEPID) ON DELETE CASCADE," +
                " CHECK (ORGID IS NOT NULL OR EMPID IS NOT NULL OR MAINID IS NOT NULL))";
        return dde;
    }


    public static String getUserRolesDDE() {
        String dde = "CREATE TABLE USER_ROLES (" +
                " UID int generated by default as identity PRIMARY KEY," +
                " EMPID int NOT NULL," +
                " NAME varchar(64)," +
                " TYPE int NOT NULL," +
                " APPID varchar(256)," +
                " UNIQUE (EMPID, NAME, TYPE, APPID))";
        return dde;
    }

    public static String getEmployerDDE() {
        String dde = "create table EMPLOYERS(" +
                " EMPID INT generated by default as identity PRIMARY KEY," +
                " DEPID int," +
                " ORGID int," +
                " BOSSID int," +
                getSystemFragment("EMP") +
                " FULLNAME varchar(128)," +
                " SHORTNAME varchar(64)," +
                " USERID varchar(128) UNIQUE NOT NULL CHECK USERID NOT LIKE ''," +
                " COMMENT varchar(164)," +
                " RANK int," +
                " HITS int," +
                " HAS_ATTACHMENT int," +
                " POST int," +
                " ISBOSS int," +
                " INDEXNUMBER varchar(32)," +
                " PHONE varchar(128)," +
                " SENDTO int," +
                " DEL int," +
                " OBL int, " +
                " REGION int, " +
                " VILLAGE int, " +
                " BIRTHDATE timestamp, " +
                " STATUS int, " +
                getViewTextFragment() +
                " FOREIGN KEY (DEPID) REFERENCES DEPARTMENTS(DEPID) ON DELETE CASCADE," +
                " FOREIGN KEY (ORGID) REFERENCES ORGANIZATIONS(ORGID) ON DELETE CASCADE," +
                " FOREIGN KEY (BOSSID) REFERENCES EMPLOYERS(EMPID) ON DELETE CASCADE," +
                " FOREIGN KEY (POST) REFERENCES GLOSSARY(DOCID) ON DELETE RESTRICT," +
                " CHECK (DEPID IS NOT NULL OR ORGID IS NOT NULL OR BOSSID IS NOT NULL))";
        return dde;
    }

    public static String getDepartmentsAlternationDDE() {
        String dde = "alter table DEPARTMENTS" +
                " ADD FOREIGN KEY (EMPID) REFERENCES EMPLOYERS(EMPID) ON DELETE CASCADE";
        return dde;
    }


    public static String getAddAttachmentTriggerDDE(String mainTableName) {
        String dde = "CREATE TRIGGER set_att_flag_" + mainTableName +
                " AFTER INSERT ON CUSTOM_BLOBS_" + mainTableName +
                " FOR EACH ROW CALL \"kz.flabs.dataengine.h2.triggers.AttachmentCounter\"";
        return dde;
    }

    public static String getAddResponseTriggerDDE(String mainTableName) {
        return "CREATE TRIGGER set_resp_flag_" + mainTableName +
                " AFTER INSERT ON " + mainTableName +
                " FOR EACH ROW CALL \"kz.flabs.dataengine.h2.triggers.ResponseCounter\"";
    }

    public static String getRemoveAttachmentTriggerDDE(String mainTableName) {
        String dde = "CREATE TRIGGER remove_att_flag_" + mainTableName +
                " AFTER DELETE ON CUSTOM_BLOBS_" + mainTableName +
                " FOR EACH ROW CALL \"kz.flabs.dataengine.h2.triggers.AttachmentCounter\"";
        return dde;
    }

    public static String getRemoveResponseTriggerDDE(String mainTableName) {
        return "CREATE TRIGGER remove_resp_flag_" + mainTableName +
                " AFTER DELETE ON " + mainTableName +
                " FOR EACH ROW CALL \"kz.flabs.dataengine.h2.triggers.ResponseCounter\"";
    }

    public static String getDBVersionTableDDE() {
        String dde = "create table DBVERSION(DOCID int generated by default as identity PRIMARY KEY, " +
                "OLDVERSION int, " +
                "VERSION int, " +
                "UPDATEDATE timestamp)";
        return dde;
    }

    private static String getSystemFragment(String constraintNamePrefix) {
        return " AUTHOR varchar(32)," +
                " REGDATE timestamp," +
                " DOCTYPE int, " +
                " LASTUPDATE timestamp, " +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " VIEWTEXT varchar(512), " +
                " VIEWICON varchar(16), " +
                " DDBID varchar(16), " +
                " FORM varchar(32), " +
                " SYNCSTATUS int, ";
    }

    private static String getViewTextFragment() {
        return  " VIEWTEXT1 varchar(256)," +
                " VIEWTEXT2 varchar(256)," +
                " VIEWTEXT3 varchar(256)," +
                " VIEWTEXT4 varchar(128)," +
                " VIEWTEXT5 varchar(128)," +
                " VIEWTEXT6 varchar(128)," +
                " VIEWTEXT7 varchar(128)," +
                " VIEWNUMBER numeric(19,4)," +
                " VIEWDATE timestamp, ";
    }

    public static String getGroupsDDE() {
        String dde = "create table GROUPS(GROUPID int generated by default as identity PRIMARY KEY, " +
                " GROUPNAME varchar(32) UNIQUE NOT NULL, " +
                " FORM varchar(32), " +
                " DESCRIPTION varchar(256), " +
                " OWNER varchar(32), " +
                " TYPE int," +
                " PARENTDOCID int," +
                " PARENTDOCTYPE int," +
                " VIEWTEXT varchar(2048), " +
                getViewTextFragment() +
                " DEFAULTRULEID varchar(32))";
        return dde;
    }

    public static String getUserGroupsDDE() {
        String dde = "create table USER_GROUPS(UID int generated by default as identity PRIMARY KEY, " +
                " EMPID int NOT NULL," +
                " GROUPID int NOT NULL," +
                " TYPE int," +
                " UNIQUE (EMPID, GROUPID))";
        return dde;
    }


}
