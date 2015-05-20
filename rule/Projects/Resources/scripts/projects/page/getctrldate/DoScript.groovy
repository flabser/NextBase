package projects.page.getctrldate

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.task._Control

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(formData)

		def priority = formData.getNumberDoubleValueSilently("priority",10.0)
		def complication = formData.getNumberDoubleValueSilently("complication",10.0)
        def startDate = _Helper.convertStringToDate(formData.getValue("startdate"));
		def	control = new _Control(session, startDate, false, priority, 0.0)
		def rootTag = new _Tag(formData.getValue("id"),"")
		rootTag.addTag(new _Tag("primaryctrldate",_Helper.getDateAsString(control.getPrimaryCtrlDate())))
		rootTag.addTag(new _Tag("ctrldate",_Helper.getDateAsString(control.getCtrlDate())))
		rootTag.addTag(new _Tag("daydiff",control.getDiffBetweenDays()))
		def xml = new _XMLDocument(rootTag)
		setContent(xml);
	}
}




