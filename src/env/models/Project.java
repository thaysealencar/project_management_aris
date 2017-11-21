package models;

import java.util.ArrayList;

public class Project
{	
	private int id;
	private double duration;
	private double realDuration;
	private float budget;
	private int instant;
	private double timeContingencyBudget;
	private double costContingencyBudget;
	private double scopContingencyBudget;
	private double contingencyPercentage;
	
	private ArrayList< Employee > projectTeam;
	private ArrayList<Activity> activities = new ArrayList<Activity>();
	private ArrayList<Risk> risks = new ArrayList<Risk>();
	
	public Project()
	{
		id		 	= 0;
		duration 	= 0;
		budget		= 0.0f;
		instant 	= 0;
		contingencyPercentage = 0;
		projectTeam = null; // Array List inicializa zero como null;
		
	}
	
	

	public Project(int id, int duration, float budget, double contingencyPercentege, ArrayList projectTeamList)
	{
		this.id			= id;
		this.duration	= duration;
		this.budget		= budget;
		this.realDuration = this.duration;
		this.contingencyPercentage = contingencyPercentege;
		this.projectTeam = new ArrayList<Employee>();
		
	}
	
	



	



	/*************************************************
	  					ACTIVITIES
	 **************************************************/
	public void clearActivities()
	{
		activities.clear();
	}
	public void addActivity(Activity a)
	{
		activities.add(a);
	}
	public void addRealDuration(int time)
	{
		this.realDuration += time;
	}
	public boolean existsTaskNotFinalized(int instant)
	{           //verifica se todas as tarefas acabaram
		for (Activity a: activities)
			if (a.getRealTime() > instant)
				return true;
		return false;
	}
	
	public int getNumActivitiesRunning()
	{
		int cnt = 0;
		for (int i = 0; i < activities.size(); i++)
		{
			if(activities.get(i).isRunning(instant))
				cnt++;
		}
		return cnt;
	}

	public int[] getIdsActivitiesRunning()
	{
		int numActivitiesRunning = getNumActivitiesRunning();
		int [] ids = new int[numActivitiesRunning];
		int cnt = 0;
		
		for (Activity a : activities)
		{
			if(a.isRunning(instant))
				ids[cnt++] = a.getId();
		}
		return ids;
	}
	
	public Activity getActivityById(int id)
	{	
		Activity activity = new Activity();
		
		for (int i = 0; i < activities.size(); i++)
		{
			if(activities.get(i).getId() == id)
				activity = activities.get(i);
		}
		return activity;
	}
	
	public Object[] getActivitiesByInstant()
	{
		ArrayList<Activity> activs = new ArrayList<Activity>();
		
		for (Activity a : activities)
		{
			if(a.isRunning(instant))
				activs.add(a);
		}
		return activs.toArray(new Activity[]{});
	}
	
	/*************************************************
		RISKS
	 **************************************************/
	public void addRisk(Risk a)
	{
		risks.add(a);
	}
	public void clearRisk()
	{
		risks.clear();
	}
	public Risk getRiskById(int id)
	{	
		Risk risk =  new Risk();
		
		for (int i = 0; i < risks.size(); i++)
		{
			if(risks.get(i).getId() == id)
				risk = risks.get(i);
		}
		return risk;
	}

	public void addEmployee(Employee e)
	{
		projectTeam.add(e);
	}
	
	public double calculateTimeContingencyBudget(double contingencyPercentage)
	{
		this.timeContingencyBudget = contingencyPercentage * this.duration;
		
		return this.timeContingencyBudget;
		
	}
	
	public double calculateCostContingencyBudget(double contingencyPercentage)
	{
		this.costContingencyBudget = contingencyPercentage * this.budget;
		
		return this.costContingencyBudget;
		
	}
	
	
	
	

	
	
	/*************************************************
							GETS
	 **************************************************/
	public int getId()
	{
		return id;
	}
	
	public double getDuration()
	{
		return duration;
	}
	
	public double getRealDuration()
	{
		return realDuration;
	}

	public float getBudget()
	{
		return budget;
	}
	
	public int getInstant()
	{
		return instant;
	}	
	
	public ArrayList<Activity> getActivities()
	{
		return activities;
	}
	
	public ArrayList<Risk> getRisks()
	{
		return risks;
	}
	public ArrayList<Employee> getEmployee()
	{
		return projectTeam;
	}
	
	public double getTimeBudgetReserve() 
	{
		return timeContingencyBudget;
	}
	
	public double getCostBudgetReserve()
	{
		return costContingencyBudget;
	}
	
	public double getScopBudgetReserve() 
	{
		return scopContingencyBudget;
	}
	
	public ArrayList<Employee> getProjectTeam() 
	{
		return projectTeam;
	}
	
	public double getContingencyPercentage() 
	{
		return contingencyPercentage;
	}
	/**********************************************
						SETS
	 **********************************************/

	public void setInstant(int instant)
	{
		this.instant = instant;
	}

	public void setActivities(ArrayList<Activity> activities) {
		this.activities = activities;
	}
	
	public void setRisks(ArrayList<Risk> risks) {
		this.risks = risks;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public void setBudget(float budget) {
		this.budget = budget;
	}
	
	public void setTimeBudgetReserve(double aux)
	{
		this.timeContingencyBudget = aux;
	}
	
	public void setCostBudgetReserve(double costBudgetReserve)
	{
		this.costContingencyBudget = costBudgetReserve;
	}

	public void setScopBudgetReserve(double scopBudgetReserve) 
	{
		this.scopContingencyBudget = scopBudgetReserve;
	}
	
	public void setProjectTeamList(ArrayList<Employee> projectTeamList) 
	{
		this.projectTeam = projectTeamList;
	}
	
	public void setContingencyPercentage(double contingencyPercentage) 
	{
		this.contingencyPercentage = contingencyPercentage;
	}
}