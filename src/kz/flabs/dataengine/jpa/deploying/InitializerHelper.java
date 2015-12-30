package kz.flabs.dataengine.jpa.deploying;

import java.lang.reflect.Constructor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.Const;
import kz.flabs.dataengine.jpa.IDAO;
import kz.flabs.dataengine.jpa.ISimpleAppEntity;
import kz.flabs.users.User;
import kz.nextbase.script._Session;
import kz.pchelka.env.Environment;
import kz.pchelka.scheduler.IProcessInitiator;

import com.eztech.util.JavaClassFinder;

public class InitializerHelper implements IProcessInitiator {

	public Map<String, Class<IInitialData>> getAllinitializers(boolean showConsoleOutput) {
		Map<String, Class<IInitialData>> inits = new HashMap<String, Class<IInitialData>>();
		JavaClassFinder classFinder = new JavaClassFinder();
		List<Class<? extends IInitialData>> classesList = null;
		classesList = classFinder.findAllMatchingTypes(IInitialData.class);
		for (Class<?> populatingClass : classesList) {
			if (!populatingClass.isInterface() && !populatingClass.getCanonicalName().equals(InitialDataAdapter.class.getCanonicalName())) {
				IInitialData<ISimpleAppEntity, IDAO> pcInstance = null;
				try {
					pcInstance = (IInitialData<ISimpleAppEntity, IDAO>) Class.forName(populatingClass.getCanonicalName()).newInstance();
					String name = pcInstance.getName();
					String packageName = populatingClass.getPackage().getName();
					String p = packageName.substring(0, packageName.indexOf("."));
					AppEnv env = Environment.getApplication(p);
					if (env != null) {
						inits.put(name, (Class<IInitialData>) populatingClass);
						if (showConsoleOutput) {
							System.out.println("application: " + env.appType + ", name: " + name);
						}
					} else {
						if (showConsoleOutput) {
							System.out.println("null " + name);
						}
					}
				} catch (InstantiationException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				}

			}
		}
		if (inits.size() == 0 && showConsoleOutput) {
			System.out.println("there is no any initializer on the Server");
		}
		return inits;
	}

	public String runInitializer(String name, boolean showConsoleOutput) {
		int count = 0;
		JavaClassFinder classFinder = new JavaClassFinder();
		List<Class<? extends IInitialData>> classesList = null;
		classesList = classFinder.findAllMatchingTypes(IInitialData.class);
		for (Class<?> populatingClass : classesList) {
			if (!populatingClass.isInterface() && !populatingClass.getCanonicalName().equals(InitialDataAdapter.class.getCanonicalName())) {
				if (name.equals(populatingClass.getSimpleName())) {
					if (populatingClass.getSimpleName().equals(name)) {
						IInitialData<ISimpleAppEntity, IDAO> pcInstance = null;
						try {
							String packageName = populatingClass.getPackage().getName();
							String p = packageName.substring(0, packageName.indexOf("."));
							AppEnv env = Environment.getApplication(p);
							if (env != null) {
								User user = new User(Const.sysUser, env);
								_Session ses = new _Session(env, user, this);
								pcInstance = (IInitialData<ISimpleAppEntity, IDAO>) Class.forName(populatingClass.getCanonicalName()).newInstance();
								List<ISimpleAppEntity> entities = pcInstance.getData(ses, null, null);
								Class<?> daoClass = pcInstance.getDAO();
								IDAO dao = getDAOInstance(ses, daoClass);
								if (dao != null) {
									for (ISimpleAppEntity entity : entities) {
										if (dao.add(entity) != null) {
											if (showConsoleOutput) {
												System.out.println(entity.toString() + " added");
											}
											count++;
										}
									}
								}
							}
						} catch (InstantiationException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} catch (ClassNotFoundException e) {
							e.printStackTrace();
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
		if (showConsoleOutput) {
			System.out.println(count + " records have been added");
		}
		return "";
	}

	private IDAO<?, ?> getDAOInstance(_Session ses, Class<?> daoClass) {
		@SuppressWarnings("rawtypes")
		Class[] intArgsClass = new Class[] { _Session.class };
		IDAO<?, ?> dao = null;

		try {
			Constructor<?> intArgsConstructor = daoClass.getConstructor(intArgsClass);
			dao = (IDAO<?, ?>) intArgsConstructor.newInstance(new Object[] { ses });
		} catch (Exception e) {
			e.printStackTrace();
		}

		return dao;
	}

	@Override
	public String getOwnerID() {
		return this.getClass().getSimpleName();
	}
}
