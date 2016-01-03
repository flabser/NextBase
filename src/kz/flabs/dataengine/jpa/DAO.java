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
		try {
			String jpql = "SELECT m FROM " + entityClass.getName() + " AS m WHERE m.id = :id";
			TypedQuery<T> q = em.createQuery(jpql, entityClass);
			q.setParameter("id", id);
			return q.getSingleResult();
		} finally {
			em.close();
		}
	}

	@Override
	public List<T> findAllByIds(List<K> ids) {
		EntityManager em = getEntityManagerFactory().createEntityManager();
		try {
			String jpql = "SELECT m FROM " + entityClass.getName() + " AS m WHERE m.id IN :ids";
			TypedQuery<T> q = em.createQuery(jpql, entityClass);
			q.setParameter("ids", ids);
			return q.getResultList();
		} finally {
			em.close();
		}
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

	public <T1> ViewResult<T> findAllEQUAL(String fieldName, T1 value, int pageNum, int pageSize) {
		Class<T1> valueClass = (Class<T1>) value.getClass();
		EntityManager em = getEntityManagerFactory().createEntityManager();
		CriteriaBuilder cb = em.getCriteriaBuilder();
		try {
			CriteriaQuery<T> cq = cb.createQuery(entityClass);
			CriteriaQuery<Long> countCq = cb.createQuery(Long.class);
			Root<T> c = cq.from(entityClass);
			cq.select(c);
			countCq.select(cb.count(c));
			cq.where(cb.equal(c.get(fieldName), cb.parameter(valueClass, "val")));
			countCq.where(cb.equal(c.get(fieldName), cb.parameter(valueClass, "val")));
			if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
				cq.where(c.get("readers").in((long) user.docID));
				countCq.where(c.get("readers").in((long) user.docID));
			}

			TypedQuery<T> typedQuery = em.createQuery(cq);
			typedQuery.setParameter("val", value);
			Query query = em.createQuery(countCq);
			query.setParameter("val", value);
			int count = (int) query.getSingleResult();
			int maxPage = RuntimeObjUtil.countMaxPage(count, pageSize);
			if (pageNum == 0) {
				pageNum = maxPage;
			}
			int firstRec = RuntimeObjUtil.calcStartEntry(pageNum, pageSize);
			typedQuery.setFirstResult(firstRec);
			typedQuery.setMaxResults(pageSize);
			List<T> result = typedQuery.getResultList();

			ViewResult<T> r = new ViewResult<T>(result, count, maxPage);
			return r;
		} finally {
			em.close();
		}
	}

	public <T1> ViewResult<T> findAllIN(String fieldName, T1 value, int pageNum, int pageSize) {
		Class<T1> valueClass = (Class<T1>) value.getClass();
		EntityManager em = getEntityManagerFactory().createEntityManager();
		CriteriaBuilder cb = em.getCriteriaBuilder();
		try {
			CriteriaQuery<T> cq = cb.createQuery(entityClass);
			CriteriaQuery<Long> countCq = cb.createQuery(Long.class);
			Root<T> c = cq.from(entityClass);
			cq.select(c);
			countCq.select(cb.count(c));
			cq.where(c.get(fieldName).in(cb.parameter(valueClass, "val")));
			countCq.where(c.get(fieldName).in(cb.parameter(valueClass, "val")));
			if (!user.getUserID().equals(Const.sysUser) && SecureAppEntity.class.isAssignableFrom(getEntityClass())) {
				cq.where(c.get("readers").in((long) user.docID));
				countCq.where(c.get("readers").in((long) user.docID));
			}

			TypedQuery<T> typedQuery = em.createQuery(cq);
			typedQuery.setParameter("val", value);
			Query query = em.createQuery(countCq);
			query.setParameter("val", value);
			int count = (int) query.getSingleResult();
			int maxPage = RuntimeObjUtil.countMaxPage(count, pageSize);
			if (pageNum == 0) {
				pageNum = maxPage;
			}
			int firstRec = RuntimeObjUtil.calcStartEntry(pageNum, pageSize);
			typedQuery.setFirstResult(firstRec);
			typedQuery.setMaxResults(pageSize);
			List<T> result = typedQuery.getResultList();

			ViewResult<T> r = new ViewResult<T>(result, count, maxPage);
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

	public class ViewResult<T> {
		private List<T> result;
		private int count;
		private int maxPage;

		ViewResult(List<T> result, int count2, int maxPage) {
			this.result = result;
			this.count = count2;
			this.maxPage = maxPage;
		}

		public int getCount() {
			return count;
		}

		public List<T> getResult() {
			return result;
		}

		public int getMaxPage() {
			return maxPage;
		}
	}

}
