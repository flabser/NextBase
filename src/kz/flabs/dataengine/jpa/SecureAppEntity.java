package kz.flabs.dataengine.jpa;

import javax.persistence.Embedded;
import javax.persistence.MappedSuperclass;

import kz.flabs.dataengine.jpa.embedded.ACL;

@MappedSuperclass
public abstract class SecureAppEntity extends AppEntity {
	@Embedded
	private ACL acl;

	public ACL getAcl() {
		return acl;
	}

	public void setAcl(ACL acl) {
		this.acl = acl;
	}
}
