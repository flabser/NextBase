package page.filter_content

import java.util.Map
import kz.nextbase.script.constants._DocumentType;
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoHandler;
import kz.nextbase.script.events._DoScheduledHandler
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline._Outline
import kz.nextbase.script.outline._OutlineEntry
import kz.nextbase.script.struct._Employer
import kz.nextbase.script.task._Task
import nextbase.groovy.*;

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData);
		def rootTag = new _Tag()
		
		def projectsTag = new _Tag("projects","")
		def col = session.currentDatabase.getGroupedEntries("projectID",1,100)
		col.each{
			def viewEntry = (_ViewEntry)it;
			try{
				def doc = session.currentDatabase.getDocumentByID(viewEntry.getViewText(0));
				def entryTag = new _Tag("entry",doc.getViewText())
				entryTag.setAttr("id",viewEntry.getViewText(0))
				projectsTag.addTag(entryTag)
			}catch(_Exception e){

			}
		}
		rootTag.addTag(projectsTag)
		
		def autorsTag = new _Tag("authors","")
		def authorcol = session.currentDatabase.getGroupedEntries("docauthor",1,100)
		authorcol.each{
			def viewEntry = (_ViewEntry)it;
			try{
				def doc =session.structure.getEmployer(viewEntry.getViewText(0))
					def entryTag = new _Tag("entry",viewEntry.getViewText(0))
				if(doc.shortName != ''){
					entryTag = new _Tag("entry",doc.shortName)
				}
				entryTag.setAttr("id",viewEntry.getViewText(0))
				autorsTag.addTag(entryTag)
			}catch(_Exception e){
				
			}
		}
		rootTag.addTag(autorsTag)

		def executerTag = new _Tag("executers","")
		def executercol = session.currentDatabase.getGroupedEntries("executer",1,100)
		executercol.each{
			def viewEntry = (_ViewEntry)it;
			try{
				def doc =session.structure.getEmployer(viewEntry.getViewText(0))
				def entryTag = new _Tag("entry",viewEntry.getViewText(0))
				if(doc.shortName != ''){
					entryTag = new _Tag("entry",doc.shortName)
				}
				entryTag.setAttr("id",viewEntry.getViewText(0))
				executerTag.addTag(entryTag)
			}catch(_Exception e){
				
			}
		}
		rootTag.addTag(executerTag)
		
		def xml = new _XMLDocument(rootTag)
		setContent(xml);

	}
}
