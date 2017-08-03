// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import cartago.Artifact;
import cartago.OPERATION;
import models.Project;
import models.Risk;

public class EnvironmentRiskControl extends Artifact {
	
	private List<Risk> risks = new ArrayList<Risk>();
	private Project project;
	
	void init() {
		
	}
	
	@OPERATION
	void setProject(Project p) {
		this.project = p;
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

