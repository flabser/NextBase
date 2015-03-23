package page.outlineom

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;
import kz.nextbase.script.outline.*;

/**
 * @author Bekzat
 * @date 28.01.2014
 */
class DoScript extends _DoScript{
	public void doProcess(_Session session, _WebFormData formData, String lang) {
	 
		def list = []
		def user = session.getCurrentAppUser()
		def cdb = session.getCurrentDatabase();
		def docs_outline = new _Outline(getLocalizedWord("Заказы",lang), getLocalizedWord("Заказы",lang), "docs")
		docs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Избранные",lang), getLocalizedWord("Избранные",lang), "favdocs", "Provider?type=page&id=favdocs&page=1"))
		docs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Все заказы",lang), getLocalizedWord("Все заказы",lang), "order", "Provider?type=page&id=order&page=0"))
		list.add(docs_outline)

        /* Заказы по заказчику */
        def docs_by_customers = new _Outline(getLocalizedWord("По заказчику",lang), getLocalizedWord("По заказчику",lang), "bycustomer");
        def customers = cdb.getGroupedEntries("customer", 1, 20);

        customers.each {
            def glos = cdb.getGlossaryDocument("customer", "ddbid='${it.getViewText()}'");
            def name = glos.getName();
            docs_by_customers.addEntry(
                    new _OutlineEntry(name, name, "order_by_customer_" + it.getViewText(), "Provider?type=page&id=order_by_customer&page=0&customer="+ it.getViewText()));
        }
        list.add(docs_by_customers)

        /* Заказы по ответственному исполнителю */
        def docs_by_resp = new _Outline(getLocalizedWord("По ответственному исполнителю",lang), getLocalizedWord("По ответственному исполнителю",lang), "byResponsiblePerson");
        def responsiblePerson = cdb.getGroupedEntries("responsiblePerson", 1, 20);

        responsiblePerson.each {
            println(it.getViewText());
            def emp = session.getStructure().getEmployer(it.getViewText());
            def name = emp.getFullName();
            docs_by_resp.addEntry(
                    new _OutlineEntry(name, name, "order_by_responsiblePerson_" + it.getViewText(), "Provider?type=page&id=order_by_responsiblePerson&page=0&person="+ it.getViewText()));
        }
        list.add(docs_by_resp)

        /* По остатку */
        def docs_by_leftPayment = new _Outline(getLocalizedWord("По остатку",lang), getLocalizedWord("По остатку",lang), "byLeftPayment");
        def leftPayment = cdb.getGroupedEntries("leftPayment", 1, 20);

        leftPayment.each {
            def name = it.getViewText(1)
            docs_by_leftPayment.addEntry(
                    new _OutlineEntry(name, name, "order_by_leftPayment_" + name, "Provider?type=page&id=order_by_leftPayment&page=0&amount="+ name));
        }
        list.add(docs_by_leftPayment)

        /* По дате заказа */
//        def docs_by_orderDate = new _Outline(getLocalizedWord("По дате заказа",lang), getLocalizedWord("По дате заказа",lang), "byOrderDate");
//        def regDate = cdb.getGroupedEntries("orderDate#datetime", 1, 20);
//
//        regDate.each {
//            def name = it.getViewText();
////            try{
////                name = _Helper.convertStringToDate(it.getViewText()).format("dd.MM.yyyy");
////            }    catch(Exception e){}
//
//            docs_by_orderDate.addEntry(
//                    new _OutlineEntry(name, name, "order_by_orderDate_" + name, "Provider?type=page&id=order_by_orderDate&page=0&date="+ name));
//        }
       // list.add(docs_by_orderDate)


        def glos_outline = new _Outline(getLocalizedWord("Справочники",lang), getLocalizedWord("Справочники",lang), "glos")
        glos_outline.addEntry(new _OutlineEntry(getLocalizedWord("Заказчики",lang), getLocalizedWord("Заказчики",lang), "customer", "Provider?type=page&id=customer&page=1"))
        list.add(glos_outline)

        setContent(list)
	}
}