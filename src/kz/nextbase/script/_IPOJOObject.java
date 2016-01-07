package kz.nextbase.script;

import java.util.UUID;

public interface _IPOJOObject {
	UUID getId();

	_URL getURL();

	String getFullXMLChunk();

	String getShortXMLChunk();

	public boolean isEditable();

}
