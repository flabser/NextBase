package cashtracker.handler.notify

import java.text.SimpleDateFormat

import kz.nextbase.script._Session
import kz.nextbase.script.events._DoScheduledHandler

/**
 * @author mk
 * 
 * Рассылка уведомлений по проведенным операциям
 */

class ReportOperationDaily extends _DoScheduledHandler {

	private static final String UPWARDS_ARROW = "\u25B2"
	private static final String DOWNWARDS_ARROW = "\u25BC"
	private static final String RIGHTWARDS_ARROW = "\u25BA"

	@Override
	public int doHandler(_Session session) {

		try {
			boolean isTest = true
			def cdb = session.getCurrentDatabase()

			def recipients = []
			if(isTest){
				recipients = ["medin_84@mail.ru"]
			} else {
				session.getStructure().getAllEmployers().each { emp ->
					if(emp.hasRole("dailymailing")){
						recipients << emp.email
					}
				}

				if(recipients.size() > 0){
					println "no recipients"
					return
				}
			}

			//
			Date currentDate = new Date()
			Calendar calend = Calendar.getInstance()
			calend.setTime(currentDate)
			calend.add(Calendar.DAY_OF_MONTH, -1)
			Calendar calendNext = Calendar.getInstance()
			calendNext.setTime(currentDate)

			SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd")
			String strCurrentDate = sqlDateFormat.format(calend.getTime())
			String strNextDate = sqlDateFormat.format(calendNext.getTime())

			SimpleDateFormat dftodatestr = new SimpleDateFormat("dd.MM.yyyy")
			String todatestr = dftodatestr.format(calend.getTime())
			//
			String sf
			if(isTest){
				sf = "form in ('operation', 'accrual') and (regdate>='2014-05-07' and regdate<'2014-05-08')"
			} else {
				sf = "form in ('operation', 'accrual') and (regdate>='$strCurrentDate' and regdate<'$strNextDate')"
			}

			println "query: $sf"

			def viewParam = session.createViewEntryCollectionParam()
			def collection = cdb.getCollectionOfDocuments(viewParam.setQuery(sf).setPageSize(0))

			if(collection.getCount() == 0){
				println "0"
				return
			}

			//
			StringBuilder body = new StringBuilder()

			String bodyHeader = """<b><font color="#000080" size="4" face="Default Serif">Произведенные операции от ${todatestr}</font></b><hr /><br />
<span style="color:green;">$UPWARDS_ARROW</span> - приход;
<span style="color:red;">$DOWNWARDS_ARROW</span> - расход;
<span style="color:blue;">$RIGHTWARDS_ARROW</span> - перевод;
<span style="color:orange;">$DOWNWARDS_ARROW</span> - начисление;
<br />
<table cellspacing="0" cellpadding="4" border="0" style="padding:5px;font-size:13px;font-family:Arial;">
 <tr>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="23px"> </td>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="73px">№</td>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="140px">Дата операции</td>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="100px">Касса</td>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="90px">Сумма</td>
  <td style="border-bottom:2px solid #CCC;text-align:center;">Тип операции</td>
  <td style="border-bottom:2px solid #CCC;text-align:center;" width="150px">Применено к</td>
 </tr>"""

			String bodyFooter = "</table>"
			//

			collection.getEntries().each {
				def doc = it.getDocument()
				def gdoc
				def pick = ""
				String color = ""

				def vn = doc.getValueString("vn")
				def opdate = doc.getValueString("date")
				def summa = doc.getValueString("summa")
				def personal = doc.getValueString("personal")
				def cash = ""
				def category = ""
				String typeoperation
				def targetcash

				summa = summa.toString().replaceAll(/(\d)(?=(\d\d\d)+([^\d]|$))/, '$1 ')

				if( doc.getDocumentForm().equals("accrual") ){
					typeoperation = doc.getValueString("typeoperationstaff")
					category = doc.getValueString("typeoperationstaff")
					pick = DOWNWARDS_ARROW
					color = "orange"

					gdoc = cdb.getGlossaryDocument(Integer.parseInt(typeoperation))
					typeoperation = gdoc.getValueString("name")

				} else {
					cash = doc.getValueString("cash")
					category = doc.getValueString("category")

					if(cash.length()>0){
						gdoc = cdb.getGlossaryDocument(Integer.parseInt(cash))
						cash = gdoc.getValueString("name")
					}

					typeoperation = doc.getValueString("typeoperation")
					if(typeoperation == "in"){
						pick = UPWARDS_ARROW
						color = "green"
					} else if(typeoperation == "out"){
						pick = DOWNWARDS_ARROW
						color = "red"
					} else if(typeoperation == "transfer"){
						pick = RIGHTWARDS_ARROW
						color = "blue"

						targetcash = doc.getValueString("targetcash")
						if(targetcash.length() > 0){
							gdoc = cdb.getGlossaryDocument(Integer.parseInt(targetcash))
							personal = gdoc.getValueString("name")
						} else {
							personal = "<span style='color:red;'>ошибка: целевая касса не указана</span>"
						}
					} else {
						pick = ""
						color = ""
					}

					gdoc = cdb.getGlossaryDocument(Integer.parseInt(category))
					typeoperation = gdoc.getValueString("name")
				}

				body.append("""<tr>
  <td valign="top" style="border-top:1px solid #CCC;text-align:center;margin:0;padding:0;"><span style="color:$color;">$pick</span></td>
  <td valign="top" style="border-top:1px solid #CCC;border-right:1px solid #CCC;text-align:center;">$vn</td>
  <td valign="top" style="border-top:1px solid #CCC;border-right:1px solid #CCC;text-align:center;"><a href="${doc.getFullURL()}">$opdate</a></td>
  <td valign="top" style="border-top:1px solid #CCC;border-right:1px solid #CCC;">$cash</td>
  <td valign="top" style="border-top:1px solid #CCC;border-right:1px solid #CCC;text-align:right;">$summa</td>
  <td valign="top" style="border-top:1px solid #CCC;border-right:1px solid #CCC;">$typeoperation</td>
  <td valign="top" style="border-top:1px solid #CCC;">$personal</td>
</tr>""")
			}

			if(body.length() > 0){
				if(isTest){
					println "$bodyHeader ${body.toString()} $bodyFooter"
					println collection.count
				}
				session.getMailAgent().sendMail(recipients, "Уведомление о произведенных ($collection.count) операциях от $todatestr", "$bodyHeader $body $bodyFooter")
			}
		} catch(Exception e) {
			e.printStackTrace()
		}
	}
}
