package page.task_report_xls
import jxl.Workbook
import jxl.write.Label
import jxl.write.WritableSheet
import jxl.write.WritableWorkbook
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.task._Control
import kz.nextbase.script.task._ExecsBlocks
import org.apache.commons.lang3.StringUtils

import java.text.SimpleDateFormat

class TaskReportXLS extends _DoScript {

    @Override
    void doProcess(_Session session, _WebFormData formData, String lang) {

        formData.formData.each {
            println (it.key + " " + it.value[0])
        }




        def db = session.getCurrentDatabase()
        File task_report = new File(_Helper.randomValue + ".xls");
        //File task_report = new File("Report" + ".xls");
        WritableWorkbook workbook = Workbook.createWorkbook(task_report);
        WritableSheet sheet = workbook.createSheet("Sheet 1", 0);

        SimpleDateFormat format = new SimpleDateFormat("dd.MM.yyyy")
        def glos_cont_type = null
        int c = 1;

        StringBuilder formula = new StringBuilder("form = 'task'")
        String controltype = formData.getValueSilently("controltype");
        if (controltype) {
            formula.append(" and controltype#number = " + controltype)
        }
        String taskdatefrom = formData.getValueSilently("taskdatefrom")
        if (taskdatefrom) {
            formula.append(" and  taskdate#datetime >= '" + taskdatefrom + "'")
        }
        String taskdateto = formData.getValueSilently("taskdateto")
        if (taskdateto) {
            formula.append(" and taskdate#datetime <= '" + taskdateto + "'")
        }
        String taskauthor = formData.getValueSilently("taskauthor")
        if (taskauthor) {
            formula.append(" and taskauthor = '" + taskauthor + "'")
        }


        def col = session.getCurrentDatabase().getCollectionOfDocuments(formula.toString(), false)
        println ("***" + col.count + "***")
        Label label;

        label = new Label(0, 0, "Author")
        sheet.addCell(label)
        label = new Label(1, 0, "Creation Date")
        sheet.addCell(label)
        label = new Label(2, 0, "Executors")
        sheet.addCell(label)
        label = new Label(3, 0, "Responsible executor")
        sheet.addCell(label)
        label = new Label(4, 0, "Briefcontent")
        sheet.addCell(label)
        label = new Label(5, 0, "Type of control")
        sheet.addCell(label)
        label = new Label(6, 0, "Control date")
        sheet.addCell(label)
        label = new Label(7, 0, "Date diff")
        sheet.addCell(label)

        col.entries.each {
            //author

            def doc = it.document;

            def author_emp = session.getStructure().getEmployer(doc.getAuthorID())
            label = new Label(0, c, author_emp.shortName);
            sheet.addCell(label)

            Date regdate = doc.getRegDate()
            if (regdate) {
                label = new Label(1, c, format.format(regdate))
                sheet.addCell(label)
            }

            def exec_block = (_ExecsBlocks)doc.getValueObject("execblock")
            def resp_exec = exec_block.executors.find {it.responsible == 1}

            def execs = exec_block.executors
            def execs_names = execs.collect {it.shortName}
            if (execs_names) {
                label = new Label(2, c, StringUtils.join(execs_names, ", "))
                sheet.addCell(label)
            }

            if (resp_exec) {
                label = new Label(3, c, resp_exec.shortName)
                sheet.addCell(label)
            }

            def content = doc.getValue("briefcontent")[0]
            label  = new Label(4, c, content)
            sheet.addCell(label)

            def cont_type_id = doc.getValueNumber("controltype")
            if (cont_type_id) {
                glos_cont_type  = db.getGlossaryDocument(cont_type_id)
                if (glos_cont_type) {
                    label = new Label(5, c, glos_cont_type.getViewText())
                    sheet.addCell(label)
                }
            }

            def control = (_Control)doc.getValueObject("control")
            Date ctrl_date = control.ctrlDate;
            if (ctrl_date) {
                label = new Label(6, c, format.format(ctrl_date))
                sheet.addCell(label)
            }

            if (control.allControl == _AllControlType.RESET) {
                label = new Label(7, c, "Исполнено")
            } else {
                label = new Label(7, c, String.valueOf(control.diffBetweenDays))
            }
            sheet.addCell(label)
            c++;
        }

        workbook.write();
        workbook.close()

    }
}