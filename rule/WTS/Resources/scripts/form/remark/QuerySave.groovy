package form.remark

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave
import kz.nextbase.script.project._Block
import kz.nextbase.script.project._Project

class QuerySave extends _FormQuerySave {

    @Override
    public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

        println(webFormData)

        def prj = (_Project) doc;
        prj.setForm("remark")
        prj.setResponsiblePost(webFormData.getValueSilently("respost"))
        prj.setAmountDamage(webFormData.getValueSilently("amountdamage"))
        prj.setSender(webFormData.getValueSilently("sender"))
        prj.setOrigin(webFormData.getNumberValueSilently("origin", 0).toString())
        prj.setProject(webFormData.getNumberValueSilently("project", 0))
        prj.setCategory(webFormData.getNumberValueSilently("category", 0))
        prj.setSigner(webFormData.getValueSilently("signer"))
        prj.setResponsibleSection(webFormData.getValueSilently("responsible"))
        prj.setProjectDate(_Helper.convertStringToDate(webFormData.getValueSilently("projectdate")))
        prj.setRecipients(webFormData.getListOfValuesSilently("recipient"))
        prj.setDocVersion(webFormData.getNumberValueSilently("docversion", -1))
        prj.setBriefContent(webFormData.getValueSilently("briefcontent"))
        prj.setCoordStatus(webFormData.getValueSilently("coordstatus"))
        prj.addFile("rtfcontent", webFormData)
        prj.setContentSource(webFormData.getValueSilently("contentsource")) //is it necessary?
        prj.setNomenType(0)
        prj.setDefaultRuleID("remark")
        prj.setCoordinats(webFormData.getValueSilently("coordinats"))
        prj.setCity(webFormData.getNumberValueSilently("city", 0))
        prj.setStreet(webFormData.getValueSilently("street"))
        prj.setHouse(webFormData.getValueSilently("house"))
        prj.setPorch(webFormData.getValueSilently("porch"))
        prj.setFloor(webFormData.getValueSilently("floor"))
        prj.setApartment(webFormData.getValueSilently("apartment"))
        prj.setCtrlDate(_Helper.convertStringToDate(webFormData.getValueSilently("ctrldate")))
        prj.setSubcategory(webFormData.getNumberValueSilently("subcategory", 0))
        prj.setContragent(webFormData.getNumberValueSilently("contragent", 0).toString())
        prj.setAutoSendAfterSign(1)
        prj.setAutoSendToSign(1)
        prj.setDocFolder("")
        prj.setDeliveryType("")
        prj.setRegDocID(0)
        prj.setHar(0)
        prj.setPodryad("")
        prj.setSubpodryad("")
        prj.setExecutor("")

        def bl = webFormData.getListOfValuesSilently("coordBlock")
        if (bl != null) {
            def newBlocks = new ArrayList<_Block>()
            for (String blockVal : bl) {
                def block = _Helper.parseCoordBlock(prj, blockVal)
                newBlocks.add(block)
            }
            prj.setBlocks(newBlocks)
        }

        int prjID = prj.getProject()
        def dataBase = ses.getCurrentDatabase()
        def prjName = dataBase.getGlossaryDocument(prjID)
        def supervisors = prjName.getValueList("techsupervision")
        if (supervisors){
            supervisors.each { supervisor ->
                doc.addReader(supervisor)
            }
        }

