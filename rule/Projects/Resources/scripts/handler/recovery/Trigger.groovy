package handler.recovery

import kz.flabs.appenv.AppEnv
import kz.flabs.dataengine.postgresql.Database
import kz.flabs.scriptprocessor.form.querysave.IQuerySaveTransaction
import kz.flabs.users.User
import kz.flabs.users.UserSession
import kz.flabs.util.Util
import kz.flabs.util.XMLUtil
import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler
import kz.nextbase.script.events._FormQuerySave
import kz.pchelka.env.Environment
import kz.pchelka.log.JavaConsoleLogger
import kz.pchelka.log.Log4jLogger
import kz.pchelka.scheduler.IProcessInitiator
import org.apache.commons.beanutils.converters.ClassConverter
import org.w3c.dom.Document
import org.w3c.dom.Node
import org.w3c.dom.NodeList

class Trigger extends _DoHandler implements IProcessInitiator{
    @Override
    void doHandler(_Session session, _WebFormData formData) {
        File dir = new File("." + File.separator + "backup");
        File[] listDir = dir.listFiles();
        for (File i : listDir) {
            if (i.isDirectory() && i.name.startsWith("Backup_")) {
                File[] listDirDocs = i.listFiles();
                for (File j : listDirDocs) {
                    if (j.isDirectory() && new File(j.absolutePath + File.separator + "Doc.xml").exists()) {
                        parseFile(i, j, session);
                    }
                }
            }
        }

        int faultDocsCount = 0;
        Iterator col = linkOldNew.iterator();
        while (col.hasNext()) {
            if(((MapEntry)col.next()).getValue() < 0)
                faultDocsCount++;
        }
        System.out.println("fault docs count = " + faultDocsCount);
    }

    public static HashMap<Integer, Integer> linkOldNew = new HashMap<Integer, Integer>();

    public static int parseFile(File parentDir, File dir, _Session session) {
        String docid = dir.name.substring(4, dir.name.length());
        if(linkOldNew.containsKey(Integer.parseInt(docid)))
            return linkOldNew.get(Integer.parseInt(docid));

        if(!dir.exists() || !parentDir.exists()){
            System.err.println("FILE " + dir.absolutePath + " NOT EXIST");
            linkOldNew.put(Integer.parseInt(docid), -1);
            return -1;
        }

        try {

            def doc =  new _Document(session.getCurrentDatabase());

            Document xmlDoc = XMLUtil.getDOMDocument(dir.absolutePath + File.separator + "Doc.xml");


            if(!XMLUtil.getTextContent(xmlDoc, "document/@parentdocid").trim().equals("0")){
                int parentDocId = parseFile(parentDir, new File(parentDir.absolutePath + File.separator + "doc_" + XMLUtil.getTextContent(xmlDoc, "document/@parentdocid").trim()), session);
                if(parentDocId < 0){
                    System.err.println("PARENT DOCUMENT DOES NOT EXIST FOR DOC " + docid);
                    linkOldNew.put(Integer.parseInt(docid), -1);
                    return -1;
                }
                doc.setParentDocID(parentDocId);
            }

            doc.setForm(XMLUtil.getTextContent(xmlDoc, "document/@form"));
            doc.setViewText(XMLUtil.getTextContent(xmlDoc, "document/@viewtext"));
             doc.setAuthor(XMLUtil.getTextContent(xmlDoc, "document/@author"));

            Node node = XMLUtil.getNode(xmlDoc, "document", false);
            node.getChildNodes().each { Node k ->
                switch (k.nodeName.trim()) {
                    case "#text":
                        break;
                    case "readers":
                        NodeList dbList = XMLUtil.getNodeList(k, "user");
                        for (int a = 0; a < dbList.getLength(); a++) {
                            doc.addReader(dbList.item(a).textContent);
                        }

                        break;
                    case "editors":
                        NodeList dbList = XMLUtil.getNodeList(k, "user");
                        for (int a = 0; a < dbList.getLength(); a++) {
                            doc.addEditor(dbList.item(a).textContent);
                        }
                        break;
                    default:
                        switch(XMLUtil.getTextContent(k, "@type")){
                            case "map":
                                String[] values = k.textContent.split("#");
                                for(String value : values)
                                    if(value != null && value.trim().length() != 0)
                                        doc.addValueToList(k.nodeName.trim(), value);
                                break;
                            case "datetime":
                                doc.addDateField(k.nodeName.trim(), _Helper.convertStringToDate(k.textContent));
                                break;
                            case "string":
                                doc.addStringField(k.nodeName.trim(), k.textContent);
                                break;
                            case "number":
                                doc.addNumberField(k.nodeName.trim(), k.textContent);
                                break;
                            case "files":
                                break; //нет необходимости обрабатывать
                            case "":
                                doc.addStringField(k.nodeName.trim(), k.textContent);
                                break;
                            default:
                                System.out.println("unknown type " + XMLUtil.getTextContent(k, "@type") + " on doc " + docid);
                                break;
                        }
                        break;
                }
            }

            File[] attachments = dir.listFiles(new FileFilter() {
                @Override
                boolean accept(File file) {
                    return file.isDirectory();
                }
            });

            for (File k : attachments) {
                if (k.listFiles().length > 0) {
                    File f = k.listFiles()[0];
                    doc.addAttachment("rtfcontent", f);
                }
            }
//
//            def qsave = (_FormQuerySave)Class.forName("form." + doc.getForm()[0] + ".QuerySave");
//            qsave.setCurrentLang(session.getVocabulary(), "RUS");
//            qsave.doQuerySave(session, doc)
            doc.save("[supervisor]");
            linkOldNew.put(Integer.parseInt(docid), doc.getDocID());
        } catch (Exception e) {
            System.err.println("Exception on " + dir.absolutePath + File.separator + "Doc.xml");
            e.printStackTrace();
            linkOldNew.put(Integer.parseInt(docid), -1);
            return -1;
        }
        return linkOldNew.get(Integer.parseInt(docid));
    }

    def initNBEnvironment(String userId) {
        Environment.systemBase = new kz.flabs.dataengine.h2.SystemDatabase()
        Environment.logger = new Log4jLogger(this.getClass().getName());
        AppEnv.logger = new JavaConsoleLogger()
        def env = new AppEnv("Projects", "global.xml")
        def dataBase = new Database(env)
        env.setDataBase(dataBase)
        def user = new User(userId, env)
        def session = new UserSession(user)
        user.setSession(session)
        return new _Session(env, user, this)
    }

    static main(args) {
        Trigger t = new Trigger();
        def session = (_Session) t.initNBEnvironment("[observer]");
        session.getCurrentDatabase().setTransConveyor( new ArrayList<IQuerySaveTransaction>());
        t.doHandler(session, null);
    }


    @Override
    public String getOwnerID() {
        return this.getClass().getName();
    }

}

