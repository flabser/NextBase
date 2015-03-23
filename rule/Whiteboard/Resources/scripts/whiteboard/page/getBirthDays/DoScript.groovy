package whiteboard.page.getBirthDays

import java.util.ArrayList;
import java.util.Map;
import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.struct._EmployerStatusType

class DoScript extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def employerbd = []
		def calendar = Calendar.getInstance()
		def month = calendar.get(Calendar.MONTH)
		def day = calendar.get(Calendar.DAY_OF_MONTH)
		def date = new Date();
		def allEmployers = session.getStructure().getAllEmployers();
		def rootTag = new _Tag("employers");
		def i = 0;
		allEmployers.each { emp ->
			if ((emp.getBirthDate()?.toCalendar()?.get(Calendar.MONTH)?.equals(month)) && emp.getStatus() != _EmployerStatusType.FIRED) {
				employerbd.push(emp)
				def entryTag = new _Tag("entry");
				entryTag.setAttr("userid", emp.getUserID())
				entryTag.setAttr("viewtext", emp.getFullName())
				entryTag.setAttr("birthdate", emp.getBirthDate().toLocaleString())
				rootTag.addTag(entryTag)
				i++;
			}
		}
		rootTag.setAttr("count", i);
		def xml = new _XMLDocument(rootTag)
		setContent(xml)
	}
}

