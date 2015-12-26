package kz.flabs.dataengine.jpa;

import java.util.Date;

public interface IAppEntity extends ISimpleAppEntity {

	long getAuthor();

	void setAuthor(long author);

	Date getRegDate();

	void setRegDate(Date regDate);

}
