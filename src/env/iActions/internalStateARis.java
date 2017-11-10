// Internal action code for project project_management_aris

package iActions;

import java.util.ArrayList;
import java.util.Collections;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Term;
import models.Project;
import models.Risk;
import simulations.Scenario1_SBQS;

public class internalStateARis extends DefaultInternalAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private ArrayList<Risk> risks = new ArrayList<Risk>();
		
	@Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	Project p  = Scenario1_SBQS.getProject();
		String id = args[0].toString();
        
        if(id.equals("exit")) {
        	ListTerm result = new ListTermImpl();
        	
        	Collections.sort(risks);
        	
        	System.out.println("Risks Ordered");
    		for (Risk r : risks) {
    			System.out.println("Risk ID "+ r.getId()+ " - RE= "+r.getTotalRiskExposure());
    			Term t = new NumberTermImpl(r.getId());
    			result.add(t);
    		}
    		risks.clear();
    		return un.unifies(result, args[1]); //mandando a lista de id's de riscos ordenada de volta para o Aris
    		
        }
        	Risk risk = p.getRiskById(Integer.parseInt(id));
        	
            if(!risks.contains(risk)){
            	risks.add(risk);
                System.out.println("I added the risk= "+ id +" The size of the list is now=" + risks.size());
            }
            return true;
        }
        
        
    }
