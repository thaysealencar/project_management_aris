// CArtAgO artifact code for project projectManagement

package workspaces;

import java.util.ArrayList;
import java.util.ListIterator;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import models.Employee;
import models.Project;
import models.Risk;
import models.Risk.RiskArea;
import simulations.Scenario1;
import simulations.Scenario1_SBQS;

public class EnvironmentRiskControl extends Artifact {
	
	private Project project;
	double newCostP, newTimeP, pucr, putr, costCRCounter, timeCRCounter, scopeCRCounter, qualifiedWorkersCounter;
	int instantCounter;
	ArrayList< Employee > qualifiedWorkersTemp = new ArrayList<Employee>();

	void init() {
		defineObsProperty("newCostP", 0.0);
		defineObsProperty("newTimeP", 0.0);
		defineObsProperty("pucr", 0.0);
		defineObsProperty("putr", 0.0);
		
		//propriedades observaveis auxiliares
		defineObsProperty("costCRCounter", 0.0);
		defineObsProperty("timeCRCounter", 0.0);
		defineObsProperty("scopeCRCounter", 0.0);
		defineObsProperty("qualifiedWorkersTemp", qualifiedWorkersTemp);
		defineObsProperty("instantCounter", 0);
	}

	@OPERATION
	 void getProject(OpFeedbackParam<Project> p) {
		project  = Scenario1_SBQS.getProject();
		p.set(project);
	}

