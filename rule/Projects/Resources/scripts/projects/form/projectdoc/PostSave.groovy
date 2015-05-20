package projects.form.projectdoc

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script.events._FormPostSave;

class PostSave extends _FormPostSave{

	@Override
	public void doPostSave(_Session ses, _Document doc) { 
		// emailing
		try { 
			
			String pname = doc.getValueString("project_name");
			String readers = doc.getValueList("reader");
			String editors = doc.getValueList("editor");
			def editors_readers = [];
			for (String reader: readers) {
				editors_readers.push(reader)
			}
			for (String editor: editors) {
				editors_readers.push(editor)
			}
			editors_readers.unique()
			String docauthor = doc.getValueString('docauthor');
			 
			if(doc.getValueString('mailnotification') == ""){
				
				def msngAgent = ses.getInstMessengerAgent()
				def struct = ses.getStructure()
				def ma = ses.getMailAgent();
				
				// Уведомление о новом проектном документе
				String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новом преоктном документе</font></b><hr>'
				body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
				body += '<tr>'
				//Заказчик
				body += '<td width="210px">Тема: </td><td><b>'+ doc.getValueString("title") +'</b></td>'
				body += "</tr><tr>";
				//Название проекта
				body += '<td width="210px">Название проекта: </td><td><b>'+pname+'</b></td>'
				body += "</tr><tr>";
				
				String xmppmsg = "Уведомление о новом проекте\n";
				xmppmsg += "Тема: " + doc.getValueString("title");
				xmppmsg += "\nНазвание проекта: " + pname;
				
				// Отправляем сообщение менеджеру
				for (String user: editors_readers) {
					def emp = struct.getUser(user);
					def recipient = [emp?.getEmail()]
					String mbody = body;
					//Для работы с документом, перейдите по этой ссылке
					mbody += '<p><font size="2" face="Arial">Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'
					String m_xmp = xmppmsg;
					m_xmp += doc.getFullURL()
					ma.sendMail(recipient, "Уведомление о новом проекте", mbody);
					msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + m_xmp);
				}
				doc.addStringField("mailnotification", "sent")
			}
			
		}
		catch(Exception e){
			e.printStackTrace()
		}
	}

}
