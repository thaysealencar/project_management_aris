// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.LinkedList;
import java.util.List;

import cartago.*;
import models.Project;
import models.Risk;
import simulations.Simulate;

public class EnvironmentRiskControl extends Artifact {
	
	private List<Risk> risks = new LinkedList<Risk>();
	private Project project;
	
	void init() {
		defineObsProperty("risks", risks);
		//execInternalOp("riskControl");
	}
	
	@OPERATION
	void setProject(Project p) {
		this.project = p;
	}
	
	@INTERNAL_OPERATION
	public void riskControl()
	{
		ObsProperty projectRisks = getObsProperty("risks");
		Object[] r = projectRisks.getValues();
		Risk a = (Risk) r[0];
		
		System.out.println(a.getName());
		
		signal("tick");
		await_time(2500);
		//instant.updateValue(instant.intValue() + 1);
	}
}

