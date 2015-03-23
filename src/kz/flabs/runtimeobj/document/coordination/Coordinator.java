package kz.flabs.runtimeobj.document.coordination;

import kz.flabs.dataengine.IDatabase;
import kz.flabs.exception.ComplexObjectException;
import kz.flabs.runtimeobj.document.AbstractComplexObject;
import kz.flabs.runtimeobj.document.structure.Employer;
import kz.flabs.util.adapters.DateAdapter;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.io.Serializable;
import java.util.Date;

@XmlAccessorType(XmlAccessType.FIELD)
public class Coordinator extends AbstractComplexObject implements Serializable{
	@XmlElement(name = "type")
    int type;

    private Employer user;

    @XmlElement(name = "current")
	private boolean isCurrent;

    @XmlElement
	private Decision decision = new Decision();

    @XmlElement(name = "num")
    public int num;

    @XmlElement(name = "coorddate")
    @XmlJavaTypeAdapter(DateAdapter.class)
    public Date coordDate;

    private transient IDatabase db;

    @XmlTransient
    private static final long serialVersionUID = 1L;

    @Deprecated
    public Coordinator() {
    }

	public Coordinator(IDatabase db) {
		this.db = db;
	}

	public Coordinator(IDatabase db, String userID) {
		this.db = db;
		user = db.getStructure().getAppUser(userID);
	}

	public void setType(int coordinatorTypeSigner) {
		type = 	coordinatorTypeSigner;	
	}

	public String getUserID() {
		return user.getUserID();
	}

	public void setUserID(String userID) {
        user = db.getStructure().getAppUser(userID);
	}

	public boolean isCurrent() {
		return isCurrent;
	}

	public void setCurrent(boolean isCurrent) {
		this.isCurrent = isCurrent;
	}

	public void isCurrent(int parseInt) {
       this.isCurrent = parseInt == 1;
	}

	public void setCoorDate(Date date) {
        this.coordDate = date;
	}

	public void setComment(String textContent) {
		decision.comment = textContent;
	}   

	public void setDecision(Decision d) {
		decision = d;	
		
		isCurrent = false;
	}
	
	public void setDecisionDate(Date date) {
		decision.decisionDate = date;
	}

	public int getCoordType() {
		return this.type;
	}

	public String getCoordNumber() {
		return String.valueOf(num);
	}

	public Date getDecisionDate() {
		return decision.decisionDate;
	}

	public Date getCoorDate() {
		return this.coordDate;
	}

	public Employer getEmployer() {
        return user;
	}

	public void setNumber(int num) {
		this.num = num;
		
	}

	public Decision getDecision() {
		return decision;
	}


    @Override
    public void init(IDatabase db, String initString) throws ComplexObjectException {

    }

    @Override
    public String getContent() {
        return null;
    }
}
