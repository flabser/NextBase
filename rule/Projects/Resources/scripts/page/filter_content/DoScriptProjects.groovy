package page.filter_content

import kz.nextbase.script._Exception
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

/**
 * Created by Bekzat on 1/23/14.
 */
class DoScriptProjects extends _DoScript {

    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {

        def rootTag = new _Tag();

        /* Тистировщики */
        def testersTag = new _Tag("testers","")
        def testercol = session.currentDatabase.getGroupedEntries("tester",1,100)

        testercol.each{
            def viewEntry = (_ViewEntry)it;
            try{
                def doc =session.structure.getEmployer(viewEntry.getViewText(0))
                def entryTag = new _Tag("entry",viewEntry.getViewText(0))
                if(doc.shortName != ''){
                    entryTag = new _Tag("entry",doc.shortName)
                }
                entryTag.setAttr("id",viewEntry.getViewText(0))
                testersTag.addTag(entryTag)
            }catch(_Exception e){

            }
        }
        rootTag.addTag(testersTag);

        /* Программисты */
        def programmerTag = new _Tag("programmer","")
        def programmercol = session.currentDatabase.getGroupedEntries("programmer",1,100)

        programmercol.each{
            def viewEntry = (_ViewEntry)it;
            try{
                def doc =session.structure.getEmployer(viewEntry.getViewText(0))
                def entryTag = new _Tag("entry",viewEntry.getViewText(0))
                if(doc.shortName != ''){
                    entryTag = new _Tag("entry",doc.shortName)
                }
                entryTag.setAttr("id",viewEntry.getViewText(0))
                programmerTag.addTag(entryTag)
            }catch(_Exception e){

            }
        }
        rootTag.addTag(programmerTag);

        /* Менеджеры */
        def managerTag = new _Tag("manager","")
        def managercol = session.currentDatabase.getGroupedEntries("manager",1,100)

        managercol.each{
            def viewEntry = (_ViewEntry)it;
            try{
                def doc =session.structure.getEmployer(viewEntry.getViewText(0))
                def entryTag = new _Tag("entry",viewEntry.getViewText(0))
                if(doc.shortName != ''){
                    entryTag = new _Tag("entry",doc.shortName)
                }
                entryTag.setAttr("id",viewEntry.getViewText(0))
                managerTag.addTag(entryTag)
            }catch(_Exception e){

            }
        }
        rootTag.addTag(managerTag);

        def xml = new _XMLDocument(rootTag)
        setContent(xml);
    }
}
