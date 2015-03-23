package form.comment

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script.events._FormPostSave
import kz.nextbase.script.mail._Memo

class PostSave extends _FormPostSave{
    public void doPostSave(_Session ses, _Document doc) {
		def struct = ses.getStructure()
		def ma = ses.getMailAgent();
		def msngAgent = ses.getInstMessengerAgent();
        def topic = ses.getCurrentDatabase().getTopicByPostID(doc.getBaseObject(), ses.getCurrentAppUser().getListOfGroups(), ses.getCurrentUserID());
        def _topic = new _Document(topic);
        _topic.setSession(ses);
		def demand = _topic.getParentDocument();
		def observers = doc.getGrandParentDocument().getValueList("observer");
		String executeruserid = demand.getValueString('executer');
		def author =  struct.getEmployer(demand.getAuthorID());
		def emp = struct.getEmployer(executeruserid)
		String briefcontent = demand.getValueString("briefcontent")
		String contentsource = doc.getValueString("contentsource")

		//Уведомление о новом задании
		String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новом комментарии</font></b><hr>'
		body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
		body += '<tr>'
		//К Вам документ на исполнение
		body += '<td width="210px">Документ :</td>'
		//от
		body += '<td width="500px"><b>'+demand.getValueString("vn")+' от '+demand.getValueString("dvn")+'</b></td>'
		body += '</tr><tr>'
		//Проект
		body += '<td>Проект :</font></td><td><b>'+ doc.getGrandParentDocument().getValueString("project_name")+'</b></td>'
		body += '</tr><tr>'
		//Автор
		body += '<td>Автор:</font></td><td><b>'+author.getShortName()+'</b></td>'
		body += '</tr><tr>'
		//Исполнитель
		body += '<td>Исполнитель:</font></td><td><b>'+emp.getShortName()+'</b></td>'
		body += '</tr><tr>'
		//Срок исполнения
		body += '<td>Срок исполнения:</font></td><td><b>'+demand.getValueString("ctrldate")+'</b></td>'
		body += '</tr><tr>'
		//Содержание
		body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+ _Helper.removeHTMLTags(briefcontent) +'</td>'
		body += '</tr>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">Автор комментария:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+  struct.getEmployer(doc.getAuthorID()).getShortName() +'</td>'
		body += '</tr>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">Текст комментария:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+ contentsource +'</td>'
		body += '</tr></table>'
		//Для работы с документом, перейдите по этой ссылке
		body += '<p><font size="2" face="Arial">Для работы с документом перейдите по этой <a href="' + demand.getFullURL() + '">ссылке...</a></p></font>'

		briefcontent = _Helper.removeHTMLTags(briefcontent.replaceAll("\n", " "))

		String xmppmsg = "Уведомление о новом комментарии\n"
		xmppmsg += "Новый комментарий к документу: " + demand.getValueString("vn") + " от " + demand.getValueString("dvn") + "\n"
		//xmppmsg += "Исполнитель: " + emp.getShortName() + " \n"
		xmppmsg += "Срок исполнения: " + demand.getValueString("ctrldate") +"\n"
		xmppmsg += "Автор комментария: " + struct.getEmployer(doc.getAuthorID()).getShortName() +"\n"
		xmppmsg += "Текст комментария: " + doc.getValueString("contentsource") +"\n"
		xmppmsg += demand.getFullURL()

		def recipients = [emp?.getEmail(), author?.getEmail()]
		//def demandauthor = []
		def recipients_memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ": Новый комментарий к  документу ${doc.getValueString('vn')} . ${_Helper.removeHTMLTags(briefcontent)} . Текст комментария: "+contentsource, "", body, null, true)
		ma.sendMail(recipients, recipients_memo)
		//ma.sendMail(demandauthor, recipients_memo)
		//ma.sendMail(recipients, "документ ${doc.getValueString('vn')} на исполнение. ${briefcontent}",body)
		body+='<div width="100%"><font size="1" face="Arial" color="#444444">Вы получили данное уведомление как наблюдатель проекта<font></div>';
		def observers_memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ": Новый комментарий к  документу ${doc.getValueString('vn')} . ${_Helper.removeHTMLTags(briefcontent)} . Текст комментария: "+contentsource, "", body, null, true)
		for (String observer: observers) {
			def memberrecipient = [struct.getEmployer(observer)?.getEmail()];
			if(struct.getEmployer(observer).getUserID() != emp.getUserID() && struct.getEmployer(observer).getUserID() != author.getUserID()){
				//ma.sendMail(memberrecipient, "документ ${doc.getValueString('vn')} на исполнение. ${briefcontent}", body)
				try {
					ma.sendMail(memberrecipient, observers_memo)
				} catch (Exception e) {
					e.printStackTrace()
				}
			}
		}
		try {
			msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg)
		} catch (Exception e) {
			e.printStackTrace()
		}
		//doc.addStringField("mailnotification", "sent")
		//doc.save("[supervisor]")
	}
}
