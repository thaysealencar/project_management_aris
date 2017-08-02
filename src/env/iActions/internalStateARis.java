package iActions;

import java.util.ArrayList;
import java.util.List;

import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTerm;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.Term;
import models.Risk;

public class internalStateARis extends DefaultInternalAction
{
	private static final long serialVersionUID = 1L;
	private List<Risk> internalState = new ArrayList<Risk>();
	
    @Override
    public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception
    {
    
    	List<Risk> risks = new ArrayList<Risk>();
    	risks =  (List<Risk>) args[0];
    	
    	if(risks!=null){
    		for (Risk risk : risks) {
    			System.out.println(risk.getName());
    	    	internalState.add(risk);

    		}
    	}else{
    		System.out.println("Lista Vazia");
    	}
    	
    	
    	
   	ListTerm result = new ListTermImpl();
//    	for (Risk r : internalState)
//    	{
//    		Term t = new Risk();
//    		result.add(t);
//		}
    	
    	return un.unifies(result, args[1]);
    }

}
