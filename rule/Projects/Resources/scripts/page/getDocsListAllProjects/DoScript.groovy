package page.getDocsListAllProjects

import kz.nextbase.script._Session;
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData;
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript;

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def cdb = session.getCurrentDatabase();
		def projects = cdb.getDocsCollection("form='project'",1,2000).getBaseCollection();
		String formula = "";
		
		def entryTag = new _Tag("statistics");
		for(def p in projects){
			def entry = new _Tag("entry");
			entry.setAttr("docid", p.getDocID());
			entry.setAttr("project_name", p.getValueAsString("project_name")[0]);
			entryTag.addTag(entry);
		}
		def xml = new _XMLDocument(entryTag)
		setContent(xml);
	}
}
