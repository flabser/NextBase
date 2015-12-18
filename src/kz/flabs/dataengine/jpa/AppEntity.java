package kz.flabs.dataengine.jpa;

import java.util.Date;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;

import org.eclipse.persistence.annotations.Convert;
import org.eclipse.persistence.annotations.Converter;
import org.eclipse.persistence.annotations.UuidGenerator;

import kz.flabs.dataengine.jpa.util.UUIDConverter;
import kz.flabs.util.Util;

@MappedSuperclass
@Converter(name = "uuidConverter", converterClass = UUIDConverter.class)
@UuidGenerator(name = "uuid-gen")
public abstract class AppEntity implements IAppEntity {
	@Id
	@GeneratedValue(generator = "uuid-gen")
	@Convert("uuidConverter")
	@Column(name = "id", nullable = false)
	protected UUID id;

	@Column(name = "author", nullable = false, updatable = false)
	protected Long author;

	@Column(name = "reg_date", nullable = false, updatable = false)
	protected Date regDate;

	@PrePersist
	private void prePersist() {
		regDate = new Date();
	}

	@Override
	public void setId(UUID id) {
		this.id = id;
	}

	@Override
	public UUID getId() {
		return id;
	}

	@Override
	public Long getAuthor() {
		return author;
	}

	@Override
	public void setAuthor(Long author) {
		this.author = author;
	}

	public void setAuthor(String userID) {

	}

	public String getAuthorName() {

		return null;

	}

	@Override
	public Date getRegDate() {
		return regDate;
	}

	@Override
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	@Override
	public String toString() {
		return Util.toStringGettersVal(this);
	}
}
