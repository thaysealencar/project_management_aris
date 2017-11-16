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
	double newCostP, newTimeP, pucr, putr, costCRCounter, timeCRCounter;
	
	void init() {
		defineObsProperty("newCostP", 0.0);
		defineObsProperty("newTimeP", 0.0);
		defineObsProperty("pucr", 0.0);
		defineObsProperty("putr", 0.0);
		defineObsProperty("costCRCounter", 0.0);
		defineObsProperty("timeCRCounter", 0.0);
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
	void setPucr(double pucr) {
	this.pucr = pucr;
	getObsProperty("pucr").updateValue(pucr);
	}

	@OPERATION
	void getPucr(OpFeedbackParam<Double> pucrAux)
	{
	pucrAux.set(this.pucr);
	}


	@OPERATION
	void setPutr(double putr) {
	this.putr = putr;
	getObsProperty("putr").updateValue(putr);
	}

	@OPERATION
	void getPutr(OpFeedbackParam<Double> putrAux)
	{
	putrAux.set(this.putr);
	}


	@OPERATION
	void setNewCostP(double newCostP) {
	this.newCostP = newCostP;
	}

	@OPERATION
	void getNewCostP(OpFeedbackParam<Double> newCostPAux)
	{
	newCostPAux.set(this.newCostP);
	}


	@OPERATION
	void setNewTimeP(double newTimeP) {
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
	@OPERATION
	public void incrementCounter(double counter, String propertie){
		getObsProperty(propertie).updateValue(counter++);
	}
	@OPERATION
	void getCostCRCounter(OpFeedbackParam<Double> CcrC)
	{
	CcrC.set(this.costCRCounter);
	}
	@OPERATION
	void getTimeCRCounter(OpFeedbackParam<Double> TcrC)
	{
	TcrC.set(this.timeCRCounter);
	}

}

