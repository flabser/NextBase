package kz.flabs.dataengine.jpa;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.ElementCollection;
import javax.persistence.MappedSuperclass;

import kz.flabs.users.User;

@MappedSuperclass
public abstract class SecureAppEntity extends AppEntity {
	@ElementCollection
	private Set<Long> editors = new HashSet<Long>();

	@ElementCollection
	private Set<Long> readers = new HashSet<Long>();

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

	public void addReader(int i) {
		this.readers.add((long) i);

	}

	public void addReader(User user) {
		this.readers.add((long) user.docID);
	}

	public void addEditor(String role) {

	}

	@Override
	public void setAuthor(User user) {
		author = (long) user.docID;
		addReader(user);
		addEditor(user);

	}
}
