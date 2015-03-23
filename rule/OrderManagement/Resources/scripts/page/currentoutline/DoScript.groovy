package page.currentoutline

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript

/**
 * @author Bekzat
 * @date 28.01.2014
 */
class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

        def entryTag;
        if(formData.getValueSilently("id") == "order_by_leftPayment")
            entryTag = new _Tag("entry",getLocalizedWord("Остаток", lang) + ": "+ formData.getEncodedValueSilently("title"));
        else
		    entryTag = new _Tag("entry",getLocalizedWord(formData.getEncodedValueSilently("title"), lang));

		entryTag.setAttr("pageid",formData.getValueSilently("id"))
		entryTag.setAttr("entryid",formData.getValueSilently("entryid"))

        def rootTag = new _Tag();
        rootTag.addTag(entryTag)
		
		def xml = new _XMLDocument(rootTag)
		setContent(xml);
	}
}
