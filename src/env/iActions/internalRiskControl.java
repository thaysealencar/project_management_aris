// Internal action code for project project_management_aris

package iActions;

import java.util.ArrayList;

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
    	
    	Risk r = new Risk();
    	r.setId(Integer.parseInt(id));
    	r.setName(name);
    	r.setCostP(0.6); //Esses valores devem ser calculados de alguma maneira
    	r.setCostI(1);
    	r.setTimeP(0);
    	r.setTimeI(0);
    	r.setScopeP(0);
    	r.setScopeI(0);
    	r.setRiskArea(RiskArea.STAFF);
    	double  totalRiskExposure = r.getScopeP()*r.getScopeI()+r.getCostP()*r.getCostI()+r.getTimeP()*r.getTimeI();
    	r.setTotalRiskExposure(totalRiskExposure);
    	
		ArrayList<Risk> risks = p.getRisks();
    	
        if(!risks.contains(r)){
        	risks.add(r);
        }
        return true;
    }
}
