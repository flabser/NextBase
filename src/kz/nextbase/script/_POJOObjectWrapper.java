package kz.nextbase.script;

public class _POJOObjectWrapper implements _IXMLContent {
	private _IPOJOObject object;

	public _POJOObjectWrapper(_IPOJOObject object) {
		this.object = object;
	}

	@Override
	public String toXML() throws _Exception {
		return "<document entity=\"" + object.getClass().getSimpleName().toLowerCase() + "\"  docid=\"" + object.getId()
				+ "\" status=\"existing\"><fields>" + object.getXMLChunk() + "</fields></document>";
	}
}
