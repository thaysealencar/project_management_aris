// Internal action code for project project_management_aris

package iActions;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.StringTerm;
import jason.asSyntax.Term;
import models.Activity;
import models.Change;
import models.Project;
import simulations.Scenario1_SBQS;

public class internalRiskControl extends DefaultInternalAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    	Project p  = Scenario1_SBQS.getProject();
    	
    	StringTerm Title = (StringTerm) args[0];
    	NumberTerm Id	= (NumberTerm) args[1];
    	StringTerm State  = (StringTerm) args[2];
		NumberTerm AddCost = (NumberTerm) args[3];
		NumberTerm AddTime = (NumberTerm) args[4];
		NumberTerm RemCost = (NumberTerm) args[5];
		NumberTerm RemTime = (NumberTerm) args[6];
		NumberTerm DAddCost = (NumberTerm) args[7];
		NumberTerm DAddTime = (NumberTerm) args[8];
		NumberTerm DRemCost = (NumberTerm) args[9];
		NumberTerm DRemTime = (NumberTerm) args[10];
		NumberTerm Instant = (NumberTerm) args[11];
		NumberTerm ActivityId = (NumberTerm) args[12];
	

		System.out.println(p.getTimeBudgetReserve());
		System.out.println(p.getCostBudgetReserve());
		
		ListTerm result = new ListTermImpl();
    	result.add(Title);
    	result.add(Id);
    	result.add(State);
    	result.add(AddCost);
    	result.add(AddTime);
    	result.add(RemCost);
    	result.add(RemTime);
    	result.add(DAddCost);
    	result.add(DAddTime);
    	result.add(DRemCost);
    	result.add(DRemTime);
    	result.add(Instant);
    	result.add(ActivityId);
    	
		return un.unifies(result, args[13]);
    }
}
