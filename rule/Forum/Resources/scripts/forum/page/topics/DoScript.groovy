package forum.page.topics

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

/**
 * Created by Bekzat on 4/30/14.
 */
class DoScript  extends _DoScript {
    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {

         def cdb = session.getCurrentDatabase();
    }
}
