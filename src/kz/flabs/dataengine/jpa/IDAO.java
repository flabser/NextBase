package kz.flabs.dataengine.jpa;

import java.util.List;

public interface IDAO<T, K> {

	T findById(K id);

	List<T> findAllByIds(List<K> ids);

	List<T> findAll();

	Long getCount();

	List<T> findAll(int firstRec, int pageSize);

	T add(T entity);

	T update(T entity);

	void delete(T entity);

}
