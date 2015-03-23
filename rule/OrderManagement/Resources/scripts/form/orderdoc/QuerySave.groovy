package form.orderdoc

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave

class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		
		println(webFormData)
		
		boolean v = validate(webFormData);
		if(v == false){
			stopSave()
			return;
		}

		doc.setForm("order");
        try{
            doc.addDateField("orderDate", _Helper.convertStringToDate(webFormData.getValueSilently("orderDate")));
        }catch(Exception e){}

        doc.addStringField("customer", webFormData.getValueSilently("customer"));
        def completeDate = webFormData.getValueSilently("completeDate");
        doc.addDateField("completeDate", (completeDate != "" ? _Helper.convertStringToDate(completeDate) : null));
        doc.addStringField("responsiblePerson", webFormData.getValueSilently("responsiblePerson"));
        doc.addStringField("goodsList", webFormData.getValueSilently("goodsList"));
        doc.addStringField("price", webFormData.getValueSilently("price"));
        doc.addNumberField("quantity", webFormData.getNumberValueSilently("quantity", 0));
        doc.addStringField("totalPrice", webFormData.getValueSilently("totalPrice"));
        doc.addStringField("prepayment", webFormData.getValueSilently("prepayment"));
        doc.addStringField("leftPayment", webFormData.getValueSilently("leftPayment"));
        doc.addStringField("linkToOutlay", webFormData.getValueSilently("linkToOutlay"));
        doc.addStringField("linkToModel", webFormData.getValueSilently("linkToModel"));
        doc.addStringField("purchaseCost", webFormData.getValueSilently("purchaseCost"));
        doc.addStringField("contractorCost", webFormData.getValueSilently("contractorCost"));
        doc.addStringField("laborCost", webFormData.getValueSilently("laborCost"));
        doc.addStringField("profit", webFormData.getValueSilently("profit"));
        doc.addStringField("model", webFormData.getValueSilently("model"));
        doc.addStringField("workerCode", webFormData.getValueSilently("workerCode"));
        doc.addStringField("signedAct", webFormData.getValueSilently("signedAct"));
        doc.addStringField("credit", webFormData.getValueSilently("credit"));


        doc.addEditor(doc.getAuthorID());
        doc.addEditor("[redactor]");
        doc.addReader("[reader]");
		def returnURL = ses.getURLOfLastPage()

		if (doc.isNewDoc) {
			returnURL.changeParameter("page", "0");
            int num = ses.getCurrentDatabase().getRegNumber('key')
            doc.addStringField("orderNum", Integer.toString(num));
		}else{
            doc.addStringField("orderNum", doc.getValueString("orderNum"));
        }
        setRedirectURL(returnURL)

        doc.setViewText(doc.getValueString("orderNum"));
        doc.addViewText(doc.getGlossaryValue("customer", "ddbid='${webFormData.getValueSilently("customer")}'", "name"));
        doc.addViewText(ses.getStructure().getEmployer(webFormData.getValueSilently("responsiblePerson")).getShortName());
        doc.setViewDate(_Helper.convertStringToDate(webFormData.getValueSilently("orderDate")));

	}

	def validate(_WebFormData webFormData){

        if (webFormData.getValueSilently("customer") == ""){
            localizedMsgBox("Поле \"Заказчик\" не выбрано")
            return false
        }
        if (webFormData.getValueSilently("responsiblePerson") == ""){
            localizedMsgBox("Поле \"Ответственный исполнитель\" не выбрано")
            return false
        }
        if (webFormData.getValueSilently("leftPayment") == ""){
            localizedMsgBox("Поле \"Остаток\" не заполнено")
            return false
        }
        if (webFormData.getValueSilently("orderDate") == ""){
            localizedMsgBox("Поле \"Дата заказа\" не заполнено")
            return false
        }

		return true;
	}
}
