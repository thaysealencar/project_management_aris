package iActions;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.Term;

public class dataPackageManager extends DefaultInternalAction{
	
	private static final long serialVersionUID = 1L;
	@Override
	public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
		NumberTerm changeId = (NumberTerm) args[0];
		NumberTerm changeStatus	= (NumberTerm) args[1];
		
		ListTerm result = new ListTermImpl();
    	result.add(changeId);
    	result.add(changeStatus);
    	
    	return un.unifies(result, args[2]);
		
	}
	

}
