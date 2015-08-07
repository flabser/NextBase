package kz.pchelka.server;

import java.util.Scanner;

import kz.flabs.appenv.AppEnv;
import kz.pchelka.env.Environment;

public class Console implements Runnable {

	@Override
	public void run() {

		final Scanner in = new Scanner(System.in);
		while (in.hasNext()) {
			final String command = in.nextLine();
			System.out.println("> " + command);
			if (command.equalsIgnoreCase("quit") || command.equalsIgnoreCase("q")) {
				Server.shutdown();
				in.close();
			} else if (command.equalsIgnoreCase("reset rules") || command.equalsIgnoreCase("rr")) {
				for (AppEnv env : Environment.getApplications()) {
					env.ruleProvider.resetRules();
				}
			} else {
				if (!command.trim().equalsIgnoreCase("")) {
					System.err.println("command \"" + command + "\" is not recognized");
				}
			}
		}
	}
}