	@OPERATION
	 void setProject(Project project) {
		this.project = project;
		//getObsProperty("risks").updateValue(project.getRisks());
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
    void getQualifiedWorkersCounter(OpFeedbackParam<Double> QwCAux)
    {
    	QwCAux.set(this.qualifiedWorkersCounter);
    }
    @OPERATION
	void setQualifiedWorkersCounter(double qualifiedWorkersCounter) {
		this.qualifiedWorkersCounter = qualifiedWorkersCounter;
	}
    
    @OPERATION
    void getQualifiedWorkersTemp(OpFeedbackParam<ArrayList<Employee>> qualifiedWorkersTempAux) {
    	qualifiedWorkersTempAux.set(this.qualifiedWorkersTemp);
	}
    
    @OPERATION
	void setQualifiedWorkersTemp(ArrayList<Employee> qualifiedWorkersTemp) {
		this.qualifiedWorkersTemp = qualifiedWorkersTemp;
	}
    
    @OPERATION
    void getInstantCounter(OpFeedbackParam<Integer> k) {
  		k.set(this.instantCounter);
  	}
    
    @OPERATION
    void setInstantCounter(int instantCounter) {
  		this.instantCounter = instantCounter;
  	}
    
    
    @OPERATION
	void setCostCRCounter(double costCRCounter) {
    	this.costCRCounter = costCRCounter;
    	getObsProperty("costCRCounter").updateValue(costCRCounter);
	}

	@OPERATION
	 void getCostCRCounter(OpFeedbackParam<Double> costCRCounter)
	{
		costCRCounter.set(this.costCRCounter);
	}
	
	@OPERATION
	void setTimeCRCounter(double timeCRCounter) {
	    this.timeCRCounter = timeCRCounter;
	    getObsProperty("timeCRCounter").updateValue(timeCRCounter);
	}

	@OPERATION
	void getTimeCRCounter(OpFeedbackParam<Double> timeCRCounter)
	{
		timeCRCounter.set(this.timeCRCounter);
	}
  
	@OPERATION
	void setScopeCRCounter(double scopeCRCounter) {
	    this.scopeCRCounter = scopeCRCounter;
	    getObsProperty("scopeCRCounter").updateValue(scopeCRCounter);
	}

	@OPERATION
	void getScopeCRCounter(OpFeedbackParam<Double> scopeCRCounter)
	{
		scopeCRCounter.set(this.scopeCRCounter);
	}

	@OPERATION
 	void calculateInstantCounter(int temp_k) {
    	if(temp_k>0 && temp_k % 4 == 0){
    		this.instantCounter = temp_k;
    		getObsProperty("instantCounter").updateValue(temp_k);
    	}else{
    		this.instantCounter = -1;
    		getObsProperty("instantCounter").updateValue(-1);
    	}
 		
 	}

	@OPERATION
    void calculateMetrics(String name_p, double div_p, int riskArea_p, OpFeedbackParam<Project> succOutCP){
		Project p  = Scenario1_SBQS.getProject();
    	String name = name_p;
        double div = div_p;
        int riskArea = riskArea_p;
        ArrayList<Risk> risks = p.getRisks();
        int id = risks.size()+1;
        int impact = 0;
        boolean repeatedRisk = false;
        //System.out.println("Esse projeto tem "+p.getRisks().size()+" riscos");
       
        Risk r = new Risk();
    	r.setId(id);
    	r.setName(name);
    	r.setCostP(0); 
		r.setCostI(0);
		r.setTimeP(0);
		r.setTimeI(0);
		r.setScopeP(0);
    	r.setScopeI(0);
    	
    	if(div>=0.8 && div<=1){
    		impact = 1; 
    	}else if(div>=0.6 && div<=0.79){
    		impact = 2; 
    	}else if(div>=0.4 && div<=0.59){
    		impact = 3; 
    	}else if(div>=0.2 && div<=0.39){
    		impact = 4; 
    	}else{
    		impact = 5; 
    	}

    	switch(riskArea){
    		case 1:
    			r.setScopeP(1-div);
            	r.setScopeI(impact);
            	r.setRiskArea(RiskArea.SCOPE);
    			break;
    		case 2:
    			r.setCostP(1-div); 
    			r.setCostI(impact);
    			r.setRiskArea(RiskArea.COST);
        		break;
    		case 3:
    			r.setTimeP(1-div);
    			r.setTimeI(impact);
    			r.setRiskArea(RiskArea.SCHEDULE);
        		break;
    		case 4:
    			r.setCostP(1-div); 
    			r.setCostI(impact);
    			r.setTimeP(1-div);
    			r.setTimeI(impact);
    			r.setRiskArea(RiskArea.TECNICAL);
        		break;
    		case 5:
    			r.setCostP(1-div); 
    			r.setCostI(impact);
    			r.setTimeP(1-div);
    			r.setTimeI(impact);
    			r.setScopeP(1-div);
            	r.setScopeI(impact);
            	r.setRiskArea(RiskArea.STAFF);
        		break;
    		case 6:
    			r.setCostP(1-div); 
    			r.setCostI(impact);
    			r.setTimeP(1-div);
    			r.setTimeI(impact);
    			r.setScopeP(1-div);
            	r.setScopeI(impact);
            	r.setRiskArea(RiskArea.COSTUMER);
        		break;
        	default: r.setCostP(1); 
					 r.setCostI(impact);
					 r.setTimeP(1);
					 r.setTimeI(impact);
					 r.setScopeP(1);
		        	 r.setScopeI(impact);
    	}

    	
    	if(risks != null){
			ListIterator<Risk> litr = risks.listIterator();
		    while (litr.hasNext()) {
		    	Risk element = litr.next();
		    	String riskName = element.getName();
		    	
		    	if(riskName.compareTo(name)== 0){
		    		repeatedRisk=true;
		    		
		    		break;
		    	}
		    }
    	}
    	
    	if(risks != null && repeatedRisk==false ){
    		 if(!risks.contains(r)){
 	        	risks.add(r); 
 	        }
    	}
    	
    	p.setRisks(risks);
    	//System.out.println("O numero de riscos no projeto agora é "+p.getRisks().size());
    	succOutCP.set(p);
	}
    
    
    //OpFeedbackParam<Project> succOutCP
    
    @OPERATION // Receber todos os par�metros da cria��o do risco
    void createRisk(String name_p, double costP_p, int costI_p, double timeP_p, int timeI_p, double scopeP_p, int scopeI_p, double totoalRiskExposure_p, int riskArea_p, OpFeedbackParam<Project> succOutCP){
	    Project p  = Scenario1.getProject();
		String name = name_p;
		double costP = costP_p;
		int costI = costI_p;
		double timeP = timeP_p;
		int timeI = timeI_p;
		double scopeP = scopeP_p;
		int scopeI = scopeI_p;
		double totalRE = totoalRiskExposure_p;
		int    riskArea = riskArea_p;
	    ArrayList<Risk> risks = p.getRisks();
	    int id = risks.size()+1;
	    int impact = 5; // Coloquei direto o maior impacto
	    boolean repeatedRisk = false;
	    
	    Risk r = new Risk();
    	r.setId(id);
    	r.setName(name);
    	r.setCostP(costP); 
		r.setCostI(costI);
		r.setTimeP(timeP);
		r.setTimeI(timeI);
		r.setScopeP(scopeP);
    	r.setScopeI(scopeI);
    	r.setTotalRiskExposure(totalRE);
    	
    	switch(riskArea){
		case 1:
			r.setRiskArea(RiskArea.SCOPE);
			break;
		case 2:
			r.setRiskArea(RiskArea.COST);
    		break;
		case 3:
			r.setRiskArea(RiskArea.SCHEDULE);
    		break;
		case 4:
			r.setRiskArea(RiskArea.TECNICAL);
    		break;
		case 5:
        	r.setRiskArea(RiskArea.STAFF);
    		break;
		case 6:
        	r.setRiskArea(RiskArea.COSTUMER);
    		break;
   
	}
    	if(risks != null){
			ListIterator<Risk> litr = risks.listIterator();
		    while (litr.hasNext()) {
		    	Risk element = litr.next();
		    	String riskName = element.getName();
		    	
		    	if(riskName.compareTo(name)== 0){
		    		repeatedRisk=true;
		    		
		    		break;
		    	}
		    }
    	}
    	
    	if(risks != null && repeatedRisk==false ){
    		 if(!risks.contains(r)){
 	        	risks.add(r); 
 	        }
    	}
    	
    	p.setRisks(risks);
    	//System.out.println("O numero de riscos no projeto agora é "+p.getRisks().size());
    	succOutCP.set(p);
    	
	    }
}


