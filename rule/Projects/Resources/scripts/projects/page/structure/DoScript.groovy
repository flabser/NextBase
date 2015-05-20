package projects.page.structure

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript


class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def str = session.getStructure();
		def allEmps = str.getAllEmployers();
		def rootTag = new _Tag("query")
		for(def e in allEmps){
			def entry = new _Tag("entry", e.getShortName());
			entry.setAttr("org", e.getOrganization().getShortName());
			entry.setAttr("userid", e.getUserID());	
			rootTag.addTag(entry);
		}
		def xml = new _XMLDocument(rootTag);
		setContent(xml);
	}
}
