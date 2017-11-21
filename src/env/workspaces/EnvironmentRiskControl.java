// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.ArrayList;
import java.util.Collections;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import models.Project;
import models.Risk;

public class EnvironmentRiskControl extends Artifact {
	
	private Project project;
	double newCostP, newTimeP, pucr, putr, costCRCounter, timeCRCounter, qualifiedWorkersCounter;
	
	void init() {
		defineObsProperty("newCostP", 0.0);
		defineObsProperty("newTimeP", 0.0);
		defineObsProperty("pucr", 0.0);
		defineObsProperty("putr", 0.0);
		defineObsProperty("costCRCounter", 0.0);
		defineObsProperty("timeCRCounter", 0.0);
		defineObsProperty("qualifiedWorkersCounter", 0.0);
	}

	@OPERATION
	public Project getProject() {
		return project;
	}

	@OPERATION
	public void setProject(Project project) {
		this.project = project;
	}
	@OPERATION
	public void setPucr(double pucr) {
	this.pucr = pucr;
	getObsProperty("pucr").updateValue(pucr);
	}

	@OPERATION
	public void getPucr(OpFeedbackParam<Double> pucrAux)
	{
	pucrAux.set(this.pucr);
	}


	@OPERATION
	public void setPutr(double putr) {
	this.putr = putr;
	getObsProperty("putr").updateValue(putr);
	}

	@OPERATION
	public void getPutr(OpFeedbackParam<Double> putrAux)
	{
	putrAux.set(this.putr);
	}


	@OPERATION
	public void setNewCostP(double newCostP) {
	this.newCostP = newCostP;
	}

	@OPERATION
	public void getNewCostP(OpFeedbackParam<Double> newCostPAux)
	{
	newCostPAux.set(this.newCostP);
	}

	@OPERATION
	public void setNewTimeP(double newTimeP) {
	this.newTimeP = newTimeP;
	}

	@OPERATION
	void getNewTimeP(OpFeedbackParam<Double> newTimePAux)
	{
	newTimePAux.set(this.newTimeP);
	}
	
	@OPERATION
	public void riskControl(ArrayList<Risk> aux )
	{
		Collections.sort(aux);
		
		for (Risk risk : aux) {
			System.out.println(risk.getId()+ " - "+risk.getTotalRiskExposure());
			
		}
		
	}
//	@OPERATION
//	public void incrementCounter(double counter, String propertie){
//		getObsProperty(propertie).updateValue(counter++);
//		System.out.println("Number of " +propertie+ " is "+counter);
//	}
	
	@OPERATION
	public void getCostCRCounter(OpFeedbackParam<Double> ccrCAux)
	{
		ccrCAux.set(this.costCRCounter);
	}
	
	@OPERATION
	public void getTimeCRCounter(OpFeedbackParam<Double> tcrCAux)
	{
		tcrCAux.set(this.timeCRCounter);
	}
	
	@OPERATION
	public void getQualifiedWorkersCounter(OpFeedbackParam<Double> QwCAux)
	{
		QwCAux.set(this.qualifiedWorkersCounter);
	}

}

