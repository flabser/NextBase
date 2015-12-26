package kz.flabs.dataengine.jpa;

import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;

import org.eclipse.persistence.annotations.Convert;
import org.eclipse.persistence.annotations.Converter;
import org.eclipse.persistence.annotations.UuidGenerator;
import org.eclipse.persistence.internal.indirection.jdk8.IndirectList;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.jpa.util.UUIDConverter;
import kz.flabs.users.User;
import kz.flabs.util.Util;
import kz.flabs.util.XMLUtil;
import kz.nextbase.script._Exception;
import kz.nextbase.script._IPOJOObject;
import kz.nextbase.script._IXMLContent;
import kz.nextbase.script._URL;

@MappedSuperclass
@Converter(name = "uuidConverter", converterClass = UUIDConverter.class)
@UuidGenerator(name = "uuid-gen")
public abstract class AppEntity implements IAppEntity, _IPOJOObject {
	@Id
	@GeneratedValue(generator = "uuid-gen")
	@Convert("uuidConverter")
	@Column(name = "id", nullable = false)
	protected UUID id;

	@Column(name = "author", nullable = false, updatable = false)
	protected long author;

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
	public long getAuthor() {
		return author;
	}

	@Override
	public void setAuthor(long author) {
		this.author = author;
	}

	public void setAuthor(String userID) {

	}

	public void setAuthor(User user) {
		author = user.docID;

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
		// return Util.toStringGettersVal(this);
		return getId().toString();
	}

	@Override
	public String toXML() throws _Exception {
		Class<?> noparams[] = {};
		StringBuilder value = new StringBuilder(1000);
		try {
			for (PropertyDescriptor propertyDescriptor : Introspector.getBeanInfo(this.getClass())
					.getPropertyDescriptors()) {
				Method method = propertyDescriptor.getReadMethod();
				if (method != null && !method.getName().equals("getClass")) {
					String methodValue = "";
					String fieldName = method.getName().toLowerCase().substring(3);
					try {
						Object val = method.invoke(this, noparams);
						// System.out.println(val.getClass().getName());
						if (val instanceof Date) {
							methodValue = Util.simpleDateFormat.format((Date) val);
						} else if (val instanceof IndirectList) {
							List<_IXMLContent> list = (List<_IXMLContent>) val;
							for (_IXMLContent nestedValue : list) {
								// methodValue += nestedValue.toXML();
								methodValue = nestedValue.getClass().getName();
							}
						} else if (val.getClass().isInstance(_IXMLContent.class)) {
							methodValue = ((_IXMLContent) val).toXML();
						} else {
							methodValue = val.toString();
						}
					} catch (Exception e) {
						// AppEnv.logger.errorLogEntry(e);
					}
					value.append("<" + fieldName + ">" + XMLUtil.getAsTagValue(methodValue) + "</" + fieldName + ">");
				}
			}
		} catch (IntrospectionException e) {
			AppEnv.logger.errorLogEntry(e);
		}
		return value.toString();

	}

	@Override
	public _URL getURL() {
		return new _URL("Provider?id=" + this.getClass().getSimpleName().toLowerCase() + "_form&amp;docid=" + getId());
	}
}
