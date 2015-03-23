package bankfinance.form.glossary.simpleform;

import bankfinance.form.FormUtil
import kz.nextbase.script._Document
import kz.nextbase.script._Glossary
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webForm, String lang) {

		def requiredFields = FormUtil.validate(webForm, ["name"])
		if (requiredFields) {
			stopSave()
			msgBox("require:" + requiredFields.join(","))
			return
		}

		def glos = (_Glossary) doc

		glos.setForm(webForm.getValue("id"))
		glos.setName(webForm.getValue("name"))

		int code = webForm.getNumberValueSilently("code", -999)
		if(code != -999){
			glos.setCode(String.valueOf(code));
			glos.setViewNumber(code)
		}

		glos.setViewText(glos.getName())

		setRedirectURL(session.getURLOfLastPage())
	}
}
