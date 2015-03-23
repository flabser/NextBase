package cashtracker.form.operation

import kz.nextbase.script._Document
import kz.nextbase.script._WebFormData


class Operation {

	def doc
	// поля документа
	private int cash
	private String vn
	private Date date // дата события
	private int category // категория
	private int subCategory // подкатегория
	private BigDecimal sum // сумма
	private int costCenter // место возникновения
	private String basis // основание
	private int targetCash // Целевая касса
	private int documented
	// rtfcontent

	private Operation(_Document doc){
		this.doc = doc

		doc.setForm("operation")
		if(!doc.isNewDoc){
			fillFields()
		}
	}

	public static Operation of(_Document doc){
		return new Operation(doc)
	}

	private void fillFields(){
		cash = doc.getValueNumber("cash")
		vn = doc.getValueString("vn")
		date = doc.getValueDate("date")
		category = doc.getValueNumber("category")
		if(doc.getField("subcategory") != null){
			subCategory = doc.getValueNumber("subcategory")
		}
		sum = doc.getValueNumber("summa")
		if(doc.getField("costcenter") != null){
			costCenter = doc.getValueNumber("costcenter")
		}
		basis = doc.getValueString("basis")
		if(doc.getField("targetcash") != null){
			targetCash = doc.getValueNumber("targetcash")
		}
		if(doc.getField("recipient") != null){
			recipient = doc.getValueNumber("recipient")
		}
		if(doc.getField("documented") != null){
			documented = doc.getValueNumber("documented")
		}
	}

	def setCash(int cash){
		this.cash = cash
		doc.addNumberField("cash", cash)
		return this
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

	def setTargetCash(int targetCash){
		this.targetCash = targetCash
		doc.addNumberField("targetcash", targetCash)
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

	def validate(){
		return ["":""]
	}

	@Override
	public String toString(){
		return vn
	}
}
