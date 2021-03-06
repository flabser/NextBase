package kz.flabs.scriptprocessor;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;

import kz.flabs.localization.LanguageType;
import kz.flabs.localization.Vocabulary;
import kz.flabs.users.UserSession;
import kz.nextbase.script._Exception;
import kz.nextbase.script._Helper;
import kz.nextbase.script._IXMLContent;
import kz.nextbase.script._JSONHandler;
import kz.nextbase.script._Session;
import kz.nextbase.script._URL;
import kz.nextbase.script.concurrency._AJAXHandler;
import kz.nextbase.script.constants._JSONTemplate;
import kz.pchelka.env.Environment;

public class ScriptEvent {
	protected Vocabulary vocabulary;
	protected String redirectURL = "";
	protected ArrayList<_IXMLContent> toPublishElement = new ArrayList<_IXMLContent>();
	protected _Session ses;

	public String getTmpDirPath() {
		return Environment.tmpDir;
	}

	public String getWord(String word, Vocabulary vocabulary, String lang) {
		try {
			return vocabulary.getSentenceCaption(word, lang).word;
		} catch (Exception e) {
			return word.toString();
		}
	}

	public void publishElement(String entryName, String value) {
		toPublishElement.add(new ScriptShowField(entryName, value));
	}

	public void publishElement(String entryName, Object value) throws _Exception {
		if (value == null) {
			toPublishElement.add(new ScriptShowField(entryName, ""));
		} else if (value instanceof String) {
			toPublishElement.add(new ScriptShowField(entryName, (String) value));
		} else if (value instanceof _IXMLContent) {
			toPublishElement.add(new ScriptShowField(entryName, (_IXMLContent) value));
		} else if (value instanceof Date) {
			toPublishElement.add(new ScriptShowField(entryName, _Helper.getDateAsString((Date) value)));
		} else if (value instanceof Enum) {
			toPublishElement.add(new ScriptShowField(entryName, ((Enum) value).name()));
		} else if (value instanceof BigDecimal) {
			toPublishElement.add(new ScriptShowField(entryName, value.toString()));
		}
	}

	public void publishElement(_IXMLContent value) {
		toPublishElement.add(value);
	}

	public void publishElement(String spot, String launcher, _AJAXHandler value, boolean async, _JSONTemplate template) {
		_JSONHandler jsHandler = new _JSONHandler(spot, launcher, value, template);
		UserSession userSession = ses.getUser().getSession();
		userSession.addDynmaicClass(jsHandler.id, jsHandler.getInstance());
		toPublishElement.add(jsHandler);
	}

	public void publishElement(String id, String spot, String launcher, _AJAXHandler value, boolean async, _JSONTemplate template) {
		_JSONHandler jsHandler = new _JSONHandler(id, spot, launcher, value, "", template);
		UserSession userSession = ses.getUser().getSession();
		userSession.addDynmaicClass(jsHandler.id, jsHandler.getInstance());
		toPublishElement.add(jsHandler);
	}

	public String getGroovyError(StackTraceElement stack[]) {
		for (int i = 0; i < stack.length; i++) {
			if (stack[i].getClassName().contains(this.getClass().getName())) {
				return stack[i].getClassName() + " method=" + stack[i].getMethodName() + " > " + Integer.toString(stack[i].getLineNumber()) + "\n";
			}
		}
		return "";
	}

	@Deprecated
	public String getLocalizedWord(String word, String lang) {
		return getWord(word, vocabulary, lang);
	}

	public String getLocalizedWord(String word, LanguageType lang) {
		return getWord(word, vocabulary, lang.name());
	}

	public void setRedirectURL(_URL url) {
		redirectURL = url.toString();
	}

	public static void log(Object logText) {
		ScriptProcessor.logger.normalLogEntry(logText.toString());
	}

	public static void error(Exception e) {
		ScriptProcessor.logger.errorLogEntry(e);
	}

	@Deprecated
	public void setRedirectURL(String url) {
		redirectURL = url;
	}

	@Deprecated
	public void setRedirectPage(String page) {
		redirectURL = "Provider?type=page&element=" + page;
	}
}
