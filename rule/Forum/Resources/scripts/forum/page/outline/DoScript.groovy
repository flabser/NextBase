package forum.page.outline

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*;

class DoScript extends _DoScript {
	 
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def list = []

        def navi = new _Outline(getLocalizedWord("Форум",lang), getLocalizedWord("Форум",lang), "forum")
        navi.addEntry(new _OutlineEntry(getLocalizedWord("Избранные",lang), getLocalizedWord("Избранные",lang), "favdocs", "Provider?type=page&id=favdocs&page=0"))
        navi.addEntry(new _OutlineEntry(getLocalizedWord("Темы",lang), getLocalizedWord("Темы",lang), "topic", "Provider?type=page&id=topic&page=0"))
        list.add(navi)

		setContent(list)
	}
}