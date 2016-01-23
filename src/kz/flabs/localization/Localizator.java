package kz.flabs.localization;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.Const;
import kz.flabs.webrule.GlobalSetting;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class Localizator implements Const {
	private GlobalSetting globalSetting;

	public Localizator(GlobalSetting globalSetting) {
		try {
			this.globalSetting = globalSetting;
		} catch (Exception ne) {
			AppEnv.logger.errorLogEntry(ne);
		}
	}

	public Localizator() {

	}

	public Vocabulary populate() throws LocalizatorException {
		String vocabuarFilePath = "resources" + File.separator + "vocabulary.xml";
		return fill(vocabuarFilePath, "vocabulary", "system");
	}

	public Vocabulary populate(String vocabular) throws LocalizatorException {
		String vocabuarFilePath = globalSetting.rulePath + File.separator + "Resources" + File.separator + vocabular + ".xml";
		return fill(vocabuarFilePath, vocabular, globalSetting.appName);
	}

	private Vocabulary fill(String vocabuarFilePath, String vocabular, String appName) throws LocalizatorException {
		try {
			File docFile = new File(vocabuarFilePath);
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db;
			db = dbf.newDocumentBuilder();
			Document queryDoc = db.parse(docFile.toString());
			if (queryDoc == null) {
				throw new LocalizatorException(LocalizatorExceptionType.VOCABULAR_NOT_FOUND);
			}
			return new Vocabulary(queryDoc, vocabular, appName);
		} catch (FileNotFoundException e) {
			AppEnv.logger.errorLogEntry("File not found, filepath=" + vocabuarFilePath + ", the vocabulary file has not loaded");
		} catch (ParserConfigurationException e) {
			AppEnv.logger.errorLogEntry(e);
		} catch (IOException e) {
			AppEnv.logger.errorLogEntry(e);
		} catch (SAXException e) {
			AppEnv.logger.errorLogEntry(e);
		}
		return null;
	}
}
