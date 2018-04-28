// CArtAgO artifact code for project project_management

package workspaces;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;
import models.Activity;
import models.Employee;
import models.Project;
import simulations.Scenario1_SBQS;
import simulations.Simulate;

import simulations.Scenario1;
import simulations.Scenario2;
import simulations.Scenario3;

public class EnvironmentProject extends Artifact
{	
	private ArrayList< Employee > projectTeamList = new ArrayList<Employee>();
	private Project p = new Project(1, 160, 11200.0f, 0.3, projectTeamList);
	
	List<Simulate> scenarios = new LinkedList<Simulate>();
	
	public void init()
	{
		defineObsProperty("instant", 0);
		defineObsProperty("instantARis", 0);
		defineObsProperty("cenario", "0");
		
		// Propriedades observaveis do projeto.
		defineObsProperty("project", p);
		defineObsProperty("idProject", p.getId());
		defineObsProperty("durationProject", p.getRealDuration());
		defineObsProperty("budgetProject", p.getBudget());

		// Propriedades observaveis das atividades do projeto.
		defineObsProperty("activities", p.getActivities());
		
		defineObsProperty("initialTimeContingencyReserve", p.getTimeContingencyReserve());
		defineObsProperty("initialCostContingencyReserve", p.getCostContingencyReserve());
		
		defineObsProperty("idsActivitiesRunning", p.getIdsActivitiesRunning());
		defineObsProperty("numActivitiesRunning", p.getNumActivitiesRunning());
	}
	
	@OPERATION
	public void simulate()
	{
		Simulate s1 = new Scenario1(p, "Cenario_1");
		Simulate s2 = new Scenario2(p, "Cenario_2");
		Simulate s3 = new Scenario3(p, "Cenario_3");
		Simulate s1_sbqs = new Scenario1_SBQS(p, "SBQS_Cenario_1"); //Cenário Atual Pronto
		//Simulate s2_sbqs= new Scenario2_SBQS(p, "SBQS_Cenario_2");
		scenarios.add(s2);	
		//scenarios.add(s1_sbqs);		
		
		for (Simulate sl: scenarios)
		{
			//prepara e simula!
			getObsProperty("instant").updateValue(0);
			getObsProperty("instantARis").updateValue(0);
			getObsProperty("cenario").updateValue(sl.getName());
			sl.prepare();
			execInternalOp("environmentEvolution");
		}
		getObsProperty("initialTimeContingencyReserve").updateValue(p.getTimeContingencyReserve());
		getObsProperty("initialCostContingencyReserve").updateValue(p.getCostContingencyReserve());
		System.out.println("Project Cost Contingency Reserve = " +p.getCostContingencyReserve());
		System.out.println("Project Time Contingency Reserve = " +p.getTimeContingencyReserve());
	}
	
	@INTERNAL_OPERATION
	public void environmentEvolution()
	{
		ObsProperty durationProject = getObsProperty("durationProject");
		ObsProperty instant = getObsProperty("instant");
		ObsProperty instantARis = getObsProperty("instantARis");
		
		int delay = 0;
		
		while(instant.intValue() < (durationProject.intValue() + delay))
			//Atualizar a duracao real do purged caso alguma atividade ultrapasse o tempo planejado
		{	
			p.setInstant(instant.intValue());
			getObsProperty("numActivitiesRunning").updateValue(p.getNumActivitiesRunning());
			getObsProperty("idsActivitiesRunning").updateValue(p.getIdsActivitiesRunning());
			
			int [] idsActivitiesRunning = new int[p.getNumActivitiesRunning()];
			idsActivitiesRunning = p.getIdsActivitiesRunning();
			
			for (Simulate sl: scenarios)
				sl.simulationScenario(idsActivitiesRunning, instant.intValue());
			
			//verificar se há algum delay nas tarefas (tarefa que ao final do cronograma não tenha sido finalizada)
			if (instant.intValue() >= p.getDuration()-1)
				if (p.existsTaskNotFinalized(instant.intValue())){
					p.addRealDuration(1);
					delay++;
				}
			
			getObsProperty("activities").updateValue(p.getActivities());
			//getObsProperty("risks").updateValue(p.getRisks()); --> nao pode ser atualizada pois ZERA a lista de riscos!
			signal("tickARis");
			instantARis.updateValue(instantARis.intValue() + 1);
			signal("tick");
			await_time(2500);
			instant.updateValue(instant.intValue() + 1);
		}
	}
	
	@OPERATION
	void getDataActivities(int id, OpFeedbackParam<String> label, OpFeedbackParam<Integer> estimedTime, OpFeedbackParam<Integer> currentTime,
						   OpFeedbackParam<Float> estimatedCost, OpFeedbackParam<Float> currentCost, OpFeedbackParam<Integer> timeStoped,
						   OpFeedbackParam<Integer> tes,OpFeedbackParam<Integer> tef, OpFeedbackParam<Integer> tls, OpFeedbackParam<Integer> tlf,
						   OpFeedbackParam<Integer> gap)
	{	
		Activity a = p.getActivityById(id);
		
		label.set(a.getLabel());
		estimedTime.set(a.getEstimatedTime());
		currentTime.set(a.getCurrentTime());
		estimatedCost.set(a.getEstimatedCost());
		currentCost.set(a.getCurrentCost());
		timeStoped.set(a.getTimeStopped());
		tes.set(a.getTearlyStart());
		tef.set(a.getTearlyFinish());
		tls.set(a.getTlateStart());
		tlf.set(a.getTlateFinish());
		gap.set(a.getGAP());
	}
	
}
