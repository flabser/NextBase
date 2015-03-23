package page.prjs_delete_document

import kz.nextbase.script.*
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.task._Control

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)

		def deletedList = []
		def unDeletedList = []

		def db = session.getCurrentDatabase()
        def cuser = session.getCurrentAppUser();
		def documentid_col = formData.getListOfValuesSilently("docid")
		for(def id:documentid_col){
			if (id == "null"){
				unDeletedList << new _Tag("entry","error=docid is \"null\"")
			}else{
				try{
					def doc = db.getDocumentByID(id)
					def viewText = doc.getViewText()
                    println(doc.getDocumentForm())
                    if(doc.getDocumentForm() != 'kip' && cuser.hasRole("supervisor"))  {
                        try{
                            if(db.deleteDocument(id, true)){
                                deletedList << new _Tag("entry",viewText)
                            }else{
                                unDeletedList << new _Tag("entry",viewText)
                            }
                        }catch(Exception e){
                            println(e)
                            unDeletedList << new _Tag("entry",viewText)
                        }
                    }else if(doc.getDocumentForm() == 'kip'){
                        try{
                            def parentDemand = doc.getParentDocument();
                            if(db.deleteDocument(id, true)){
                                deletedList << new _Tag("entry",viewText)
                                def resp = parentDemand.getResponses()//doc.getResponses(parentDemand.getDocID(), parentDemand.getDocType(), Const.sysGroupAsSet, "supervisor");
                                boolean hasKi = false;
                                for(_doc in resp){
                                    if(_doc.documentForm == 'kip'){ hasKi = true; break;}
                                }
                                if(!hasKi) {
                                    def control = (_Control)parentDemand.getValueObject("control")
                                    control.setAllControl(_AllControlType.ACTIVE)
                                    parentDemand.setViewText(control.getAllControl(), 4)
                                    parentDemand.save("[supervisor]")
                                }
                            }else{
                                unDeletedList << new _Tag("entry",viewText)
                            }
                        }catch(Exception e){
                            println(e)
                            unDeletedList << new _Tag("entry",viewText)
                        }
                    } else {
                        throw new _Exception("У вас нет прав для удаления документа: " + viewText);
                    }
				}catch(_Exception e){
					unDeletedList << new _Tag("entry","error=" + e.getMessage())
				}
			}
		}

		def rootTag = new _Tag(formData.getValue("id"),"")
		def d = new _Tag("deleted",deletedList)
		d.setAttr("count", deletedList.size())
		rootTag.addTag(d)
		def ud = new _Tag("undeleted",unDeletedList)
		ud.setAttr("count", unDeletedList.size())
		rootTag.addTag(ud)

		def xml = new _XMLDocument(rootTag)
		//println(xml)
		setContent(xml);
	}
}
