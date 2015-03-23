package handler.importContractor

import kz.flabs.dataengine.Const
import kz.nextbase.script._Glossary
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler

class Trigger extends _DoHandler {

    public void doHandler(_Session session, Map<String, String[]> formData, String lang) {
        try {
            println "Начинаю импорт контрагентов..."

            File file = new File(new File("").getAbsolutePath() + "\\контрагенты.xml")
            def xmldoc = new XmlParser().parse(file) //.parse("C:\\Users\\User1\\Desktop\\контрагенты.xml")

            println xmldoc.name()
            def cdb = session.getCurrentDatabase();
            def gl = null;
            def newgl = null;
            int count = 0;
            int k = 0;
            // tag counteragent
            println(xmldoc.children().size())
            xmldoc.children().each {
                String rnn = it.find { it.name() == 'RNN' }.text()

                def strfield = { fieldname -> it.find { it.name().toLowerCase() == fieldname }.text() }

                gl = cdb.getGlossaryDocs("contractor", "rnn='$rnn'")
                String author = session.getUser().getUserID();

                if (gl.size() == 0) {
                    newgl = new _Glossary(cdb)
                    newgl.setName(strfield("name"))
                    newgl.addStringField("email", strfield("email"))
                    newgl.addStringField("rnn", strfield("rnn"))
                    newgl.addStringField("bin", strfield("bin"))
                    newgl.setCode(strfield("code"))

                    newgl.setViewText(strfield("name"))
                    newgl.setForm("contractor")
                    newgl.setDefaultRuleID("contractor")
                    newgl.save(Const.sysUser)
                    count++;
                } else {
                    k++;
                }
            }
            println "$count contragents were saved\n $k contragents already exist"
        } catch (Exception e) {
            println("Hey, here is error: ");
            e.printStackTrace();
        }
    }

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		// TODO Auto-generated method stub
		
	}
}
