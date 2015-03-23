package bankfinance.form.bank_operation

import kz.nextbase.script.*
import kz.nextbase.script.events._FormPostSave

class PostSave extends _FormPostSave {

	public void doPostSave(_Session session, _Document doc) {
		def basis = ""
		if (doc.getValueString('basis') != ""){
			basis = "; " + doc.getValueString('basis')
		}

		def db = session.getCurrentDatabase()
		def catDoc = db.getGlossaryDocument(doc.getValueNumber("category"))
		if(catDoc){
			def opType = catDoc.getValueString("typeoperation")
			if(opType == "transfer"){
				def childdoc
				String vnAsText

				def responses = doc.getResponses()
				if(responses != null && !responses.isEmpty()){
					def respDoc = responses.toArray()[0]
					childdoc = ((_Document)respDoc)
					vnAsText = childdoc.getValueString("vn")
				}else{
					childdoc = new _Document(session.getCurrentDatabase())
					childdoc.setForm("bank_operation")
					int num = db.getRegNumber('bank_operation')
					vnAsText = Integer.toString(num)
					childdoc.addStringField("vn", vnAsText)
					childdoc.setParentDoc(doc)
				}

				childdoc.addStringField("author", session.getCurrentUserID())
				childdoc.addNumberField("bank_account", doc.getValueNumber("recipient"));
				childdoc.addNumberField("summa", doc.getValueFloat("summa"))
				childdoc.addDateField("date",doc.getValueDate("date"))
				def receiveOperation = db.getGlossaryDocument("category", "typeoperation = 'received'")
				childdoc.addNumberField("category",receiveOperation.getDocID())
				childdoc.addStringField("basis", doc.getValueString("basis"))
				childdoc.addStringField("through", doc.getValueString("through"))
				doc.copyAttachments(childdoc)
				childdoc.clearReaders()
				childdoc.clearEditors()
				childdoc.addReaders(doc.getReaders())
				childdoc.addEditor(doc.getAuthorID())
				def accountDoc = db.getGlossaryDocument(doc.getValueNumber("recipient"))
				def receiver = accountDoc.getValueString("user")
				childdoc.addReader(receiver)

				def addInfo

				if (accountDoc) addInfo = " << " + accountDoc.getName()
				childdoc.setViewText("№ " + vnAsText + " - " + _Helper.getDateAsString(doc.getValueDate('date')) + " -> "+ receiveOperation.getName() + addInfo + basis)

				childdoc.setViewDate(doc.getValueDate("date"))
				childdoc.setViewNumber(doc.getValueFloat("summa"))
				childdoc.addViewText(session.getCurrentDatabase().getGlossaryCustomFieldValueByDOCID(doc.getValueString('recipient').toInteger(), "name"));

				childdoc.save("[supervisor]");
			}
		}
	}
}
