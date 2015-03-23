package handler.activatedemand

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScheduledHandler
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Control

import java.text.SimpleDateFormat

class Trigger extends _DoScheduledHandler {

	@Override
	public int doHandler(_Session session) {

		def db = session.getCurrentDatabase()
        def currentdate =  new java.sql.Date((new Date()).getTime());

		def col = db.getCollectionOfDocuments("form='demand' and viewtext4='3' and startdate#datetime <= '$currentdate'",
                false).getEntries();
        log("Запуск хэндлера для активации " + col.size() + " заявок");
        col.each { _ViewEntry entry ->
			def doc = entry.getDocument()
            def control = (_Control) doc.getValueObject("control")
            if (control) {
                control.setAllControl(_AllControlType.ACTIVE);
                doc.replaceViewText(control.getAllControl() as String, 4)
                doc.addReader(doc.getValueList("executer").toSet())
                doc.save("[supervisor]")

                def ma = session.getMailAgent();
                def structure = session.getStructure();
                def author = structure.getEmployer(doc.getAuthorID())
                def executers = doc.getValueList("executer");
                def executers_shortname = new ArrayList();
                def executers_email = new ArrayList();
                for (String executer : executers) {
                    doc.addReader(executer);
                    def emp = structure.getEmployer(executer);
                    executers_shortname.add(emp.shortName)
                    executers_email.add(emp.getEmail())
                }

                // почтовое уведомление  1. автору
                if(!executers.contains(author.getUserID())){
                    String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о активации вашего задания</font></b><hr>'
                    body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
                    body += '<tr>'
                    body += '<td width="210px" valign="top">К Вам Уведомление о активации заявки:</td>'
                    body += '<td width="500px" valign="top"><b>документ '+doc.getValueString("vn")+' от '+ doc.getRegDate().format("dd.MM.yyyy")+'</b></td>'
                    body += '</tr><tr>'
                    body += '<td>Исполнители:</font></td><td><b>'+ executers_shortname.join(", ") +'</b></td>'
                    body += '</tr><tr>'
                    body += '<td>Приступить к работе с:</font></td><td><b>'+  doc.getValueDate("startdate").format("dd.MM.yyyy") +'</b></td>'
                    body += '</tr><tr>'
                    body += '<td>Срок исполнения:</font></td><td><b>'+ doc.getValueDate("ctrldate").format("dd.MM.yyyy") +'</b></td>'
                    body += '</tr><tr>'
                    body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
                    body += '<td style="border-top:1px solid #CCC;" valign="top">'+ _Helper.removeHTMLTags(doc.getValueString("briefcontent")) +'</td>'
                    body += '</tr></table>'
                    body += '</font>'

                    try{
                        def memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ': документ ' + doc.getValueString("vn") + ' активирован', "", body, doc, true)
                        ma.sendMailAfter([author.getEmail()], memo)
                    } catch (Exception e) {
                        e.printStackTrace()
                    }
                }

                // 2. исполнителю
                String msgtxt = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новом задании</font></b><hr>'
                msgtxt += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
                msgtxt += '<tr>'
                msgtxt += '<td width="210px" valign="top">К Вам уведомление о новом задании:</td>'
                msgtxt += '<td width="500px" valign="top"><b>документ '+doc.getValueString("vn")+' от '+ doc.getRegDate().format("dd.MM.yyyy")+'</b></td>'
                msgtxt += '</tr><tr>'
                msgtxt += '<td>Автор:</font></td><td><b>'+ author.getFullName() +'</b></td>'
                msgtxt += '</tr><tr>'
                msgtxt += '<td>Приступить к работе с:</font></td><td><b>'+  doc.getValueDate("startdate").format("dd.MM.yyyy") +'</b></td>'
                msgtxt += '</tr><tr>'
                msgtxt += '<td>Срок исполнения:</font></td><td><b>'+ doc.getValueDate("ctrldate").format("dd.MM.yyyy")+'</b></td>'
                msgtxt += '</tr><tr>'
                msgtxt += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
                msgtxt += '<td style="border-top:1px solid #CCC;" valign="top">'+ _Helper.removeHTMLTags(doc.getValueString("briefcontent")) +'</td>'
                msgtxt += '</tr></table>'
                msgtxt += '</font>'

                try{
                    def memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ': документ ' + doc.getValueString("vn") + ' на исполнение', "", msgtxt, doc, true)
                    ma.sendMailAfter(executers_email, memo)
                } catch (Exception e) {
                    e.printStackTrace()
                }
            }
        }
		return 0;
	}
}