package kz.flabs.dataengine.jpa;

import java.util.Date;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.TypeDef;

import kz.flabs.util.Util;

@MappedSuperclass
@TypeDef(name = "uuid", defaultForType = UUID.class, typeClass = UuidType.class)
public abstract class AppEntity implements IAppEntity {
	@Id
	@GeneratedValue(generator = "uuid-gen")
	@GenericGenerator(name = "uuid-gen", strategy = "uuid2")
	@Column(name = "id", columnDefinition = "uuid")
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
