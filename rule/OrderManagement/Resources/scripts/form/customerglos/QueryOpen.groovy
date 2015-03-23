package form.customerglos

import kz.nextbase.script._Document
import kz.nextbase.script._Glossary
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.events._FormQueryOpen

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		publishValue("title",getLocalizedWord("Заказчик", lang))

		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		publishEmployer("docauthor",session.currentUserID)
		publishValue("docdate", session.getCurrentDateAsString())
		def nav = session.getPage("outline", webFormData)
		publishElement(nav);
        publishElement(glossariesList(session, "customer"));
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def glos = (_Glossary)doc;
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		
		publishValue("title",getLocalizedWord("Заказчик", lang) + ": " + glos.getViewText())
		publishValue("name",doc.getValueString("name"))
		publishEmployer("docauthor",doc.getAuthorID())
		publishValue("docdate",doc.getValueString("docdate"))
		def nav = session.getPage("outline", webFormData)
		publishElement(nav);
        publishElement(glossariesList(session, "customer"));
	}

    //customer
    def glossariesList(_Session ses, String gloss_form){

        def cdb = ses.getCurrentDatabase();
        def glist = cdb.getGlossaryDocs(gloss_form, "form='$gloss_form'");
        def glossaries = new _Tag("glossaries", "");
        def rootTag = new _Tag(gloss_form, "");

        for(def gdoc in glist){

            def etag = new _Tag("entry", gdoc.getViewText());
            etag.setAttr("docid", gdoc.getDocID());
            etag.setAttr("id", gdoc.getID());
            rootTag.addTag(etag);
        }
        glossaries.addTag(rootTag);
        def xml = new _XMLDocument(glossaries);
        return xml;
    }
}