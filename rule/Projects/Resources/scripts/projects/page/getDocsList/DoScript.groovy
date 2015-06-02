package projects.page.getDocsList

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript {
	 
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		try{
			def cdb = session.getCurrentDatabase();
			String form = formData.getValueSilently("form");
			
			if(form == "project-list"){
				String out = "";				
				def docs = cdb.getDocsCollection("form='project'",0,0).getBaseCollection();
				for(def pdoc in docs){						
					pdoc.fillResponses();
					
					if(pdoc.getResponses().size() == 0) continue;
					try{
						if(pdoc.getValueAsInteger("status") == 3 || pdoc.getValueAsInteger("status") == 4) continue;
					}catch(_Exception exc){
						println(exc)
					}
					
					
					def current_m_doc = null; 
					
					def rootTag = new _Tag("project","")
					rootTag.setAttr("url", pdoc.getFullURL());
					rootTag.setAttr("name", pdoc.getValueAsString("project_name")[0]);
					rootTag.setAttr("docid", pdoc.getDocID().toString());
					rootTag.setAttr("id", pdoc.getDdbID());
					
					try{									
						for(def mdoc in pdoc.getResponses()){	
							if(mdoc.form == "milestone"){
								/*if(mdoc.getValueAsString("current")[0] == "on"){
									
									current_m_doc = mdoc;								
								}*/
								def entryTag = new _Tag("milestone", mdoc.getValueAsString("description")[0]);
								entryTag.setAttr("url", mdoc.getFullURL());
								entryTag.setAttr("docid", mdoc.getDocID());

								rootTag.addTag(entryTag);

							}
						}
					}catch(Exception ex){}					
					Date cdate = new Date();
					
					/*if(current_m_doc == null){
						for(def mdoc in pdoc.getResponses()){
							if(mdoc.form == "milestone"){							
								current_m_doc = mdoc;							
								Date mdue_date = mdoc.getValueAsDate("duedate");
								if(mdue_date.compareTo(cdate) > 0){
									current_m_doc = mdoc;
								}
							}
						}
					}*/


					/*if(current_m_doc != null){
						def entryTag = new _Tag("milestone", current_m_doc.getValueAsString("description")[0]);
						entryTag.setAttr("url", current_m_doc.getFullURL());
						entryTag.setAttr("docid", current_m_doc.getDocID());
						
						rootTag.addTag(entryTag);
						def xml = new _XMLDocument(rootTag);						
						 
						setContent(xml);
					}*/
					def xml = new _XMLDocument(rootTag);
					setContent(xml);
					
				} 		
				
				return;	
			}
			
			
			int doctype = Integer.parseInt(formData.getValueSilently("doctype"));
					
			String list = "";
			def docs = null;
			//
			if(form == 'demand_extend_reason'){
				if (doctype == 894){
					docs = cdb.getGlossaryDocs(form, "form='$form'");
					for(def g in docs){
						list = g.getDdbID() + "#`"+g.getViewText();		
						def rootTag = new _Tag("text", list);
						def xml = new _XMLDocument(rootTag);
						setContent(xml)				
					}
					
				}else{
					docs = cdb.getDocsCollection("form = '$form'");
				}
			}else{
				if (doctype == 894){
					docs = cdb.getGlossaryDocs(form, "form='$form'");
					for(def g in docs){
						list = g.getDocID() + "#`"+g.getViewText();
						def rootTag = new _Tag("text", list);
						def xml = new _XMLDocument(rootTag);
						setContent(xml)
					}
					
				}else{
					docs = cdb.getDocsCollection("form = '$form'");
				}
			}
			//println(list)
			
		}catch(Exception e){
			println(e)
		}
	}

}




