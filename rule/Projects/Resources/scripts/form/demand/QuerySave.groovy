package form.demand

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave
import kz.nextbase.script.task._Control
import java.text.DateFormat
import java.text.SimpleDateFormat

class QuerySave extends _FormQuerySave {

    def validate(_WebFormData webFormData) {

        if (webFormData.getValueSilently("executer") == "") {
            localizedMsgBox("Поле \"Исполнитель\" не выбрано.")
            return false;
        }
        if (webFormData.getValueSilently("startdate") == "") {
            localizedMsgBox("Поле \"Приступить к работе с\" не заполнено.")
            return false;
        }
        if (webFormData.getValueSilently("demand_type") == "") {
            localizedMsgBox("Поле \"Тип заявки\" не выбрано.")
            return false;
        }
        if (webFormData.getValueSilently("ctrldate") == "") {
            localizedMsgBox("Поле \"Срок исполнения\" не указано.")
            return false;
        }

        if (webFormData.getValueSilently("priority") == "") {
            localizedMsgBox("Поле \"Приоритет\" не указано.")
            return false;
        }
        if (webFormData.getValueSilently("complication") == "") {
            localizedMsgBox("Поле \"Коэффициент сложности\" не указано.")
            return false;
        }
        if (_Helper.removeHTMLTags(webFormData.getValueSilently("briefcontent")).length() == 0) {
            localizedMsgBox("Поле \"Содержание\" не заполнено.")
            return false;
        }
        if (webFormData.getValueSilently("briefcontent") == "") {
            localizedMsgBox("Поле \"Содержание\" не заполнено.")
            return false;
        }
        if (webFormData.getValueSilently("parentdocid") == "0") {
            localizedMsgBox("Поле \"Проект\" не выбрано.")
            return false;
        }
        if (webFormData.getValueSilently('briefcontent').length() > 2046) {
            localizedMsgBox('Поле \'Содержание\' содержит значение превышающее 2046 символов');
            return false;
        }

        return true;
    }

    @Override
    public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

        println(webFormData)

        boolean v = validate(webFormData)
        if (v == false) {
            stopSave()
            return;
        }

        doc.setForm("demand")
		def plainFormatter = DateFormat.instance
		def today = new Date().format("dd.MM.yyyy HH:mm:ss")
        def executers = webFormData.getListOfValuesSilently("executer")
        doc.replaceListField("executer", executers as ArrayList);

        String priority = webFormData.getValueSilently("priority")
        doc.addStringField("priority", priority)
        String complication = webFormData.getValueSilently("complication")
        doc.addStringField("responsible", webFormData.getValueSilently("responsible"))
        doc.addStringField("complication", complication)
        doc.addStringField("briefcontent", webFormData.getValueSilently("briefcontent"))
        doc.addStringField("projectname", webFormData.getValueSilently("projectname"))
        doc.addStringField("projectID", webFormData.getValueSilently("projectID"))
        doc.addStringField("projectDocID", webFormData.getValueSilently("projectDocID"))
        doc.addStringField("iserror", webFormData.getValueSilently("iserror"))
        doc.addStringField("publishforcustomer", webFormData.getValueSilently("publishforcustomer"))
        doc.addStringField("demand_type", webFormData.getValueSilently("demand_type"))

        def parentID = webFormData.getNumberValueSilently("parentdocid", -1)
        doc.setParentDocID(parentID);
        String author = ses.getCurrentUserID()

        doc.addStringField("docauthor", author)
        doc.addFile("rtfcontent", webFormData)
        def executers_shortname = new ArrayList();
        for (String executer : executers) {
            doc.addReader(executer);
            executers_shortname.add(ses.getStructure().getEmployer(executer).shortName)
        }

        /*
        def pdoc = doc.getParentDocument();
        // looking for parent project document
        while (true) {
            if (pdoc == null) {
                break;
            } else if (pdoc.getDocumentForm() == "project")
                break;
            else
                pdoc = pdoc.getParentDocument()
        }

        def project_name = ""

        if (pdoc != null) {
            doc.addReader(pdoc.getValueString("docauthor"))
            project_name = pdoc.getValueString("project_name");

            if (doc.getValueString("publishforcustomer") == "1")
                doc.addReaders(pdoc.getValueList("customer_emp"));
        }
        */

        def struct = ses.getStructure();
        def empcurrent = struct.getEmployer(author);
        def db = ses.getCurrentDatabase();
        def empexec = struct.getEmployer(webFormData.getValueSilently("executer"));
        def redirectURL = ses.getURLOfLastPage();
        def control;

        // piece of code taken from old Support
        String prefixvn = "";
        if (doc.isNewDoc) {
            doc.addNumberField("version", 1)
            int num = db.getRegNumber('key')
            prefixvn = "I-";
            String vnAsText = prefixvn + Integer.toString(num)
            doc.addStringField("vn", vnAsText)
            doc.addStringField("status", "control")
            doc.addStringField("dvn", _Helper.getDateAsString())
            redirectURL.changeParameter("page", "0")
            def startDate = _Helper.convertStringToDate(webFormData.getValue("startdate"))
            control = new _Control(ses, startDate, false, priority.toDouble(), complication.toDouble())
            doc.addDateField("startdate", startDate);
            doc.addDateField("ctrldate", control.getCtrlDate());
        } else {
            control = (_Control) doc.getValueObject("control")
            if (!control.getStartDate()) {
                control.setStartDate(doc.getRegDate())
            }
            int version = doc.getValueNumber("version")
            doc.addNumberField("version", version + 1)

        }
        doc.addField("control", control)
        doc.setViewText(today+"  "+doc.getValueString('vn') + ": " + empcurrent.getShortName() + " -> (" +
                executers_shortname.join(", ") + ") " + doc.getValueString("briefcontent"))
//0
        doc.addViewText(webFormData.getValueSilently("projectname"))//1
        doc.addViewText(webFormData.getNumberValueSilently("remained_days", -1))//2
        doc.addViewText(doc.getValueString("iserror"))    //3
        doc.addViewText(control.getAllContr())//4
        doc.addViewText(empexec.getUserID())//5
        doc.addViewText(doc.getValueString("publishforcustomer"))//6
        doc.addViewText(doc.getAuthorID())//7
        doc.setViewNumber(priority as BigDecimal)
        doc.setViewDate(control.getCtrlDate())
        doc.addEditor(ses.getCurrentAppUser().getUserID());
        setRedirectURL(redirectURL)
        ses.setFlash(doc)
    }
}