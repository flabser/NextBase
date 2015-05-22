package projects.form.demand

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script.events._FormPostSave
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Control

class PostSave extends _FormPostSave{
    public void doPostSave(_Session ses, _Document doc) {
        def struct = ses.getStructure();
        doc.clearEditors();
        def parentProject = doc.getGrandParentDocument();
        def observers = parentProject.getValueList("observer");
        for (String observer: observers) {
            doc.addReader(observer);
        }

        def author = doc.authorID;
        def control = (_Control) doc.getValueObject("control")
		def executers = doc.getValueList('executer');
		def executers_shortname = new ArrayList();
		for (String executer: executers) {
			//doc.addReader(executer);
			executers_shortname.add(struct.getEmployer(executer).shortName)
		}
        // добавить исполнителя в читатели головных документов
        def parentDoc = doc.getParentDocument();

        while (parentDoc != null){
            parentDoc.addReaders(executers);
            parentDoc.save("[supervisor]")
            doc.addReader(parentDoc.getAuthorID())
            parentDoc = parentDoc.getParentDocument();
        }

        doc.addReader(author);

        // если статус заявки - не Awaiting
        if(control.getAllControl() != 3)
            doc.addReaders(executers);

        /*   кажется это строка тоже лишняя
        if( doc.getValueString("allcontrol") == 'reset' ){
            doc.addViewText("reset")
            doc.setValueString("datedisp", _Helper.getDateAsString(new Date()))
        }
        */
		doc.save("[supervisor]")

        def ma = ses.getMailAgent();
        def msngAgent = ses.getInstMessengerAgent();
        // Почтовое уведомление
       // if(( doc.getValueString("mailnotification") == '' )){
        String briefcontent = doc.getValueString("briefcontent")
        //Уведомление о новом задании
        String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новом задании</font></b><hr>'
        body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
        body += '<tr>'
        //К Вам документ на исполнение
        body += '<td width="210px">Документ на исполнение:</td>'
        //от
        body += '<td width="500px"><b>'+doc.getValueString("vn")+' от '+ doc.getRegDate().format("dd.MM.yyyy") +'</b></td>'
        body += '</tr><tr>'
        //Проект
        body += '<td>Проект :</font></td><td><b>'+ doc.getGrandParentDocument().getValueString("project_name")+'</b></td>'
        body += '</tr><tr>'
        //Автор
        body += '<td>Автор:</font></td><td><b>'+struct.getEmployer(author).getShortName()+'</b></td>'
        body += '</tr><tr>'
        //Исполнитель
        body += '<td>Исполнители:</font></td><td><b>'+ executers_shortname.join(", ") +'</b></td>'
        body += '</tr><tr>'
        //Срок исполнения
        body += '<td>Срок исполнения:</font></td><td><b>'+control.getCtrlDate().format("dd.MM.yyyy")+'</b></td>'
        body += '</tr><tr>'
        //Содержание
        body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
        body += '<td style="border-top:1px solid #CCC;" valign="top">'+ _Helper.removeHTMLTags(briefcontent) +'</td>'
        body += '</tr></table>'
        //Для работы с документом, перейдите по этой ссылке
        body += '<p><font size="2" face="Arial">Для работы с документом перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

        briefcontent = _Helper.removeHTMLTags(briefcontent.replaceAll("\n", " "))

        if(control.getAllControl() != 3){
            for (String executer: executers) {
                if(!author.equals(executer)){
                    def emp = struct.getEmployer(executer)
                    String xmppmsg = "Уведомление о новом задании\n"
                    xmppmsg += "К Вам документ на исполнение: " + doc.getValueString("vn") + " от " + doc.getValueString("dvn") + "\n"
                    //xmppmsg += "Исполнитель: " + emp.getShortName() + " \n"
                    xmppmsg += "Срок исполнения: " + doc.getValueString("ctrldate") + "\n"
                    xmppmsg += doc.getFullURL()

                    def recipients = [emp?.getEmail()]
                    def recipients_memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ": документ ${doc.getValueString('vn')} на исполнение. ${_Helper.removeHTMLTags(briefcontent)}", "", body, null, true)
                    ma.sendMail(recipients, recipients_memo)
                    try {
                        msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg)
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }
            }
        }

        if (doc.getValueString("publishforcustomer") == "1"){
            doc.addReaders(parentProject.getValueList("customer_emp"));
            def customers_memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ": документ ${doc.getValueString('vn')} на исполнение. ${_Helper.removeHTMLTags(briefcontent)}", "", body, null, true)
            def customers = parentProject.getValueList("customer_emp");
            for (String customer: customers) {
                def customerrecipient = [struct.getEmployer(customer)?.getEmail()];
                try{
                    ma.sendMail(customerrecipient, customers_memo)
                }catch (Exception e){
                    e.printStackTrace()
                }
            }
        }

        //ma.sendMail(recipients, "документ ${doc.getValueString('vn')} на исполнение. ${briefcontent}",body)
        body+='<div width="100%"><font size="1" face="Arial" color="#444444">Вы получили данное уведомление как наблюдатель проекта<font></div>';
        def observers_memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ": документ ${doc.getValueString('vn')} на исполнение. ${_Helper.removeHTMLTags(briefcontent)}", "", body, null, true)
        for (String observer: observers) {
            def memberrecipient = [struct.getEmployer(observer)?.getEmail()];
            if(!executers.contains(struct.getEmployer(observer).getUserID()) && struct.getEmployer(observer).getUserID() != author){
                //ma.sendMail(memberrecipient, "документ ${doc.getValueString('vn')} на исполнение. ${briefcontent}", body)
                try {
                    ma.sendMail(memberrecipient, observers_memo)
                } catch (Exception e) {
                    e.printStackTrace()
                }
            }
        }


           // doc.addStringField("mailnotification", "sent")
        doc.save("[supervisor]")
       // }


    }

}
