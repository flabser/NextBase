package form.project

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.events._FormPostSave;

class PostSave extends _FormPostSave{

	@Override
	public void doPostSave(_Session ses, _Document doc) {

		def db = ses.getCurrentDatabase()
		String pname = doc.getValueString("project_name")
		String manager = doc.getValueString("manager")
		String tester =  doc.getValueString("tester")
		String programmer =  doc.getValueString("programmer")
		String docauthor = doc.getValueString('docauthor')
		String customer = doc.getGlossaryValue("customer", "docid='" + doc.getValueString('customer') + "'", "name")
		def observers = doc.getValueList("observer")
		def i = 0
		
		def pCol = db.getCollectionOfDocuments("form='demand' and viewtext1='" + pname + "'" , false).getEntries()
		pCol.each { _ViewEntry pEntry ->
			def pDoc = pEntry.getDocument()
			pDoc.clearReaders()
			pDoc.addReader(pDoc.getValueString("executer"))
			pDoc.addReaders(observers)
			pDoc.save("supervisor")
			i ++ 
		}
		
		log("Access was been granted to related users of \"" + pname + "\" project (Processed:" + i + " documents)")
		
		if(doc.getValueString('mailnotification') == ""){

			def msngAgent = ses.getInstMessengerAgent()
			def struct = ses.getStructure()
			def ma = ses.getMailAgent();

			// Уведомление о новом проекте
			String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о новом проекте</font></b><hr>'
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
			body += '<tr>'
			//Заказчик
			body += '<td width="210px">Заказчик: </td><td><b>'+customer+'</b></td>'
			body += "</tr><tr>";
			//Название проекта
			body += '<td width="210px">Название проекта: </td><td><b>'+pname+'</b></td>'
			body += "</tr><tr>"

			String xmppmsg = "Уведомление о новом проекте\n"
			xmppmsg += "Заказчик: " + customer
			xmppmsg += "\nНазвание проекта: " + pname

			// Отправляем сообщение менеджеру
			if( manager != docauthor){
				def emp = struct.getUser(manager)
				def recipient = [emp?.getEmail()]

				String mbody = body;
				// Вас выбрали как
				mbody += '<td width="210px">Вас выбрали как: </td><td><b>Ответственный менеджер</b></td></tr></table>'
				//Для работы с документом, перейдите по этой ссылке
				mbody += '<p><font size="2" face="Arial">Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

				String m_xmp = xmppmsg;
				m_xmp += "\nВас выбрали как: Ответственный менеджер\n"
				m_xmp += doc.getFullURL()
				ma.sendMail(recipient, "Уведомление о новом проекте", mbody);
				msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getValueString("project_name") + ": " + m_xmp);

			}
			// Отправляем сообщение тестеру
			if( tester != docauthor){

				def emp = struct.getEmployer(tester)
				def recipient = [emp?.getEmail()]

				String mbody = body;
				// Вас выбрали как
				mbody += '<td width="210px">Вас выбрали как: </td><td><b>Ответственный тестировщик</b></td></tr></table>'
				//Для работы с документом, перейдите по этой ссылке
				mbody += '<p><font size="2" face="Arial">Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

				String m_xmp = xmppmsg;
				m_xmp += "\nВас выбрали как: Ответственный тестировщик\n"
				m_xmp += doc.getFullURL()
				ma.sendMail(recipient, "Уведомление о новом проекте", mbody)
				msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getValueString("project_name") + ": " + m_xmp)
			}
			// Отправляем сообщение тестеру
			if( programmer != docauthor){

				def emp = struct.getEmployer(programmer)
				def recipient = [emp?.getEmail()]

				String mbody = body
				// Вас выбрали как
				mbody += '<td width="210px">Вас выбрали как: </td><td><b>Ответственный программист</b></td></tr></table>'
				//Для работы с документом, перейдите по этой ссылке
				mbody += '<p><font size="2" face="Arial">&#1044;&#1083;&#1103; Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

				String m_xmp = xmppmsg
				m_xmp += "\nВас выбрали как: Ответственный программист\n"
				m_xmp += doc.getFullURL()
				ma.sendMail(recipient, "Уведомление о новом проекте", mbody)
				msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getValueString("project_name") + ": " + m_xmp)
			}

			doc.addStringField("mailnotification", "sent")
		}
	}
}
