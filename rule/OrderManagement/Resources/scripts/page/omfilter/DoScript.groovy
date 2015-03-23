package page.omfilter

import kz.nextbase.script._Exception
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

/**
 * Created by Bekzat on 3/28/14.
 */
class DoScript extends _DoScript {
    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {
        def rootTag = new _Tag()

        def customersTag = new _Tag("customers","")
        def col = session.currentDatabase.getGroupedEntries("customer",1,100)
        col.each{
            def viewEntry = (_ViewEntry)it;
            try{
                def doc = session.currentDatabase.getDocumentByID(viewEntry.getViewText(0));
                def entryTag = new _Tag("entry",doc.getViewText())
                entryTag.setAttr("id",viewEntry.getViewText(0))
                customersTag.addTag(entryTag)
            }catch(_Exception e){

            }
        }
        rootTag.addTag(customersTag)

        def responsiblePersonTag = new _Tag("executers","")
        def rcol = session.currentDatabase.getGroupedEntries("responsiblePerson",1,100)
        rcol.each{
            def viewEntry = (_ViewEntry)it;
            try{
                def doc = session.structure.getEmployer(viewEntry.getViewText(0))
                def entryTag = new _Tag("entry",viewEntry.getViewText(0))
                if(doc.shortName != ''){
                    entryTag = new _Tag("entry",doc.shortName)
                }
                entryTag.setAttr("id",viewEntry.getViewText(0))
                responsiblePersonTag.addTag(entryTag)
            }catch(_Exception e){

            }
        }
        rootTag.addTag(responsiblePersonTag)

        //responsiblePerson
        def xml = new _XMLDocument(rootTag)
        setContent(xml);
    }
}
