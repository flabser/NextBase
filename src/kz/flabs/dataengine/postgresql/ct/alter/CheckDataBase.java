package kz.flabs.dataengine.postgresql.ct.alter;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.DatabasePoolException;
import kz.flabs.dataengine.postgresql.alter.*;
import kz.flabs.dataengine.postgresql.alter.Updates;

public class CheckDataBase extends kz.flabs.dataengine.h2.alter.CheckDataBase {
		
		public CheckDataBase(AppEnv env) throws InstantiationException, IllegalAccessException, ClassNotFoundException, DatabasePoolException {	
			super(env, true);
            kz.flabs.dataengine.postgresql.ct.alter.Updates u = new kz.flabs.dataengine.postgresql.ct.alter.Updates();
            setUpdates(u);
		}

}