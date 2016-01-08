package kz.nextbase.script;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class _POJOListWrapper<T extends _IPOJOObject> implements _IXMLContent {
	private int maxPage;
	private long count;
	private int currentPage;
	private List<T> list;

	public _POJOListWrapper(List<T> list, int maxPage, long count, int currentPage) {
		this.maxPage = maxPage;
		this.count = count;
		this.currentPage = currentPage;
		this.list = list;
	}

	public _POJOListWrapper(List<T> list) {
		this.count = list.size();
		this.list = list;
		maxPage = 1;
		currentPage = 1;
	}

	public _POJOListWrapper(String msg) {
		this.count = 0;
		List<T> l = new ArrayList<T>();
		l.add((T) new SimplePOJO(msg));
		this.list = l;
	}

	@Override
	public String toXML() throws _Exception {
		String entityType = "undefined";
		try {
			final Class<T> listClass = (Class<T>) list.get(0).getClass();
			entityType = listClass.getSimpleName().toLowerCase();
		} catch (ArrayIndexOutOfBoundsException e) {

		}

		String result = "<query entity=\"" + entityType + "\"  maxpage=\"" + maxPage + "\" count=\"" + count + "\" currentpage=\"" + currentPage
		        + "\">";
		for (T val : list) {
			result += "<entry isread=\"1\" hasattach=\"0\" id=\"" + val.getId() + "\" " + "url=\"" + val.getURL() + "\"><viewcontent>";
			result += val.getShortXMLChunk() + "</viewcontent></entry>";
		}
		return result + "</query>";
	}

	class SimplePOJO implements _IPOJOObject {
		private String msg;

		SimplePOJO(String msg) {
			this.msg = msg;
		}

		@Override
		public UUID getId() {
			return null;
		}

		@Override
		public _URL getURL() {
			return new _URL("");
		}

		@Override
		public boolean isEditable() {
			return false;
		}

		@Override
		public String getFullXMLChunk() {
			return "<message>" + msg + "</message>";
		}

		@Override
		public String getShortXMLChunk() {
			return getFullXMLChunk();
		}

	}

}
