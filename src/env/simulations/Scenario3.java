package simulations;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

import models.Activity;
import models.Employee;
import models.Project;
import models.Risk;
import models.Risk.RiskArea;

/*
 *	Cenario 1 : Atividades separadas.
 *	
 *	Conto:
 *	A atividade "A" terminará antes do planejado (adiantada no cronograma), porém irá consumir mais recursos que o planejado (acima do orçamento).
 *	Neste mesmo projeto, porém em um momento distinto do acontecido com "A", a atividade "E" irá terminar após o planejado (atrasado no cronograma), 
 * 	no entanto, consumirá menos recurso do que o planejado (abaixo do orçamento).
 */

public class Scenario3 extends Simulate
{
	
	public static Project project;
	
	public Scenario3(Project p, String name)
	{
		super(p, name);
		project = p;
	}

	@Override
	public void prepare()
	{	
		// Atividades do Projeto.
				Activity A, B, C, D, E, F, G, H, I, J, K, L, M, N;
		// Riscos do Projeto
				Risk R1,R2,R3, R4, R5, R6;
		// Funcionários do Projeto
				Employee E1, E2, E3, E4, E5, E6, E7;
				
				A = new Activity(1, "A", 10, 700.0f);	B = new Activity(2, "B", 5, 350.0f);
				C = new Activity(3, "C", 5, 350.0f);	D = new Activity(4, "D", 15, 1050.0f);
				E = new Activity(5, "E", 25, 1750.0f);	F = new Activity(6, "F", 5, 350.0f);
				G = new Activity(7, "G", 5, 350.0f);	H = new Activity(8, "H", 10, 700.0f);
				I = new Activity(9, "I", 5, 350.0f);	J = new Activity(10, "J", 15, 1050.0f);
				K = new Activity(11, "K", 20, 1400.0f);	L = new Activity(12, "L", 10, 700.0f);
				M = new Activity(13, "M", 25, 1750.0f);	N = new Activity(14, "N", 5, 350.0f);
				
				// Antecessores e Sucessores de cada atividade.
				A.setPredecessorsAndSuccessors(new Activity[]{}, new Activity[]{C, E, L, M, F, I, G, H, J, K, N});
				B.setPredecessorsAndSuccessors(new Activity[]{}, new Activity[]{D, C, E, L, M, F, I, G, H, J, K, N});
				C.setPredecessorsAndSuccessors(new Activity[]{A, B}, new Activity[]{E, L, M, F, I, G, H, J, K, N});
				D.setPredecessorsAndSuccessors(new Activity[]{B}, new Activity[]{F, I, G, H, J, K, N});
				E.setPredecessorsAndSuccessors(new Activity[]{C}, new Activity[]{F, I, G, H, J, K, N});
				F.setPredecessorsAndSuccessors(new Activity[]{D, E}, new Activity[]{I, G, H, J, K, N});
				G.setPredecessorsAndSuccessors(new Activity[]{F}, new Activity[]{J, K, N});
				H.setPredecessorsAndSuccessors(new Activity[]{F}, new Activity[]{K, N});
				I.setPredecessorsAndSuccessors(new Activity[]{F}, new Activity[]{K, N});
				J.setPredecessorsAndSuccessors(new Activity[]{G}, new Activity[]{K, N});
				K.setPredecessorsAndSuccessors(new Activity[]{H, I, J}, new Activity[]{N});
				L.setPredecessorsAndSuccessors(new Activity[]{C}, new Activity[]{M, N});
				M.setPredecessorsAndSuccessors(new Activity[]{L}, new Activity[]{N});
				N.setPredecessorsAndSuccessors(new Activity[]{K, M}, new Activity[]{});
				
				// configuracao temporal
				A.setInstants(0, 10);	B.setInstants(5, 10);
				C.setInstants(12, 17);	D.setInstants(11, 26);
				E.setInstants(18, 43);	F.setInstants(45, 50);
				G.setInstants(46, 51);	H.setInstants(46, 56);
				I.setInstants(46, 51);	J.setInstants(52, 67);
				K.setInstants(68, 88);	L.setInstants(18, 28);
				M.setInstants(19, 44);	N.setInstants(89, 94);
				
				p.clearActivities();
				p.addActivity(A);	p.addActivity(B);
				p.addActivity(C);	p.addActivity(D);
				p.addActivity(E);	p.addActivity(F);
				p.addActivity(G);	p.addActivity(H);
				p.addActivity(I);	p.addActivity(J);
				p.addActivity(K);	p.addActivity(L);
				p.addActivity(M);	p.addActivity(N);
				
				E1 = new Employee(1, "Asdrubal", "Tempo", true);
				p.addEmployee(E1);
				E2 = new Employee(2, "Fransisca" , "Gerenciamento", true);
				p.addEmployee(E2);
				E3 = new Employee(3, "Muller", "RH", true);
				p.addEmployee(E3);
				
				E4 = new Employee(4, "Lala", "RH", true);
				p.addEmployee(E4);
				
				E5 = new Employee(5, "Ana", "RH", false);
				p.addEmployee(E5);
				
				E6 = new Employee(6, "Matilda", "RH", false);
				p.addEmployee(E6);
				
				E7 = new Employee(7, "Sasha", "RH", false);
				p.addEmployee(E7);
				
				R1 = new Risk(1, "Definition of scope", 0, 0, 0, 0, 0.3, 4, 0, RiskArea.SCOPE, 1,1); 
				p.addRisk(R1);
				R2 = new Risk(2, "Misunderstanding of the requisites", 0, 0, 0.5, 5, 0, 0, 0, RiskArea.SCHEDULE, 1,1); 
				p.addRisk(R2);
				R3 = new Risk(3, "Incorporation of a new technology", 0.7, 5, 0, 0, 0, 0, 0, RiskArea.COST, 1,1);
				p.addRisk(R3);
				R4 = new Risk(4, "Unrealistic schedule", 0, 0, 0.9, 3, 0.4, 1, 0, RiskArea.SCHEDULE, 1,1);
				p.addRisk(R4);
				R5 = new Risk(5, "Unrealistic budget", 0.3, 4, 0, 0, 0.5, 1, 0, RiskArea.COST, 1,1);
				p.addRisk(R5);
				//R6 = new Risk(6, "Development errors of the functions or interface", 0, 0, 0, 0, 0.3, 1, 0, RiskArea.SCHEDULE, 1,1);
				//p.addRisk(R6);
				
				
				double aux1 = p.calculateTimeContingencyBudget(p.getContingencyPercentage());
				p.setTimeBudgetReserve(aux1);
				
				double aux2 = p.calculateCostContingencyBudget(p.getContingencyPercentage());
				p.setCostBudgetReserve(aux2);
			
				List<Activity> activities = p.getActivities();
				// Calcula todos os Tes e Tef das atividades.
				for(int i = 0; i < activities.size(); i++)
					activities.get(i).compute_Tes_Tef();
				
				// Calcula todos os Tlf e Tls das atividades.
				for(int j = (activities.size() - 1); j >= 0; j--)
					activities.get(j).compute_Tlf_Tls();
				
				// Calcula todas as folgas das atividades.
				for(int k = 0; k < activities.size(); k++)
					activities.get(k).compute_GAP();
			}

