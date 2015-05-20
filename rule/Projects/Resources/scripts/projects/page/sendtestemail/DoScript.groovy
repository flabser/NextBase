package projects.page.sendtestemail

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

import java.util.regex.Pattern

/**
 * Created by Bekzat on 6/19/14.
 */
class DoScript extends _DoScript {
    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {

        def rootTag = null;
        if(formData.getValue("t").equals("IM"))
            rootTag =  testIM(session, lang);
        else
            rootTag = testMail(session, lang);

        setContent(new _XMLDocument(rootTag));
    }

    def testIM(_Session session, String lang){

        def rootTag = new _Tag("result");
        def body = "Это сообщение было отправлено для проверки IM адреса.";
        def im = session.getInstMessengerAgent();
        boolean isSent = im.sendMessage([session.getCurrentAppUser().getInstMessengerAddr()], body);

        if(isSent)
            rootTag.setAttr("msg", getLocalizedWord("Сообщение на " + session.getCurrentAppUser().getInstMessengerAddr() + " отправлено", lang));
        else
            rootTag.setAttr("msg", getLocalizedWord("Сбой при отправке сообщении", lang));

        return rootTag;
    }

    def testMail(_Session session, String lang){

        def rootTag = new _Tag("result");
        def emailPattern = Pattern.compile("^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})");
        String email = session.getCurrentAppUser().getEmail();
        if(emailPattern.matcher(email)){
            try{
                def ma = session.getMailAgent();
                def body = "Это сообщение было отправлено для проверки email адреса.<br/>";
                // body+= "Если Вы получили это письмо по ошибке, пожалуйста, игнорируйте его.";

                boolean isSent = ma.sendMail([email], "4ms Тестовое сообщение", body);
                if(isSent)
                    rootTag.setAttr("msg", getLocalizedWord("Сообщение на " + email + " отправлено", lang));
                else
                    rootTag.setAttr("msg", getLocalizedWord("Сбой при отправке сообщении", lang));
            }catch (Exception e){
                rootTag.setAttr("msg", getLocalizedWord("Сообщение не отправлено", lang));
            }
        }   else{
            rootTag.setAttr("msg", getLocalizedWord("Некорректный e-mail", lang));
        }

        return rootTag;
    }
}
