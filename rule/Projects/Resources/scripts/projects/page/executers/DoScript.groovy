package projects.page.executers

import kz.nextbase.script.struct._EmployerStatusType
import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript

/**
 * User: Bekzat
 * Date: 1/10/14
 * Time: 12:55 PM
 */

class DoScript extends _DoScript {

    public DoScript(){}
    @Override
    public void doProcess(_Session session, _WebFormData formData, String lang) {
		
        def cdb = session.getCurrentDatabase();		
        def demand_type = formData.getValueSilently("demand_type")

		def glos = cdb.getGlossaryDocument("demand_type", "ddbid = '$demand_type'"); 
        def rootTag = new _Tag("executers");
		if(glos.getValueString("role")){
			def roleslist = glos.getValueString("role").split("#");
			roleslist.each{ role ->

				def emplist = session.getStructure().getAppUsersByRoles(role);
				emplist.each{
	                if(it.getStatus() != _EmployerStatusType.FIRED){

                        if( it.getUserID() == session.getCurrentUserID()) {
                            if(it.hasRole("support_specialist")){
                                def entryTag = new _Tag("entry");
                                entryTag.setAttr("userid", it.getUserID())
                                entryTag.setAttr("viewtext", it.getFullName())
                                rootTag.addTag(entryTag);
                            }
                        }else{
                            def entryTag = new _Tag("entry");
                            entryTag.setAttr("userid", it.getUserID())
                            entryTag.setAttr("viewtext", it.getFullName())
                            rootTag.addTag(entryTag);
                        }
	                }
				}			  
			}
		}else{
			def emplist = session.getStructure().getAllEmployers()
			emplist.each{
				if(it.getStatus() != _EmployerStatusType.FIRED){
					def entryTag = new _Tag("entry");
					entryTag.setAttr("userid", it.getUserID())
					entryTag.setAttr("viewtext", it.getFullName())
					rootTag.addTag(entryTag);
				}
			}
		}
		 
        def xml = new _XMLDocument(rootTag)
        setContent(xml);
    }
}