	@Override
	public void simulationScenario(int[] idsActivitiesRunning, int instant)
	{
		double rateEvolutionTime, rateEvolutionCost;		
		
		for (int id : idsActivitiesRunning)
		{	
			Activity a = p.getActivityById(id);
			int currentTime = a.getCurrentTime();
			float currentCost = a.getCurrentCost();
			
			rateEvolutionTime =   ( ( ( instant+1 * 100.0) / a.getEstimatedTime() ) / 100.0);
			rateEvolutionCost = ((a.getInstant(instant)+1.0) /  a.getEstimatedTime()) ;
						
			
			if (id == 1){  
				if (instant >= 4 && instant <= 6){     //Atividade "A" => evolução do tempo para terminar antes do planejado. Ao invés de terminar em 10, terminará em 07					
					a.removeLastInstant();
					a.addRealTime(-1);
					//Nestes instantes em que a atividade "acelerará" deve ser consumido mais recurso que o normal 
					rateEvolutionCost = ((a.getInstant(instant)+1.0) /  a.getEstimatedTime())  + 0.4;
				}
			} 
			
			BigDecimal ret = new BigDecimal(rateEvolutionTime).setScale(10, RoundingMode.DOWN);
			BigDecimal rec = new BigDecimal(rateEvolutionCost).setScale(10, RoundingMode.DOWN);
			currentTime += ret.floatValue() *  a.getEstimatedTime();
			currentCost = (rec.floatValue() * a.getEstimatedCost());
			
			if (id == 5){            //Atividade "E" => evolução do tempo irá atrasar o término. Deveria terminar no instante 43, mas terminará no instante 50.
				if (instant >= 37 && instant <= 44){					
					a.addOneInstant();
					a.addRealTime(1);										
				}	
				if (instant >= 37){  	//A partir do instante 37 a atividades será "desacelerada" para economizar custo de forma que ao final seja consumido menos recurso do que o planejado
					float slowDown = (44 - instant) * (1.0f / (44.0f - 37.0f));            //taxa de freio em relação ao tempo
					rateEvolutionCost =  ((a.getInstant(instant)+slowDown) /  a.getRealTime()) ;
					 rec = new BigDecimal(rateEvolutionCost).setScale(10, RoundingMode.DOWN);					 
					 currentCost = (rec.floatValue() * a.getEstimatedCost());
				}
			}						
			
			a.setCurrentTime(currentTime);
			a.setCurrentCost(currentCost);
		}		
	}	
}
