package page.executerslist

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript

/**
 * Created by Bekzat on 1/28/14.
 */

class DoScript extends _DoScript {

    public DoScript(){}
    @Override
    public void doProcess(_Session session, _WebFormData formData, String lang) {

        def rootTag = new _Tag("executers");

        def emplist = session.getStructure().getAllEmployers();
        println(emplist.size());
        emplist.each{
            def entryTag = new _Tag("entry");
            entryTag.setAttr("userid", it.getUserID())
            entryTag.setAttr("viewtext", it.getFullName())
            rootTag.addTag(entryTag);
        }

        def xml = new _XMLDocument(rootTag)
        setContent(xml);
    }
}

