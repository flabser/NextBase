package bankfinance.form.bank_operation

import kz.nextbase.script._Document
import kz.nextbase.script._WebFormData


class BankOperation {

	public static final List <String> REQUIRED_FIELDS = [
		"bank_account",
		"category",
		"summa",
		"recipient"
	]

	def doc
	// поля документа
	private String vn
	private Date date // Дата операции
	private String bankAccount // bank_account
	private int category // Тип операции категория
	private int subCategory // Тип операции подкатегория
	private int recipient // получатель\отправитель
	private BigDecimal sum // сумма
	private int costCenter // место возникновения
	private String basis // основание
	private String requisites // requisites
	private int documented // documented
	// rtfcontent

	private BankOperation(_Document doc) {
		this.doc = doc

		doc.setForm("bank_operation")
		if(!doc.isNewDoc){
			fillFields()
		}
	}

	public static BankOperation of(_Document doc){
		return new BankOperation(doc)
	}

	private void fillFields(){
		vn = doc.getValueString("vn")
		date = doc.getValueDate("date")
		bankAccount = doc.getValueString("bank_account")
		if(doc.getField("category") != null){
			category = doc.getValueNumber("category")
		}
		if(doc.getField("subcategory") != null){
			subCategory = doc.getValueNumber("subcategory")
		}
		if(doc.getField("recipient") != null){
			recipient = doc.getValueNumber("recipient")
		}
		sum = doc.getValueNumber("summa")
		if(doc.getField("costcenter") != null){
			costCenter = doc.getValueNumber("costcenter")
		}
		basis = doc.getValueString("basis")
		if(doc.getField("requisites") != null){
			requisites = doc.getValueString("requisites")
		}
		if(doc.getField("documented") != null){
			documented = doc.getValueNumber("documented")
		}
	}

	def setVn(String vn){
		this.vn = vn
		doc.addStringField("vn", vn)
		return this
	}

	def setDate(Date date){
		this.date = date
		doc.addDateField("date", date)
		return this
	}

	def setBankAccount(String bankAccount){
		this.bankAccount = bankAccount
		doc.addStringField("bankAccount", bankAccount)
		return this
	}

	int getCatID(){
		if(subCategory > 0){
			return subCategory
		}

		return category
	}

	def setCategory(int category){
		this.category = category
		doc.addNumberField("category", category)
		return this
	}

	def setSubCategory(int subCategory){
		this.subCategory = subCategory
		doc.addNumberField("subcategory", subCategory)
		return this
	}

	def setRecipient(int recipient){
		this.recipient = recipient
		doc.addNumberField("recipient", recipient)
		return this
	}

	def setSum(BigDecimal sum){
		this.sum = sum
		doc.addNumberField("summa", sum)
		return this
	}

	def setCostCenter(int costCenter){
		this.costCenter = costCenter
		doc.addNumberField("costcenter", costCenter)
		return this
	}

	def setBasis(String basis){
		this.basis = basis
		doc.addStringField("basis", basis)
		return this
	}

	def setRequisites(String requisites){
		this.requisites = requisites
		doc.addStringField("requisites", requisites)
		return this
	}

	def setDocumented(int documented){
		this.documented = documented
		doc.addNumberField("documented", documented)
		return this
	}

	def addFile(_WebFormData webFormData){
		doc.addFile("rtfcontent", webFormData)
	}

	def validateRequired(){
		return ["":""]
	}

	@Override
	public String toString(){
		return vn
	}
}
