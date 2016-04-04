package kz.nextbase.script.mail;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.RunnableFuture;

import kz.pchelka.env.Environment;
import kz.pchelka.messenger.InstMessengerAgent;

public class _InstMessengerAgent {

	public boolean sendMessage(List<String> recipients, String body) {
		InstMessengerAgent ima = new InstMessengerAgent();
		for (String receiver : recipients) {
			ima.sendMessage(receiver, body);
		}
		return true;
	}

	public boolean sendMessageAfter(final ArrayList<String> recipients, final String body) {
		final InstMessengerAgent ima = new InstMessengerAgent();
		RunnableFuture f = new FutureTask(new Callable<Boolean>() {
			@Override
			public Boolean call() throws Exception {
				for (String receiver : recipients) {
					ima.sendMessage(receiver, body);
				}
				return true;
			}
		});
		new Thread(f).start();
		try {
			return (boolean) f.get();
		} catch (InterruptedException | ExecutionException e) {
			Environment.logger.errorLogEntry(e);
			return false;
		}
	}
}
