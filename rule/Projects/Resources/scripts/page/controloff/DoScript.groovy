package page.controloff
import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Control

/**
 * 
 *  
 * Этот класс реализует снятие с контроля заявок
 * 
 */
class DoScript extends _DoScript {
	
	def session;	 	
	@Override
	public void doProcess(_Session _session, _WebFormData formData, String lang) {

		println(formData)
		session = _session;
		def cdb = _session.getCurrentDatabase();
		def doc = cdb.getDocumentByID(Integer.parseInt(formData.getValue("key")));
		
		setControlOff(session, doc, "reset");
		
		setRedirectURL(_session.getLastURL());	
		_session.setFlash(doc);
	}
	
	/**
	 * Рекурсивный метод для снятия ветку заявок с контроля
	 * @param doc
	 * @param session
	 * @return
	 */
	def setControlOff(_Session session, _Document doc, String status){
		
		def isControlOff = false;
		def cdb = session.getCurrentDatabase()
		/* Снятие с контроля данной заявки */
		def control = doc.getValueObject("control")
		((_Control)control).setAllControl(_AllControlType.RESET)
		doc.setValueString("status", status)
		doc.setViewText(doc.getViewText(),0)
		doc.setViewText("0",4)
		doc.setValueString("datedisp", _Helper.getDateAsString(new Date()))
		isControlOff = doc.save("[supervisor]")
		
		println(isControlOff);
		/* Снятие с контроля дочерних заявок */
		if(!isControlOff) return;
		for(def rdoc in doc.getResponses()){
			
			/* проверка, заявка ли эта дочерка или была ли она уже снята с контроля */
			if(rdoc.getDocumentForm() != 'demand' || rdoc.doc.getViewTextList()[4] == '0') continue; 
			println(rdoc.getDocumentForm());
			println(rdoc.doc.getViewTextList()[4]);
			
			setControlOff(session, rdoc, "autoReset");			
		}	
		def struct = session.getStructure()
		
		def executers = doc.getValueList('executer');
		def executers_shortname = new ArrayList();
		for (String executer: executers) {
			executers_shortname.add(struct.getEmployer(executer).shortName)
		}
		String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о снятии с контроля</font></b><hr>'
		body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
		body += '<tr>'
		body += '<td width="210px" valign="top">К Вам уведомление о снятии документа с контроля:</td>'
		body += '<td width="500px" valign="top"><b>документ '+doc.getValueString("vn")+' снят с контроля от '+doc.getValueString("datedisp")+'</b></td>'
		body += '</tr><tr>'
		body += '<td>Исполнители:</font></td><td><b>'+ executers_shortname.join(", ") +'</b></td>'
		body += '</tr><tr>'
		body += '<td>Срок исполнения:</font></td><td><b>'+doc.getValueString("ctrldate")+'</b></td>'
		body += '</tr><tr>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+ _Helper.removeHTMLTags(doc.getValueString("briefcontent")) +'</td>'
		body += '</tr></table>'
		body += '</font>'
		def ma = session.getMailAgent()
		for (String executer: executers) {
			def empExec = struct.getEmployer(executer)
			if(executer != doc.getValueString('author')){
				try{
					def memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ': документ ' + doc.getValueString("vn") + ' снят с контроля', "", body, doc, true)
					ma.sendMail([empExec.getEmail()], memo)
				} catch (Exception e) {
					e.printStackTrace()
				}
			}
		}
		println("Off");
	}
}




