package forum.page.current_outline_entry

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
   
		def rootTag = new _Tag()
		
		def entryTag = new _Tag("entry",getLocalizedWord(formData.getEncodedValueSilently("title"), lang))
		def id = formData.getValueSilently("id");
		if(id == 'faq'){
			id = "category" + formData.getValueSilently("category");
		} 
		entryTag.setAttr("pageid", id)
		
		entryTag.setAttr("entryid",formData.getValueSilently("entryid"))
		rootTag.addTag(entryTag)
		
		def xml = new _XMLDocument(rootTag)
		setContent(xml);
	
	}

}
