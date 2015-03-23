package page.mailToManager

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

/**
 * Created by Bekzat on 2/13/14.
 */
class DoScript extends _DoScript{

    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {
//        println(formData)

        def isSent = true;
        try{
            def cdb = session.getCurrentDatabase();
            def mailAgent = session.getMailAgent();
            def project = cdb.getDocumentByID(formData.getValue("projectid"));
            def manager = project.getValueString("manager");
            def manager_email = session.getStructure().getEmployer(manager).getEmail();

            String body = "<b>Проект: </b>" + project.getValueString("project_name");
            body += "\n<b>Автор: </b> " + session.getCurrentAppUser().getFullName();
            body += "\n<b>Тема: </b> " +  new String(formData.getValueSilently("topic").getBytes("ISO-8859-1"), "UTF-8");
            body += "\n" + new String(formData.getValueSilently("text").getBytes("ISO-8859-1"), "UTF-8");
            println(body)
            isSent = mailAgent.sendMail([manager_email], "MySupport: Вам письмо от заказчика", body);
        }catch (Exception e){
            isSent = false;
            log(e.toString()) ;
        }finally{
            def rootTag = new _Tag("mailresult");
            rootTag.setAttr("sent", isSent);
            setContent(new _XMLDocument(rootTag));
        }
    }
}
