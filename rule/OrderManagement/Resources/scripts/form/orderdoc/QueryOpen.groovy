package form.orderdoc

import kz.nextbase.script._Document
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
		publishValue("title",getLocalizedWord("Заказ", lang))

		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		publishEmployer("docauthor",session.currentUserID)
		publishValue("orderDate", session.getCurrentDateAsString())
		def nav = session.getPage("outline", webFormData)
		publishElement(nav);
        publishElement(glossariesList(session, "customer"));
	}


	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)

		publishValue("title", getLocalizedWord("Заказ №", lang) + doc.getViewText());
		publishValue("orderNum",doc.getValueString("orderNum"));
        publishGlossaryValue("customer", doc.getValueString("customer"));

        try{
            publishValue("completeDate", doc.getValueDate("completeDate").format("dd.mm.yyyy"))
        }catch (Exception e){}

        publishEmployer("docauthor",doc.getAuthorID());
        publishEmployer("responsiblePerson", doc.getValueString("responsiblePerson"));
        publishValue("goodsList", doc.getValueString("goodsList"));
        publishValue("price", doc.getValueString("price"));
        publishValue("quantity", doc.getValueNumber("quantity"));
        publishValue("totalPrice", doc.getValueString("totalPrice"));
        publishValue("prepayment", doc.getValueString("prepayment"));
        publishValue("leftPayment", doc.getValueString("leftPayment"));
        publishValue("linkToOutlay", doc.getValueString("linkToOutlay"));
        publishValue("linkToModel", doc.getValueString("linkToModel"));
        publishValue("purchaseCost", doc.getValueString("purchaseCost"));
        publishValue("contractorCost", doc.getValueString("contractorCost"));
        publishValue("laborCost", doc.getValueString("laborCost"));
        publishValue("model", doc.getValueString("model"));
        publishValue("profit", doc.getValueString("profit"));
        publishValue("workerCode", doc.getValueString("workerCode"));
        publishValue("signedAct", doc.getValueString("signedAct"));
        publishValue("credit", doc.getValueString("credit"));

		def nav = session.getPage("outline", webFormData)
		publishElement(nav);
        publishElement(glossariesList(session, "customer"));
        publishValue("orderDate", doc.getValueDate("orderDate"));
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