// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.LinkedList;
import java.util.List;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import models.Activity;
import models.Change;
import models.Project;
import models.StateOfChange;

public class EnvironmentChangeRequest extends Artifact {
	
	private List<Change> requests = new LinkedList<Change>();
	private Project project;
	private int projectInstant = 0;
	private Change actualRequest;
	
	void init() {
		defineObsProperty("requests", requests);
		defineObsProperty("actualRequest", 0);
	}
	
	@OPERATION
	void addChangeRequest(Change c){
		
		requests.add(c);
		getObsProperty("requests").updateValue(requests);
		getObsProperty("actualRequest").updateValue(c);
		if(c.getState() == 1){
			signal("status", "newRequest");
		}
		
	}
	
	@OPERATION
	void setProject(Project p) {
		this.project = p;
	}
	
	@OPERATION
	void setActivities(List<Activity> acts, Byte projectInstant) {
		this.project.setActivities(acts);
		this.projectInstant = projectInstant;
		execInternalOp("updateStates");
	}
	
	@OPERATION
	 void getRequests(OpFeedbackParam<List<Change>> aux)
	{
		aux.set(this.requests);
	}
	
	@OPERATION
	void setRequests(List<Change> resquests) {
		this.requests = resquests;
	}
	
	@OPERATION
	void clearChangeRequests(OpFeedbackParam<List<Change>> aux){
		this.requests.clear();
		aux.set(this.requests);
	}
	
	@OPERATION
	void getActualRequest(OpFeedbackParam<Change> actualRequest)
	{
		actualRequest.set(this.actualRequest);
	}
	
	@OPERATION
	void setActualRequest(Change actualRequest) {
	this.actualRequest = actualRequest;
	}
	
	@OPERATION
	void getChangeRequestById(int id, OpFeedbackParam<Change> change)
	{
		Change c = new Change();
		
		for (Change aux : requests) {
			if(aux.getChange_id()==id){
				c = aux;
			}
		}
		change.set(c);
	}
	@INTERNAL_OPERATION
	private void updateStates(){
		for (Change c: requests){
			if (c.getActivity().getEndInstant() <= projectInstant && c.getState() == StateOfChange.REQUESTED)
				c.setState(StateOfChange.OBSOLETE);
		}
		
	}
}