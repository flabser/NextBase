package kz.nextbase.script;

import java.util.List;

public class _POJOListWrapper<T extends _IPOJOObject, K> implements _IXMLContent {
	private int maxPage;
	private int count;
	private int currentPage;
	private List<T> list;

	public _POJOListWrapper(List<T> list, int maxPage, int count, int currentPage) {
		this.maxPage = maxPage;
		this.count = count;
		this.currentPage = currentPage;
		this.list = list;
	}

	public _POJOListWrapper(List<T> list, int count) {
		this.count = count;
		this.list = list;
	}

	@Override
	public String toXML() throws _Exception {
		String result = "<query maxpage=\"" + maxPage + "\" count=\"" + count + "\" currentpage=\"" + currentPage
				+ "\">";
		for (T val : list) {
			result += "<entry isread=\"1\" hasattach=\"0\" hasresponse=\"0\" id=\"" + val.getId() + "\" " + "url=\""
					+ val.getURL() + "\"><viewcontent>";
			result += val.toXML() + "</viewcontent></entry>";
		}
		return result + "</query>";
	}

}
