package form.mark

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave

class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document exec, _WebFormData webFormData, String lang) {
		println(webFormData)
		
		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return;
		}

		exec.setForm("mark")
		exec.setValueString("author",webFormData.getValue("author") )
		exec.addDateField("finishdate", new Date())
		exec.addStringField("report", webFormData.getValue("report"))
		exec.addStringField("executor", webFormData.getValue("executor"))
		exec.addReader(webFormData.getValue("executor"))
		exec.addFile("rtfcontent", webFormData)
		exec.setViewText(_Helper.getDateAsString(exec.getValueDate("finishdate")) + " " + session.getStructure().getEmployer(exec.getValueString("executor")).getShortName() + " (" + exec.getValueString("report") + ")")
		exec.addViewText(exec.getValueString("report"))
		exec.setViewDate(exec.getValueDate("finishdate"))
		
		def returnURL = session.getURLOfLastPage()
		setRedirectURL(returnURL)
	}

	

	def validate(_WebFormData webFormData){
		if (webFormData.getValueSilently("executor") == ""){
			localizedMsgBox("Поле \"Исполнитель\" не выбрано")
			return false
		}else if (webFormData.getValueSilently("report") == ""){
			localizedMsgBox("Поле \"Содержание отчета\" не заполнено")
			return false
		}else if (webFormData.getValueSilently('report').length() > 2046){
			localizedMsgBox('Поле \'Содержание отчета\' содержит значение превышающее 2046 символов');
			return false;
		}
		return true
	}
	
}
