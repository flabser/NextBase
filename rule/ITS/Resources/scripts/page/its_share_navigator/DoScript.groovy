package page.its_share_navigator

import java.util.Map;
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*;

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(lang)
		def list = []
		def user = session. getCurrentAppUser()
		def outline = new _Outline("", "", "outline")

		def orgdocs_outline = new _Outline(getLocalizedWord("Производство",lang), getLocalizedWord("Производство",lang), "factory")
		orgdocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Выпуск продукции",lang), getLocalizedWord("Выпуск продукции",lang), "outputproduction", "Provider?type=page&id=outputproduction&page=0"))
		outline.addOutline(orgdocs_outline)
		list.add(orgdocs_outline)

		if (user.hasRole("administrator")){
			def glossary_outline = new _Outline(getLocalizedWord("Справочники",lang), getLocalizedWord("Справочники",lang), "glossary")
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Поставщик",lang), getLocalizedWord("Поставщик",lang), "supplier", "Provider?type=page&id=supplier"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Сырье и детали",lang), getLocalizedWord("Сырье и детали",lang), "raw", "Provider?type=page&id=raw"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Продукт",lang), getLocalizedWord("Продукт",lang), "product", "Provider?type=page&id=product"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Единица измерения нормы расхода",lang), getLocalizedWord("Единица измерения нормы расхода",lang), "norm", "Provider?type=page&id=ednorm"))
			outline.addOutline(glossary_outline)
			list.add(glossary_outline)
		}
		
		def add_outline = new _Outline(getLocalizedWord("Прочее",lang), getLocalizedWord("Прочее",lang), "add")
		add_outline.addEntry(new _OutlineEntry(getLocalizedWord("Корзина",lang), getLocalizedWord("Корзина",lang), "recyclebin", "Provider?type=page&id=recyclebin"))
		outline.addOutline(add_outline)
		list.add(add_outline)
		
		setContent(list)
	}
}
