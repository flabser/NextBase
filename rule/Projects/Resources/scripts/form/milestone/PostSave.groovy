package form.milestone

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script.events._FormPostSave;

class PostSave extends _FormPostSave{

    @Override
    public void doPostSave(_Session ses, _Document doc) {

        def pdoc = doc.getParentDocument();

        // Позиция - Текущая
        String current = doc.getValueString("current");
        if(current == "on"){
            // ищем других вех со знаком "Текущая"
            for(def d in pdoc.getDescendants()){
                if(d.getDocID() != doc.getDocID()){
                    if(d.getValueString("current") == "on"){
                        d.setValueString("current", "");
                        d.save("[observer]")
                    }
                }
            }
        }
        // Уведомление отправляем всем ответств. лицам проекта
        String description = doc.getValueString("description");
        String docauthor = doc.getValueString('docauthor');

        String manager = pdoc.getValueString("manager");
        String tester =  pdoc.getValueString("tester");
        String programmer =  pdoc.getValueString("programmer");
        def observers = pdoc.getValueList("observer");
        for (String observer: observers) {
            if(observer != ''){
                doc.addReader(observer);
            }
        }
        String pauthor =  pdoc.getValueString("docauthor");

        String pname = pdoc.getValueString("project_name");

        if(doc.getValueString('mailnotification') == ""){

            def msngAgent = ses.getInstMessengerAgent()
            def struct = ses.getStructure()
            def ma = ses.getMailAgent();

            // Уведомление о новой вехе
            String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новой вехе к проекту '+ pname +'</font></b><hr>'
            body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
            body += '<tr>'
            //Проект
            body += '<td width="210px">Новая веха к проекту: </td><td><b>'+pname+'</b></td>'
            body += "</tr><tr>";
            //Описание
            body += '<td width="210px">Описание: </td><td><b>'+description+'</b></td>'
            body += "</tr><tr></table>";
            body += '<p><font size="2" face="Arial">Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

            String xmppmsg = "Уведомление о новой вехе к проекту "+ pname +"\n";
            xmppmsg += "Новая веха к проекту: " + pname;
            xmppmsg += "\nОписание: " + description + "\n";
            xmppmsg += doc.getFullURL();

            // Отправляем сообщение менеджеру
            if( manager != docauthor){
                def emp = struct.getUser(manager);
                def recipient = [emp?.getEmail()]

                ma.sendMail(recipient, "Уведомление о новой вехе", body);
                msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg);

            }
            // Отправляем сообщение тестеру
            if( tester != docauthor){

                def emp = struct.getUser(tester);
                def recipient = [emp?.getEmail()]

                ma.sendMail(recipient, "Уведомление о новой вехе", body);
                msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg);
            }
            // Отправляем сообщение тестеру
            if( programmer != docauthor){

                def emp = struct.getUser(programmer);
                def recipient = [emp?.getEmail()]

                ma.sendMail(recipient, "Уведомление о новой вехе", body);
                msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg);
            }
            // Отправляем сообщение автору проекта
            if( pauthor != docauthor){

                def emp = struct.getUser(pauthor);
                def recipient = [emp?.getEmail()]

                ma.sendMail(recipient, "Уведомление о новой вехе", body);
                msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg);
            }

            doc.addStringField("mailnotification", "sent")
            doc.save();
        }
    }

}
