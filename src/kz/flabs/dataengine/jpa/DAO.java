package kz.flabs.dataengine.jpa;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.PersistenceException;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import kz.flabs.dataengine.Const;
import kz.flabs.runtimeobj.RuntimeObjUtil;
import kz.flabs.users.User;
import kz.nextbase.script._Session;
import kz.pchelka.server.Server;

public abstract class DAO<T extends IAppEntity, K> implements IDAO<T, K> {
	public User user;
	private final Class<T> entityClass;
	private EntityManagerFactory emf;

	public DAO(Class<T> entityClass, _Session session) {
		this.entityClass = entityClass;
		emf = session.getCurrentDatabase().getEntityManagerFactory();
		user = session.getUser();
	}

	public Class<T> getEntityClass() {
		return entityClass;
	}

	public EntityManagerFactory getEntityManagerFactory() {
		return emf;
	}

	@Override
	public T findById(K id) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		CriteriaBuilder cb = em.getCriteriaBuilder();
		try {
			CriteriaQuery<T> cq = cb.createQuery(entityClass);
			Root<T> c = cq.from(entityClass);
			cq.select(c);
			Predicate condition = c.get("id").in(id);
			cq.where(condition);
			Query query = em.createQuery(cq);
			T entity = (T) query.getSingleResult();
			if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
				if (((SecureAppEntity) entity).getEditors().contains(user.docID)) {
					entity.setEditable(false);
				}
			}
			return entity;
		} finally {
			em.close();
		}
	}

	@Override
	public ViewPage<T> findAllByIds(List<K> value, int pageNum, int pageSize) {
		return findAllIN("id", value, pageNum, pageSize);
	}

	@Override
	public List<T> findAll(int firstRec, int pageSize) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			TypedQuery<T> q = em.createNamedQuery(getQueryNameForAll(), entityClass);
			q.setFirstResult(firstRec);
			q.setMaxResults(pageSize);
			return q.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public List<T> findAll() {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			TypedQuery<T> q = em.createNamedQuery(getQueryNameForAll(), entityClass);
			return q.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public T add(T entity) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			EntityTransaction t = em.getTransaction();
			try {
				t.begin();
				entity.setAuthor(user.docID);
				em.persist(entity);
				t.commit();
				return entity;
			} catch (PersistenceException e) {
				Server.logger.errorLogEntry(e.getMessage());
				return null;
			} finally {
				if (t.isActive()) {
					t.rollback();
				}
			}
		} finally {
			em.close();
		}
	}

	@Override
	public T update(T entity) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			EntityTransaction t = em.getTransaction();
			try {
				t.begin();
				em.merge(entity);
				t.commit();
				return entity;
			} catch (PersistenceException e) {
				Server.logger.errorLogEntry(e.getMessage());
				return null;
			} finally {
				if (t.isActive()) {
					t.rollback();
				}
			}
		} finally {
			em.close();
		}
	}

	@Override
	public void delete(T entity) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			EntityTransaction t = em.getTransaction();
			try {
				t.begin();
				entity = em.merge(entity);
				em.remove(entity);
				t.commit();
			} finally {
				if (t.isActive()) {
					t.rollback();
				}
			}
		} finally {
			em.close();
		}
	}

	@Override
	public Long getCount() {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			Query q = em.createQuery("SELECT count(m) FROM " + entityClass.getName() + " AS m");
			return (Long) q.getSingleResult();
		} finally {
			em.close();
		}
	}

	public <T1> ViewPage<T> findAllEQUAL(String fieldName, T1 value, int pageNum, int pageSize) {
		Class<T1> valueClass = (Class<T1>) value.getClass();
		EntityManager em = getEntityManagerFactory().createEntityManager();
		CriteriaBuilder cb = em.getCriteriaBuilder();
		try {
			CriteriaQuery<T> cq = cb.createQuery(entityClass);
			CriteriaQuery<Long> countCq = cb.createQuery(Long.class);
			Root<T> c = cq.from(entityClass);
			cq.select(c);
			countCq.select(cb.count(c));
			Predicate condition = c.get(fieldName).in(cb.parameter(valueClass, "val"));
			if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
				condition = cb.and(c.get("readers").in((long) user.docID), condition);
			}
			cq.where(condition);
			countCq.where(condition);
			TypedQuery<T> typedQuery = em.createQuery(cq);
			typedQuery.setParameter("val", value);
			Query query = em.createQuery(countCq);
			query.setParameter("val", value);
			long count = (long) query.getSingleResult();
			int maxPage = RuntimeObjUtil.countMaxPage(count, pageSize);
			if (pageNum == 0) {
				pageNum = maxPage;
			}
			int firstRec = RuntimeObjUtil.calcStartEntry(pageNum, pageSize);
			typedQuery.setFirstResult(firstRec);
			typedQuery.setMaxResults(pageSize);
			List<T> result = typedQuery.getResultList();

			ViewPage<T> r = new ViewPage<T>(result, count, maxPage, pageNum);
			return r;
		} finally {
			em.close();
		}
	}

	public ViewPage<T> findAllIN(String fieldName, List value, int pageNum, int pageSize) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		CriteriaBuilder cb = em.getCriteriaBuilder();
		try {
			CriteriaQuery<T> cq = cb.createQuery(entityClass);
			CriteriaQuery<Long> countCq = cb.createQuery(Long.class);
			Root<T> c = cq.from(entityClass);
			cq.select(c);
			countCq.select(cb.count(c));
			Predicate condition = c.get(fieldName).in(value);
			if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
				condition = cb.and(c.get("readers").in((long) user.docID), condition);
			}
			cq.where(condition);
			countCq.where(condition);
			TypedQuery<T> typedQuery = em.createQuery(cq);
			Query query = em.createQuery(countCq);
			long count = (long) query.getSingleResult();
			int maxPage = RuntimeObjUtil.countMaxPage(count, pageSize);
			if (pageNum == 0) {
				pageNum = maxPage;
			}
			int firstRec = RuntimeObjUtil.calcStartEntry(pageNum, pageSize);
			typedQuery.setFirstResult(firstRec);
			typedQuery.setMaxResults(pageSize);
			List<T> result = typedQuery.getResultList();

			ViewPage<T> r = new ViewPage<T>(result, count, maxPage, pageNum);
			return r;
		} finally {
			em.close();
		}
	}

	public String getQueryNameForAll() {
		String queryName = entityClass.getSimpleName() + ".findAll";
		return queryName;
	}

	protected Predicate addAccessCondition(CriteriaBuilder cBuilder, Root<T> root) {
		if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
			return root.get("readers").in((long) user.docID);
		} else {
			return cBuilder.disjunction();
		}
	}

	protected CriteriaQuery<T> addAccessRestriction(CriteriaQuery<T> select, Root<T> root) {
		if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
			select.where(root.get("readers").in((long) user.docID));
		}
		return select;
	}

	public class ViewPage<T> {
		private List<T> result;
		private long count;
		private int maxPage;
		private int pageNum;

		ViewPage(List<T> result, long count2, int maxPage, int pageNum) {
			this.result = result;
			this.count = count2;
			this.maxPage = maxPage;
			this.pageNum = pageNum;
		}

		public long getCount() {
			return count;
		}

		public List<T> getResult() {
			return result;
		}

		public int getMaxPage() {
			return maxPage;
		}

		public int getPageNum() {
			return pageNum;
		}
	}

}
