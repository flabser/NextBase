package kz.flabs.dataengine.jpa;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.ElementCollection;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

import kz.flabs.users.User;

@MappedSuperclass
public abstract class SecureAppEntity extends AppEntity {
	@ElementCollection
	private Set<Long> editors = new HashSet<Long>();

	@ElementCollection
	private Set<Long> readers = new HashSet<Long>();

	@Transient
	private boolean isEditable;

	public Set<Long> getEditors() {
		return editors;
	}

	public void setEditors(Set<Long> editors) {
		this.editors = editors;
	}

	public void addReaderEditor(User user) {
		int id = user.docID;
		if (id != 0) {
			this.editors.add((long) id);
			addReader(user);
		}
	}

	public Set<Long> getReaders() {
		return readers;
	}

	public void setReaders(Set<Long> readers) {
		this.readers = readers;
	}

	public void addReader(User user) {
		int id = user.docID;
		if (id != 0) {
			this.readers.add((long) id);
		}
	}

	public void addEditor(String role) {

	}

	@Override
	public void setAuthor(User user) {
		author = (long) user.docID;
		if (author != 0) {
			addReader(user);
			addReaderEditor(user);
		}
	}

}
