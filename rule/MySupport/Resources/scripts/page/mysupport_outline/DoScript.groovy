package page.mysupport_outline


import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;
import kz.nextbase.script.outline.*;
import kz.nextbase.script.*;

class DoScript extends _DoScript{
	public void doProcess(_Session session, _WebFormData formData, String lang) {
	 
		def list = []
		def user = session.getCurrentAppUser()
		def cdb = session.getCurrentDatabase();
		def docs_outline = new _Outline(getLocalizedWord("Заявки",lang), getLocalizedWord("Заявки",lang), "docs")
		docs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Избранные",lang), getLocalizedWord("Избранные",lang), "favdocs", "Provider?type=page&id=favdocs&page=0"))
		docs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Все заявки",lang), getLocalizedWord("Все заявки",lang), "demands", "Provider?type=page&id=demands&page=0"))
		docs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Заявки на исполнении",lang), getLocalizedWord("Заявки на исполнении",lang), "demands-unexecuted", "Provider?type=page&id=demands-unexecuted&page=0"))
		list.add(docs_outline)
		setContent(list)
	}
	
	def glossList(_Session ses, String gloss_form, def outline_folder, String lang, String pageID){
		
		def cdb = ses.getCurrentDatabase();
		def glist = cdb.getGlossaryDocs(gloss_form, "form='$gloss_form'");
		
		for(def gdoc in glist){
			String name = (lang == "RUS" ? gdoc.getName().split("#")[1] : gdoc.getName().split("#")[0]);
			outline_folder.addEntry(new _OutlineEntry(getLocalizedWord(name,lang),
					getLocalizedWord(name,lang), gdoc.getDocID().toString(), "Provider?type=page&id={$pageID}_by_region&page=0&region="+ gdoc.getDocID().toString()))
			
		}
		
		return outline_folder;
	}
}