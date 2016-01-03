package kz.nextbase.script;

/**
 * wrapp a Enum to publish as XML
 *
 * @author Kayra created 03-01-2016
 */

public class _EnumWrapper<T> implements _IXMLContent {
	private T[] enumObj;
	private String lang;
	private boolean toTranslate;

	public _EnumWrapper(T[] enumObj) {
		this.enumObj = enumObj;
	}

	public _EnumWrapper(T[] enumObj, String lang) {
		this.enumObj = enumObj;
		this.lang = lang;
		toTranslate = true;
	}

	@Override
	public String toXML() throws _Exception {
		StringBuffer res = new StringBuffer(1000).append("<constants>");
		for (T e : enumObj) {
			res.append("<entry>" + e + "</entry>");
		}
		return res.append("</constants>").toString();
	}
}
