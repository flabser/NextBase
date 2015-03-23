package page.mysupport_current_outline_entry


import java.util.ArrayList;
import java.util.Map;
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
   
		def rootTag = new _Tag()
		
		def entryTag = new _Tag("entry",getLocalizedWord(formData.getEncodedValueSilently("title"), lang))
		 
		entryTag.setAttr("pageid",formData.getValueSilently("id"))
		entryTag.setAttr("entryid",formData.getValueSilently("entryid"))
		rootTag.addTag(entryTag)
		
		def xml = new _XMLDocument(rootTag)
		setContent(xml);
	
	}

}
