package kz.flabs.dataengine.jpa;

import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public abstract class SimpleAppEntity implements ISimpleAppEntity {

	@Id
	@Column(columnDefinition = "uuid")
	private UUID id;

	@Override
	public void setId(UUID id) {
		this.id = id;
	}

	@Override
	public UUID getId() {
		return id;
	}

}
