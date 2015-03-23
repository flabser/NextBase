package cashtracker.page.user

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript


class UserRoles extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		try {
			def struct = session.getStructure()
			def emp = struct.getEmployer(session.getCurrentUserID())
			def roles = emp.getListOfRoles()

			def tag = new _Tag("roles", roles.collect{"'$it'"}.join(","))
			def xml = new _XMLDocument(tag)
			setContent(xml)
		} catch(e) {
			e.printStackTrace()
			println "<roles>error</roles>"
		}
	}
}
