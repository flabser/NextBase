package kz.pchelka.server;

import java.io.File;
import java.util.Scanner;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.jpa.deploying.InitializerHelper;
import kz.flabs.localization.Localizator;
import kz.flabs.localization.Vocabulary;
import kz.flabs.util.Util;
import kz.pchelka.env.EnvConst;
import kz.pchelka.env.Environment;

public class Console implements Runnable {

	@Override
	public void run() {

		final Scanner in = new Scanner(System.in);
		while (in.hasNext()) {
			try {
				String command = in.nextLine();
				System.out.println("> " + command);
				if (command.equalsIgnoreCase("quit") || command.equalsIgnoreCase("exit") || command.equalsIgnoreCase("q")) {
					Server.shutdown();
					in.close();
				} else if (command.equalsIgnoreCase("reset rules") || command.equalsIgnoreCase("rr")) {
					for (AppEnv env : Environment.getApplications()) {
						env.ruleProvider.resetRules();
						env.flush();
					}
					new Environment().flush();
					Environment.flushSessionsCach();
				} else if (command.equalsIgnoreCase("show server cache") || command.equalsIgnoreCase("ssc")) {
					System.out.println(Environment.getCacheInfo());
				} else if (command.equalsIgnoreCase("show users cache") || command.equalsIgnoreCase("suc")) {
					for (String ci : Environment.getSessionCachesInfo()) {
						System.out.println(ci);
					}
				} else if (command.equalsIgnoreCase("reload vocabulary") || command.equalsIgnoreCase("rv")) {
					Localizator l = new Localizator();
					Environment.vocabulary = l.populate();
					if (Environment.vocabulary == null) {
						Environment.vocabulary = new Vocabulary("system");
					}
					for (AppEnv env : Environment.getApplications()) {
						env.reloadVocabulary();
						env.flush();
					}
					new Environment().flush();
					Environment.flushSessionsCach();
				} else if (command.equalsIgnoreCase("show initializers") || command.equalsIgnoreCase("si")) {
					InitializerHelper helper = new InitializerHelper();
					helper.getAllinitializers(true);
				} else if (command.contains("start initializer") || command.startsWith("stini")) {
					int start = 0;
					if (command.contains("start initializer")) {
						start = "start initializer".length();
					} else if (command.startsWith("stini")) {
						start = "stini".length();
					}
					String ini = command.substring(start).trim();
					if (ini.trim().equals("")) {
						System.err.println("error -initializer name is empty");
					} else {
						InitializerHelper helper = new InitializerHelper();
						helper.runInitializer(ini, true);
						System.out.println("done");
					}
					command = "start initializer";
				} else if (command.equals("help") || command.equalsIgnoreCase("h")) {
					System.out.println(Util.readFile(EnvConst.RESOURCES_DIR + File.separator + "console_commands.txt"));
				} else {
					if (!command.trim().equalsIgnoreCase("")) {
						System.err.println("error -command \"" + command + "\" is not recognized");
					}
				}
			} catch (Exception e) {
				Server.logger.errorLogEntry(e);
			}
		}

	}
}
