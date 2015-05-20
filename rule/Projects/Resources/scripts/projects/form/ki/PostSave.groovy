package projects.form.ki

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script.events._FormPostSave;

class PostSave extends _FormPostSave {

    @Override
    public void doPostSave(_Session ses, _Document doc) {
        try {
            // Почтовое уведомление
            def observers = doc.getGrandParentDocument().getValueList("observer");
            for (String observer : observers) {
                doc.addReader(observer);
            }
            String url = doc.getFullURL()
            def gpdoc = doc.getGrandParentDocument();
            String author = doc.getAuthorID()
            def struct = ses.getStructure()
            def authoremp = struct.getEmployer(author)
            String briefcontent = doc.getValueString("report")
            String authorsMsg = "Вы получили данное уведомление как автор"

            def pdoc = doc.getParentDocument()
            String dauthor = pdoc.getAuthorID();
            def pauthoremp = struct.getEmployer(dauthor)

            // добавляем авторов головных заявок в читатели
            def perentdemands = pdoc;
            while(perentdemands.getDocumentForm() != "milestone") {
                if(perentdemands.getDocumentForm() == "demand"){
                    doc.addReader(perentdemands.getAuthorID());
                }
                perentdemands = perentdemands.getParentDocument();
            }


            String vn = pdoc.getValueString("vn")
            if (vn == '') {
                vn = gpdoc.getValueString("vn")
            }
            String bcontent = pdoc.getValueString("briefcontent")

            String dvn = pdoc.getValueString("dvn")
            if (dvn == '') {
                dvn = gpdoc.getValueString("dvn")
            }
            if (author != dauthor) {
                //Уведомление об исполнении
                String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление об исполнении</font></b><hr>';
                body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
                body += '<tr>';
                //К Вам уведомление об исполнении по документу
                body += '<td width="210px" valign="top">К Вам уведомление об исполнении по документу:</td>';
                //от
                body += '<td width="400px" valign="top"><b>' + vn + ' от ' + dvn + '</b></td>';
                body += '</tr><tr>';
                //Проект
                body += '<td>Проект :</font></td><td><b>' + doc.getGrandParentDocument().getValueString("project_name") + '</b></td>'
                body += '</tr><tr>'

                //Исполнитель
                body += '<td>Исполнитель:</font></td>';
                body += '<td><b>' + authoremp.getShortName() + '</b></td>';
                body += '</tr><tr>';
                //Дата исполнения
                body += '<td>Дата исполнения:</font></td>';
                body += '<td><b>' + doc.getValueString("docdate") + '</b></td>';
                body += '</tr><tr>';
                //Содержание
                body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>';
                body += '<td style="border-top:1px solid #CCC;" valign="top">' + briefcontent + '</td>';
                body += '</tr><tr>';
                // Краткое содержание заявки
                body += '<td style="border-top:1px solid #CCC;" valign="top">Краткое содержание заявки:</td>';
                body += '<td style="border-top:1px solid #CCC;" valign="top">' + bcontent + '</td>';
                body += '</tr></table>';
                //Для работы с документом, перейдите по этой ссылке
                body += '<p><font size="2" face="Arial">Для работы с документом, перейдите по ссылке <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>';

                briefcontent = briefcontent.replaceAll("\n", " ");

                String xmppmsg = "К Вам уведомление об исполнении по документу: " + vn + " от " + dvn + "\n"
                xmppmsg += "Краткое содержание заявки: " + bcontent + "\n";
                xmppmsg += "Исполнитель: " + authoremp.getShortName() + " \n"
                xmppmsg += doc.getFullURL() + "\n"
                xmppmsg += authorsMsg

                def recipients = [pauthoremp.getEmail()];
                def ma = ses.getMailAgent();
                def msngAgent = ses.getInstMessengerAgent()

                ma.sendMail(recipients, doc.getGrandParentDocument().getValueString("project_name") + ': уведомление об исполнении по заявке ' + vn + ' (' + authoremp.getShortName() + ') / ' + briefcontent, body);
                msngAgent.sendMessage([pauthoremp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg)
                body += '<div width="100%"><font size="1" face="Arial" color="#444444">Вы получили данное уведомление как наблюдатель проекта<font></div>';
                for (String observer : observers) {
                    def memberrecipient = [struct.getEmployer(observer)?.getEmail()];
                    if (struct.getEmployer(observer).getUserID() != dauthor && struct.getEmployer(observer).getUserID() != author) {
                        ma.sendMail(memberrecipient, doc.getGrandParentDocument().getValueString("project_name") + ': уведомление об исполнении по заявке ' + vn + ' (' + authoremp.getShortName() + ') / ' + briefcontent, body);
                    }
                }
            }
            doc.addStringField("mailnotification", "sent")
            doc.save("[supervisor]")
        }
        catch (Exception ex) {
            ex.printStackTrace()
        }

    }

}
