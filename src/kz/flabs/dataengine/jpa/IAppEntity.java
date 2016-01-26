package kz.flabs.dataengine.jpa;

import java.util.Date;

public interface IAppEntity extends ISimpleAppEntity {

	long getAuthor();

	void setAuthor(long author);

	Date getRegDate();

	void setRegDate(Date regDate);

	public String getUrl();

	public void setUrl(String url);

	public String getDefaultForm();

	public boolean isEditable();

	public void setEditable(boolean isEditable);

}
