package kz.flabs.dataengine.jpa.embedded;

import java.util.Set;

import javax.persistence.Embeddable;

import kz.flabs.users.User;

@Embeddable
public class ACL {
	private Set<Long> editors;

	private Set<Long> readers;

	public Set<Long> getEditors() {
		return editors;
	}

	public void setEditors(Set<Long> editors) {
		this.editors = editors;
	}

	public void addEditor(User user) {
		this.editors.add((long) user.docID);
	}

	public Set<Long> getReaders() {
		return readers;
	}

	public void setReaders(Set<Long> readers) {
		this.readers = readers;
	}

	public void addReader(User user) {
		this.readers.add((long) user.docID);
	}

	public void addEditor(String role) {

	}
}
