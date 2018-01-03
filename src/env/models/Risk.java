package models;

import java.util.ArrayList;

import models.Risk.RiskArea;
import simulations.Scenario1_SBQS;

public class Risk implements Comparable<Risk> {
	private int id;
	private String name;
	private double totalRiskExposure;
	private double costP; // cost probability
	private int costI;  // cost impact (1,2,3,4,5)
	private double timeP; // time probability
	private int timeI; // time impact (1,2,3,4,5)
	private double scopeP; // scope probability
	private int scopeI;  // scope impact (1,2,3,4,5)
	private RiskArea riskArea;
	private int handlingAction; //1,2,3,4 (prevenir, aceitar, mitigar, transferir)
	private int idEmployee;
	
	public Risk()
	{
		id	= 0;
		name = "-";
		costP = 0;
		costI = 0;
		timeP = 0;
		timeI = 0;
		scopeP = 0;
		scopeI = 0;
		totalRiskExposure = 0;
		handlingAction = 1;
		idEmployee = 1; //gerente
	}
	
	public Risk(int id, String name, double costP, int costI, double timeP, int timeI, double scopeP,int scopeI, double totalRiskExposure, RiskArea riskArea, int handlingAction,int idEmployee) {
		super();
		this.id = id;
		this.name = name;
		this.costP = costP;
		this.costI = costI;
		this.timeP = timeP;
		this.timeI = timeI;
		this.scopeP = scopeP;
		this.scopeI = scopeI;
		this.totalRiskExposure = totalRiskExposure;
		this.riskArea = riskArea;
		this.handlingAction = handlingAction;
		this.idEmployee = idEmployee;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	public double getTotalRiskExposure() {
		return totalRiskExposure;
	}

	public void setTotalRiskExposure(double totalRiskExposure) {
		this.totalRiskExposure = totalRiskExposure;
	}

	public double getCostP() {
		return costP;
	}

	public void setCostP(double costP) {
		this.costP = costP;
	}

	public int getCostI() {
		return costI;
	}

	public void setCostI(int costI) {
		this.costI = costI;
	}

	public double getTimeP() {
		return timeP;
	}

	public void setTimeP(double timeP) {
		this.timeP = timeP;
	}

	public int getTimeI() {
		return timeI;
	}

	public void setTimeI(int timeI) {
		this.timeI = timeI;
	}

	public double getScopeP() {
		return scopeP;
	}

	public void setScopeP(double scopeP) {
		this.scopeP = scopeP;
	}

	public int getScopeI() {
		return scopeI;
	}

	public void setScopeI(int scopeI) {
		this.scopeI = scopeI;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

	public int getId() {
		return id;
	}

	public int compareTo(Risk o) {
		if (this.totalRiskExposure < o.totalRiskExposure) {
            return 1;
        }
        if (this.totalRiskExposure > o.totalRiskExposure) {
            return -1;
        }
		return 0;
	}
	
	public RiskArea getRiskArea() {
		return riskArea;
	}

	public void setRiskArea(RiskArea riskArea) {
		this.riskArea = riskArea;
	}

	public int getHandlingAction() {
		return handlingAction;
	}

	public void setHandlingAction(int handlingAction) {
		this.handlingAction = handlingAction;
	}

	public int getIdEmployee() {
		return idEmployee;
	}

	public void setIdEmployee(int idEmployee) {
		this.idEmployee = idEmployee;
	}
	
	public enum RiskArea {
		SCOPE(1),//scopeI
		COST(2), //costI
		SCHEDULE(3),//timeI
		TECNICAL(4),//costI, timeI
		STAFF(5),//costI, timeI, scopeI
		COSTUMER(6);//costI, timeI, scopeI
		
		public int areaType;
		
		 RiskArea(int valor) {
		    areaType = valor;
		 }
		
		public int getAreaType() {
			return areaType;
		}
		public void setAreaType(int areaType) {
			this.areaType = areaType;
		}
	}

}
