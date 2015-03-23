package finplanning.form.income

import kz.nextbase.script._Document
import kz.nextbase.script._WebFormData


class Income {

	public static final List <String> REQUIRED_FIELDS = ["category", "summa"]

	def doc
	// поля документа
	private String vn
	private Date date // дата события
	private String repeat // периодичность возникновения события
	private int category // категория
	private int subCategory // подкатегория
	private int recipient // получатель\отправитель
	private BigDecimal sum // сумма
	private int costCenter // место возникновения
	private String basis // основание
	private int targetCash // Целевая касса
	// rtfcontent

	private Income(_Document doc) {
		this.doc = doc

		doc.setForm("income")
		if(!doc.isNewDoc){
			fillFields()
		}
	}

	public static Income of(_Document doc){
		return new Income(doc)
	}

	private void fillFields(){
		vn = doc.getValueString("vn")
		date = doc.getValueDate("date")
		repeat = doc.getValueString("repeat")
		category = doc.getValueNumber("category")
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
		if(doc.getField("targetcash") != null){
			targetCash = doc.getValueNumber("targetcash")
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

	def setRepeat(String repeat){
		this.repeat = repeat
		doc.addStringField("repeat", repeat)
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

	def setTargetCash(int targetCash){
		this.targetCash = targetCash
		doc.addNumberField("targetcash", targetCash)
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
