// Internal action code for project project_management_aris

package iActions;

import java.util.ArrayList;
import java.util.ListIterator;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.Term;
import models.Project;
import models.Risk;
import models.Risk.RiskArea;
import simulations.Scenario1_SBQS;

public class internalRiskControl extends DefaultInternalAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	Project p  = Scenario1_SBQS.getProject();
    	String id = args[0].toString();
    	String name = args[1].toString();
        double div = Double.parseDouble(args[2].toString());
        int riskArea = Integer.parseInt(args[3].toString());
        int impact = 0;
        boolean repeatedRisk = false;
    	
    	Risk r = new Risk();
    	r.setId(Integer.parseInt(id));
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
    	
    	double  totalRiskExposure = r.getScopeP()*r.getScopeI()+r.getCostP()*r.getCostI()+r.getTimeP()*r.getTimeI();
    	r.setTotalRiskExposure(totalRiskExposure);
    	
    	ArrayList<Risk> risks = p.getRisks(); ///VAZIA
    	if(risks != null){
			ListIterator<Risk> litr = risks.listIterator();
		    while (litr.hasNext()) {
		    	Risk element = litr.next();
		    	String riskName = element.getName();
		    	
		    	if(riskName.compareTo(name)==0){
		    		repeatedRisk=true;
		    		System.out.println("lalala");
		    		break;
		    	}
		    }
    	}
	        if(!risks.contains(r) && repeatedRisk==false){ 
	        	risks.add(r); 
	        }
    	
        return true;
    }
}
