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
		
		Term State = null;
		
		 if (args[2].isNumeric()){
			 State  = (NumberTerm) args[2];
		 }else if (args[2].isLiteral()){
			 State  = (StringTerm) args[2];
		 }

		NumberTerm AddCost = (NumberTerm) args[3];
		NumberTerm AddTime = (NumberTerm) args[4];
		NumberTerm RemCost = (NumberTerm) args[5];
		NumberTerm RemTime = (NumberTerm) args[6];
		NumberTerm DAddCost = (NumberTerm) args[7];
		NumberTerm DAddTime = (NumberTerm) args[8];
		NumberTerm DRemCost = (NumberTerm) args[9];
		NumberTerm DRemTime = (NumberTerm) args[10];
		NumberTerm instant = (NumberTerm) args[11];
		
		System.out.println(p.getTimeBudgetReserve());
		System.out.println(p.getCostBudgetReserve());
		
		Activity a = new Activity();
	
		Change c = new Change(Integer.parseInt(Id.toString()), Title.toString(), Integer.parseInt(instant.toString()), new Activity(),1);
		//System.out.println(c.getChange_id());
		
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
    	result.add(instant);
    	
    	
		return un.unifies(result, args[12]);
    }
}
