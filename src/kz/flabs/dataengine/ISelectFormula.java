package kz.flabs.dataengine;

import kz.flabs.users.RunTimeParameters.Filter;
import kz.flabs.users.RunTimeParameters.Sorting;
import kz.flabs.users.User;

import java.util.Set;

public interface ISelectFormula {
	@Deprecated
	String getCondition(Set<String> complexUserID, int pageSize, int offset, String[] filters, String[] sorting, boolean checkResponse);
	@Deprecated
	String getCountCondition(Set<String> complexUserID,String[] filters);	
	
	String getCondition(Set<String> complexUserID, int pageSize, int offset, Set<Filter> filters, Set<Sorting> sorting, boolean checkResponse);

    String getCondition(User user, int pageSize, int offset, Set<Filter> filters, Set<Sorting> sorting, boolean checkResponse, boolean checkRead);

    String getCountCondition(Set<String> complexUserID, Set<Filter> filters);

    String getCondition(Set<String> users, int pageSize, int offset, Set<Filter> filters, Set<Sorting> sorting, boolean checkResponse, String responseQueryCondition);
}
