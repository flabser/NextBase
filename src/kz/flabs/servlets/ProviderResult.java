package kz.flabs.servlets;


public class ProviderResult {
	public StringBuffer output = new StringBuffer(10000);
	public PublishAsType publishAs = PublishAsType.XML;
	public String forwardTo;
	public String xslt;
	@Deprecated
	public String title;
	public boolean disableClientCache;
	public String filePath;
	public String originalAttachName;
	@Deprecated
	public boolean addHistory;
	public int httpStatus;

	ProviderResult(PublishAsType publishAs, String xslt) {
		this.publishAs = publishAs;
		this.xslt = xslt;
	}

	public ProviderResult() {

	}

}