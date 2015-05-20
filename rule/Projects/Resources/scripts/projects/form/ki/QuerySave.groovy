package projects.form.ki
import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._FormQuerySave
import kz.nextbase.script.task._Control

class QuerySave extends _FormQuerySave{

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("report") == ""){
			localizedMsgBox("Поле \"Краткое содержание\" не заполнено.");
			return false;
		}
		if (webFormData.getValueSilently('report').length() > 2046){
			localizedMsgBox('Поле \'Краткое содержание\' содержит значение превышающее 2046 символов');
			return false;
		}
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return;
		}

		String author = webFormData.getValueSilently("docauthor")
		def struct = ses.getStructure()
		def emp = struct.getEmployer(doc.getAuthorID())

		doc.form = "kip"
		doc.addFile("rtfcontent", webFormData)
		String docdate = webFormData.getValueSilently("docdate")


		Date tDate = null
		if(docdate != "")
			tDate = _Helper.convertStringToDate(docdate)
		doc.addDateField("docdate", tDate);

		//doc.addStringField("docauthor", author)
		doc.addStringField("report", webFormData.getValueSilently("report"))

		doc.addEditor(doc.getAuthorID());
		doc.addReader(doc.getAuthorID())

		def returnURL = ses.getURLOfLastPage()
		if (doc.isNewDoc){
			doc.addStringField("mailnotification", "")
			returnURL.changeParameter("page", "0");
		}
        setRedirectURL(returnURL)

        doc.setViewText(emp.getShortName() +" " + doc.getValueString('docdate') + " " + emp.getShortName() + "  (" + doc.getValueString('report')+ ")")

        //setParentDocReadyToReset(doc);
		def parentDoc = doc.getParentDocument()
        // добавляем читателей головной заявки в читатели КИ
        doc.addReaders(parentDoc.getReaders());
		def control = (_Control)parentDoc.getValueObject("control")
		if(!parentDoc.getField("responsible") || parentDoc.getValueString('responsible') == doc.getAuthorID() || parentDoc.getValueString("responsible") == ''){
			control.setAllControl(_AllControlType.READY_TO_RESET)
			parentDoc.setViewText(2, 4)
			parentDoc.save("[supervisor]")
		}
		parentDoc.save("[supervisor]")

    }

    def setParentDocReadyToReset(_Document doc){

        try{
            def parentDoc = doc.getParentDocument();
            if(parentDoc.getDocumentForm() == "demand"){
                def control = (_Control)parentDoc.getValueObject("control")
                ((_Control)control).setAllControl(_AllControlType.READY_TO_RESET)
                parentDoc.setViewText(control.getAllControl(), 4)
                parentDoc.save("[supervisor]");
                setParentDocReadyToReset(parentDoc);
            }
        }catch(Exception e){}
    }
}
