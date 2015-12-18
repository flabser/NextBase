package kz.nextbase.script;

import java.util.List;

import kz.flabs.users.RunTimeParameters;
import kz.flabs.users.RunTimeParameters.Filter;
import kz.flabs.users.RunTimeParameters.Sorting;

public class _POJOListWrapper<T extends _IXMLContent, K> implements _IXMLContent {
	private int maxPage;
	private int count;
	private int currentPage;
	private List<T> list;
	private static final String viewTextFileds[] = { "viewtext", "viewtext1", "viewtext2", "viewtext3", "viewtext4",
			"viewtext5", "viewtext6", "viewtext7", "viewnumber", "viewdate" };

	public _POJOListWrapper(List<T> list, int maxPage, int count, int currentPage) {
		this.maxPage = maxPage;
		this.count = count;
		this.currentPage = currentPage;
		this.list = list;
	}

	@Override
	public String toXML() throws _Exception {
		RunTimeParameters pars = new RunTimeParameters();
		String vtResult = "";
		if (pars != null) {
			for (String val : viewTextFileds) {
				vtResult += "<" + val + ">";
				Sorting sorting = pars.sortingMap.get(val);
				if (sorting != null) {
					vtResult += "<sorting mode=\"ON\" order=\"" + sorting.sortingDirection + "\"/>";
				} else {
					vtResult += "<sorting mode=\"OFF\"/>";
				}

				Filter filter = pars.filtersMap.get(val);
				if (filter != null) {
					vtResult += "<filter mode=\"ON\" keyword=\"" + filter.keyWord.replace("\"", "'") + "\"/>";
				} else {
					vtResult += "<filter mode=\"OFF\"/>";
				}

				vtResult += "</" + val + ">";
			}
		}

		String result = "<query maxpage=\"" + maxPage + "\" count=\"" + count + "\" currentpage=\"" + currentPage
				+ "\">";
		result += "<columns>" + vtResult + "</columns>";
		for (T val : list) {
			result += val.toXML();
		}
		return result + "</query>";
	}

}
