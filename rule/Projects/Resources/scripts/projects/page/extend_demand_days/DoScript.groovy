package projects.page.extend_demand_days

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.task._Control

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		println(formData)

		def cdb = session.getCurrentDatabase()
		def doc = cdb.getDocumentByID(formData.getNumberValueSilently("key",-1))

		if(formData.containsField("extend_demand_days") && formData.containsField("extend_demand_reason_id")){
			def control = (_Control)doc.getValueObject("control")
			control.addProlongation(formData.getNumberValueSilently("extend_demand_days",0), formData.getValue("extend_demand_reason_id"))
			doc.addField("control", control)
			doc.setViewDate(control.getCtrlDate())
			doc.setViewText(control.getDiffBetweenDays(),2)
			doc.setViewDate(control.getCtrlDate())
			doc.save("[supervisor]")

            def msngAgent = session.getInstMessengerAgent();
            def struct = session.getStructure();
            String executeruserid = doc.getValueString('executer');
			def executers = doc.getValueList('executer');
            String xmppmsg = "Уведомление о продлении заявки\n"
            xmppmsg += "Ваша заявка " + doc.getValueString("vn") + " была продлена до " + control.getCtrlDate().format("dd.MM.yyyy") + "\n"
            xmppmsg += doc.getFullURL()
			for (String executer: executers) {
				def emp = struct.getEmployer(executer);
	            try {
	                msngAgent.sendMessage([emp?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + xmppmsg)
	            } catch (Exception e) {
	                e.printStackTrace()
	            }
			}
		}
		
		setRedirectURL(session.getURLOfLastPage())
	}

}