        boolean v = true;
        def validate = {
            if (prj.getCategory() == 0) {
                localizedMsgBox("Поле \"Вид работ\" не заполнено.");
                v = false;
            }
            if (!prj.getContragent()) {
                localizedMsgBox("Поле \"Контрагент\" не заполнено.");
                v = false;
            }
            if (prj.getProject() == 0) {
                localizedMsgBox("Поле \" Связан с проектом\" не заполнено.");
                v = false;
            }
            if (!prj.getSigner()) {
                localizedMsgBox("Поле \"Ответственный участка\" не заполнено.");
                v = false;
            }
            if (prj.getValueString("contentsource") == "<br>") {
                localizedMsgBox("Поле \"Описание замечания\" не заполнено.");
                v = false;
            }
            if (prj.getValueString("contentsource") == "") {
                localizedMsgBox("Поле \"Описание замечания\" не заполнено.");
                v = false;
            }
        }
        String action = webFormData.getValue("action");
        if (prj.isNewDoc && action != "draft" || !prj.isNewDoc && prj.getCoordStat() == "draft" && (action == "startcoord" || action == "send")) validate();
        if (v) {
            def struct = ses.getStructure();
            String authorRus = "";
            def events = [];
            def author = struct.getEmployer(prj.getValueString("author"));
            if (author) {
                authorRus = author.getShortName();
            }
            String briefCont = prj.getValueString("briefcontent");
            if (briefCont) {
                briefCont = ", " + briefCont;
            }
            //prj.setValueString("viewtext","Проект служебной записки" + ' ' + authorRus + briefCont);

            //Выбираем необходимое действие над документом
            //Для сохранения в качестве черновика мы просто изменяем статус проекта и всех блоков
            if (action == "draft") {
                prj.setCoordStatus("draft");
                def blocks = prj.getBlocks();
                for (b in blocks) {
                    b.setStatus("awaiting");
                }
                prj.addEditor(author?.getUserID());
            } else {
                //Для отправки на согласование
                if (action == "startcoord") {
                    prj.setCoordStatus('coordinating');
                    def block = prj.getFirstBlock();
                    def coordBlocks = prj.getCoordBlocks();
                    //Присваиваем первому согласовательному блоку статус "На согласовании"
                    if (block && block.getType() != "sign" && block.getType() != "undefined") {
                        block.setStatus("coordinating");
                        if (block.getType() == "pos") {
                            def coord = block.getFirstCoordinator();
                            if (coord) {
                                coord.setCurrent(true);
                                prj.addReader(coord.getUserID());
                            }
                        } else {
                            if (block.getType() == "par") {
                                def coords = block.getCoordinators();
                                coords.each { coord ->
                                    coord.setCurrent(true);
                                    prj.addReader(coord.getUserID());
                                }
                            }
                        }
                    }

                    block = prj.getNextBlock(block);
                    while (block) {
                        block.setStatus("awaiting");
                        block = prj.getNextBlock(block);
                    }
                } else {
                    //Для отправки на подпись
                    if (action == 'send') {
                        println("Документ отправлен на подпись");
                        /*в том случае, если мы создали блоки согласования, но документ сразу же был отправлен
                         на подпись*/
                        def coordBlocks = prj.getCoordBlocks();
                        coordBlocks.each { cb ->
                            if (cb.getStatus() == "undefined") {
                                cb.setStatus("awaiting");
                            }
                        }
                        prj.setCoordStatus('signing');
                        //Делаем текущим подписывателя

                        def block = prj.getSignBlock();
                        if (block) {
                            block.setStatus('coordinating');
                        }
                        def signer = prj.getSigner();
                        if (signer) {
                            signer.setCurrent(true);
                            prj.addReader(signer.getUserID());
                        }
                    }
                }
            }
            if (prj.isNewDoc && prj.getCoordStat() == "draft") {
                prj.addStringField("vn", "0");
                prj.addNumberField("vnnumber", 0);
                prj.addNumberField("isrejected", 0);
                setRedirectView("remarkdraft");
            }
            if (prj.getCoordStat() != "draft" && (prj.isNewDoc || prj.getValueNumber("vnnumber") == 0)) {
                def db = ses.getCurrentDatabase();
                int num = db.getRegNumber('remark');
                // берем префикс выбранного проекта
                String prj_prefix = prj.getGlossaryValue("projectsprav", "docid#number=" + prj.getProject(), "prefix");
                String vnAsText = prj_prefix + Integer.toString(num);
                prj.addStringField("vn", vnAsText);
                prj.addNumberField("vnnumber", num);
                localizedMsgBox("Документ зарегистрирован под № " + vnAsText);
                prj.addNumberField("isrejected", 0);
                //prj.setValueString("viewtext","Проект служебной записки" + ' ' + authorRus + briefCont);

            }
            prj.addReader(author?.getUserID());
        } else {
            stopSave();
        }

        prj.setViewText(getViewText(prj))
        prj.addViewText(getViewText1(prj))
        prj.addViewText(getViewText2(prj))
        prj.setViewDate(prj.getProjectDate());
        prj.setViewNumber(prj.getValueNumber("vnnumber"));

    }

    def String getViewText(_Project prj) {
        String respID = prj.getValueString("responsible");
        def respUser = prj.getSession().getStructure().getEmployer(respID);
        def db = prj.getSession().getCurrentDatabase();
        String postName = "";
        if (respUser) {
            postName = db.getGlossaryDocument(respUser.getPostID())?.getViewText();
            postName = "- " + postName;
        }
        String projectName = "";
        int prjID = prj.getProject();
        if (prjID != 0) {
            projectName = " (" + db.getGlossaryDocument(prjID)?.getViewText() + ")";
        }
        return (respUser?.getShortName() ? respUser.getShortName() + " " + postName : "") + projectName;
    }

    def String getViewText1(_Project prj) {
        def content = prj.getValueString("contentsource");
        content = _Helper.removeHTMLTags(content);
        if (content.length() > 256) {
            content = content.substring(0, 255);
        } else {
            content = ""
        }
        return content;
    }

    def String getViewText2(_Project prj) {
        String authorID = prj.getValueString("author");
        def author = prj.getSession().getStructure().getEmployer(authorID);
        String authorShortName = "";
        if (author) {
            authorShortName = author.getShortName();
        }
        return authorShortName;
    }
}
