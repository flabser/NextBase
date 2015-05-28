package projects.page.calcrating

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._Validator
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.constants._Direction
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.task._Control
import nextbase.groovy.*;

class DoScript extends _DoScript {

	public void doProcess(_Session session, _WebFormData formData, String lang) {

        def executer = formData.getValueSilently("executers");
        println("executer $executer")
        if(executer.trim() == "")  setContent(new _XMLDocument(new _Tag("result", 0)));;

        def cdb = session.getCurrentDatabase();
        def all_docs_condition = "form='demand' and (author='$executer' or viewtext5~'$executer') and regdate#datetime > '2015-01-01 00:00:00'";
        def all_docs = cdb.getCollectionOfDocuments(all_docs_condition, 1, 2000, false, "regdate", _Direction.DESCENDING);
        double all_docs_weight = 0.0;
      //  println("Исполнитель: $executer; все заявки: ")
        all_docs.getEntries().each {
            def this_doc = it.getDocument();
            def control = (_Control) this_doc.getValueObject("control")
            def this_doc_weight = control.control.getComplication()/25 + control.control.getPriority()*0.05;
            if(control.getCtrlDate().before(new Date()) && this_doc.doc.getViewTextList()[4] == "1"){
                int diffDays = control.getDiffBetweenDays(new Date());
                //println("  >заявка просрочена на " +  diffDays + "дней; вес: $this_doc_weight " + diffDays * 0.08 + "(за просрочку)")
                this_doc_weight += diffDays * 0.08;
            }
            all_docs_weight += this_doc_weight;
        }
      //  println("  всего заявок: " + all_docs.getEntries().size() + "; вес заявок: $all_docs_weight")

        String author_docs_condition = "form='demand' and author='$executer' and (viewtext4 = '1' or viewtext4 = '2' or viewtext4 = '3') and regdate#datetime > '2015-01-01 00:00:00'";
        def author_docs = cdb.getCollectionOfDocuments(author_docs_condition, 1, 2000, false, "regdate", _Direction.ASCENDING);
        double author_docs_weight = 0.0;
      //  println("Заявки не снятые с контроля, где $executer является автором: ")
        author_docs.getEntries().each {
            def this_doc = it.getDocument();
            def control = (_Control) this_doc.getValueObject("control")
            def this_doc_weight = control.control.getComplication()/25 + control.control.getPriority()*0.05;
            if(control.getCtrlDate().before(new Date()) && this_doc.doc.getViewTextList()[4] == "1"){
                int diffDays = control.getDiffBetweenDays(new Date());
               // println("  >заявка просрочена на " +  diffDays + "дней; вес: $this_doc_weight " + diffDays * 0.08 + "(за просрочку)")
                this_doc_weight += diffDays * 0.08;
            }
            author_docs_weight += this_doc_weight;
        }
      //  println("  всего заявок: " + author_docs.getEntries().size() + "; вес заявок: $author_docs_weight")

        String executer_docs_condition = "form='demand' and viewtext5~'$executer' and (viewtext4 = '1' or viewtext4 = '2' or viewtext4 = '3') and regdate#datetime > '2015-01-01 00:00:00'";
        def executer_docs = cdb.getCollectionOfDocuments(executer_docs_condition, 1, 2000, false, "regdate", _Direction.ASCENDING);
        double executer_docs_weight = 0.0;
      //  println("Заявки не снятые с контроля, где $executer является исполнителем: ")
        executer_docs.getEntries().each {
            def this_doc = it.getDocument();
            def control = (_Control) this_doc.getValueObject("control")
            def this_doc_weight = control.control.getComplication()/25 + control.control.getPriority()*0.05;
            if(control.getCtrlDate().before(new Date()) && this_doc.doc.getViewTextList()[4] == "1"){
                int diffDays = control.getDiffBetweenDays(new Date());
                //println("  >заявка просрочена на " +  diffDays + "дней; вес: $this_doc_weight " + diffDays * 0.08 + "(за просрочку)")
                this_doc_weight += diffDays * 0.08;
            }
            executer_docs_weight += this_doc_weight;
        }
      //  println("  всего заявок: " + executer_docs.getEntries().size() + "; вес заявок: $executer_docs_weight")

        double rating = all_docs_weight - author_docs_weight*0.2 - executer_docs_weight*0.5;

        def emp = session.getStructure().getEmployer(executer)
       // println("Рейтинг: " + Math.round(rating));
        def tagResult = new _Tag("result", Math.round(rating));
        tagResult.setAttr("shortName", emp.getShortName());
        setContent(new _XMLDocument(tagResult));
	}
}
