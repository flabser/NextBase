package kz.flabs.dataengine.jpa.embedded;

import java.util.List;

import javax.persistence.Embeddable;

@Embeddable
public class ACL {
	private List<Long> editors;

	private List<Long> readers;

	public List<Long> getEditors() {
		return editors;
	}

	public void setEditors(List<Long> editors) {
		this.editors = editors;
	}

	public List<Long> getReaders() {
		return readers;
	}

	public void setReaders(List<Long> readers) {
		this.readers = readers;
	}
}
