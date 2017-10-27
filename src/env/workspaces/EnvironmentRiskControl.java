// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.ArrayList;
import java.util.Collections;

import cartago.Artifact;
import cartago.OPERATION;
import models.EnvironmentProperties;
import models.Project;
import models.Risk;

public class EnvironmentRiskControl extends Artifact {
	
	private Project project;
	private EnvironmentProperties environmentProperties;
	
	void init() {
		environmentProperties = new EnvironmentProperties(0.0,0.0,0.0,0.0);
		defineObsProperty("environmentProperties", environmentProperties);
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
	public EnvironmentProperties getEnvironmentProperties() {
		return environmentProperties;
	}

	@OPERATION
	public void setEnvironmentProperties(EnvironmentProperties environmentProperties) {
		this.environmentProperties = environmentProperties;
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

