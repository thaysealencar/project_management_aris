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
	double puccb, putcb , newCostP, newTimeP;
	
	void init() {
		defineObsProperty("puccb", 0.0);
		defineObsProperty("putcb", 0.0);
		defineObsProperty("newCostP", 0.0);
		defineObsProperty("newTimeP", 0.0);
	}
	
	@OPERATION
	void setProject(Project p) {
		this.project = p;
	}
	
	@OPERATION
	void setPuccb(double puccb) {
		this.puccb = puccb;
		getObsProperty("puccb").updateValue(puccb);
	}
	@OPERATION
	void setPuccbToZero(OpFeedbackParam<Double> puccb) {
		this.puccb = (Double) null;
		getObsProperty("puccb").updateValue(puccb);
	}
	
	@OPERATION
	void getPuccb(OpFeedbackParam<Double> puccbAux)
	{
		puccbAux.set(this.puccb);
	}
	
	
	@OPERATION
	void setPutcb(double putcb) {
		this.putcb = putcb;
		getObsProperty("putcb").updateValue(putcb);
	}
	
	@OPERATION
	void setPutcbToZero(OpFeedbackParam<Double> putcb) {
		this.putcb = (Double) null;
		getObsProperty("putcb").updateValue(putcb);
	}
	@OPERATION
	void getPutcb(OpFeedbackParam<Double> putcbAux)
	{
		putcbAux.set(this.putcb);
	}
	
	
	@OPERATION
	void setNewCostP(double newCostP) {
		this.newCostP = newCostP;
		getObsProperty("newCostP").updateValue(newCostP);
	}
	
	@OPERATION
	void getNewCostP(OpFeedbackParam<Double> newCostPAux)
	{
		newCostPAux.set(this.newCostP);
	}
	
	
	@OPERATION
	void setNewTimeP(double newTimeP) {
		this.newTimeP = newTimeP;
		getObsProperty("newTimeP").updateValue(newTimeP);
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

}

