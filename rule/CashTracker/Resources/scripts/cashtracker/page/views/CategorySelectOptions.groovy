package cashtracker.page.views

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import cashtracker.page.util.HTMLUtil


class CategorySelectOptions extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def category = formData.getValueSilently("category")
		def sf
		def formName
		def selectedValue = formData.getValueSilently("value")

		if(category.isEmpty()){
			formName = "category"
			sf = "form = 'category' and category_refers_to != 'bank' and category_refers_to != 'hidden'"
		} else {
			formName = "subcategory"
			sf = "form = 'subcategory' and parentdocid = $category and category_refers_to != 'bank' and category_refers_to != 'hidden'"
		}

		setContent(HTMLUtil.getGlossariesSelectXML(session, formName, sf, "docid", selectedValue, false))
	}
}
