// Agent aRis in project projectManagement

/* Initial beliefs and rules */
internalStateARis(null).
internalStateAMud(null).
useTimeContingencyBudget(0).
useCostContingencyBudget(0).
changeRequest(false).
/* Initial goals */
!monitoring.
!create.

/* Plans */

+!monitoring : true 	<-	
		?myArtifact(ArtifactId). // descobrir artefato.
		
+!create: true <-
	?myEnvironment(AuxR).

+?myArtifact(ArtifactId) : true
	<-	lookupArtifact("EnvProject", ArtifactId);
		focus(ArtifactId).		

-?myArtifact(ArtifactId) : true
	<-	
		.wait(100);
		!monitoring.		

+?myEnvironment(AuxR) : true
	<-	
	makeArtifact("EnvRiskControl", "workspaces.EnvironmentRiskControl", [], AuxR); //passar a lista de riscos como parametro
	.print("Criei!");
	focus(AuxR).		

-?myEnvironment(CRId) : true
	<-	
		.wait(100);
		!create.	
/*Message */
+!kqml_received(Sender, tell, Variables, Response) : instant(K)  & project(P) & risks(RiskList) & 
timeContingencyBudget(TCB) & costContingencyBudget(CCB) & useTimeContingencyBudget(UTCB) & useCostContingencyBudget(UCCB) & changeRequest(CR) & environmentProperties(EnvironmentProperties)<-

	-+changeRequest(true);
	.print("Change Request = ", CR);
	
	.print("I will evaluate the impact of this change request on the project!");
 	-+internalStateAMud(Variables);
	.nth(0, Variables, Title);
	.nth(1, Variables, Id);
	.nth(2, Variables, State);
	.nth(3, Variables, AddCost);
	.nth(4, Variables, AddTime);
	.nth(5, Variables, RemCost);
	.nth(6, Variables, RemTime);
	.nth(7, Variables, DAddCost);
	.nth(8, Variables, DAddTime);
	.nth(9, Variables, DRemCost);
	.nth(10, Variables, DRemTime);
	.nth(11, Variables, Instant);
	.nth(12, Variables, ActivityId);
	
	getActivity(ActivityId, A);
	
	cartago.invoke_obj(A, getLabel, Label);
	cartago.invoke_obj(A, getEstimatedTime, ETimeAP);
	cartago.invoke_obj(A, getCurrentTime, CTimeAP);
	cartago.invoke_obj(A, getEstimatedCost, ECostAP);
	cartago.invoke_obj(A, getCurrentCost, CCostAP);
	
	
	TimeAdd  = DAddTime/100;
	CostAdd  = DAddCost/100;
	CostRem  = DRemCost/100;
	TimeRem  = DRemTime/100;
	
	
		if(TimeAdd>0){ //aumenta o tempo de uma atividade
			DeltaTimeActivity = ETimeAP*TimeAdd; //percentual de variacao
			
			NewTimeActivity = ETimeAP + DeltaTimeActivity; //novo tempo considerando o percentual de variacao
			
			UseTimeContingencyBudget = UTCB  + DeltaTimeActivity;
		}else{
			if(TimeRem>0){ 
				DeltaTimeActivity = ETimeAP*TimeRem;
				
				NewTimeActivity = ETimeAP - DeltaTimeActivity;
				
				UseTimeContingencyBudget = UTCB - DeltaTimeActivity;
			}
			
		}	
		
		
		if(CostAdd>0){ //diminui o tempo de uma atividade
				DeltaCostActivity = ECostAP*CostAdd;
				
				NewCostActivity = DeltaCostActivity + ECostAP;
				
				UseCostContingencyBudget = UCCB + DeltaCostActivity;
		}else{
				
			if(CostRem>0){
				DeltaCostActivity = ECostAP*CostRem;
				
				NewCostActivity =  ECostA - DeltaCostActivity;
				
				UseCostContingencyBudget = UCCB - DeltaCostActivity;
			}
			
		}
	// ATRIBUINDO VALORES
	TimeReserve = TCB-DeltaTimeActivity; // Atualizando o valor da Reserva de Tempo, sera atualizada quando esses valores da reserva forem descontados no projeto
	CostReserve = CCB-DeltaCostActivity;
	

	cartago.invoke_obj(EnvironmentProperties, setPuccb(UseCostContingencyBudget/CCB));
	cartago.invoke_obj(EnvironmentProperties, setPutcb(UseTimeContingencyBudget/TCB));
	
    .print("Activity ", Label, " Cost variation= ", DeltaCostActivity, " New Cost= ", NewCostActivity);
	.print("Activity ", Label, " Cost variation= ", DeltaTimeActivity, " New Time= ", NewTimeActivity);
	.print("Amount of cost reserve after change= ", CostReserve);
	.print("Amount of time reserve after change= ",TimeReserve);	
	.print("Dear manager, if you apply this change to the project, the following riks will be affected:");

	if (RiskList \== null){
		cartago.invoke_obj(RiskList, size, Size);
		cartago.invoke_obj(EnvironmentProperties, getPuccb, Puccb);
		cartago.invoke_obj(EnvironmentProperties, getPutcb, Putcb);

		for(.range(I, 0, Size-1)){
			
			cartago.invoke_obj(RiskList, get(I), Risk);
			cartago.invoke_obj(Risk, getId, RiskId);
			cartago.invoke_obj(Risk, getCostP, CostP);
			cartago.invoke_obj(Risk, getCostI, CostI);
			cartago.invoke_obj(Risk, getTimeP, TimeP);
			cartago.invoke_obj(Risk, getTimeI, TimeI);
			
			if((CostAdd\==0 | CostRem\==0) & CostP \== 0 & CostI \== 0){
				cartago.invoke_obj(EnvironmentProperties, setNewCostP(Puccb*(1-CostP) + CostP));
				cartago.invoke_obj(EnvironmentProperties, getNewCostP, NewCostP );
				
				.print("Risk ",RiskId,", initial PC = ", CostP,", PC after change =", NewCostP);
				cartago.invoke_obj(Risk, setCostP(NewCostP));
				cartago.invoke_obj(EnvironmentProperties, setNewCostP(0));
				
				
			}
			
			if((TimeAdd\== 0 | TimeRem\==0) & TimeP \== 0 & TimeI \==0){
				cartago.invoke_obj(EnvironmentProperties, setNewTimeP(Putcb*(1-TimeP) + TimeP));
				cartago.invoke_obj(EnvironmentProperties, getNewTimeP, NewTimeP);
				
				.print("Risk ",RiskId,", initial PT = ", TimeP,", PT after change =", NewTimeP);
		
				cartago.invoke_obj(Risk, setTimeP(NewTimeP));
				cartago.invoke_obj(EnvironmentProperties, setNewTimeP(0));
			}
		
		}
		-+changeRequest(false);
		.print("Percentege of cost reserve that will be used= ", Puccb);
		.print("Percentege of time reserve that will be used=", Putcb);
		
		//cartago.invoke_obj(EnvironmentProperties, setPuccb(0/1));
		//cartago.invoke_obj(EnvironmentProperties, setPutcb(0/1));
		cartago.new_obj("models.EnvironmentProperties", [0,0,0,0], NewEnvironmentProperties);
		
	}else{
		.print("No risks affected.");
	};
	-+environmentProperties(NewEnvironmentProperties);
	-+timeContingencyBudget(TimeReserve);
	-+costContingencyBudget(CostReserve);
	-+useTimeContingencyBudget(UseTimeContingencyBudget);
	-+useCostContingencyBudget(UseCostContingencyBudget).

+!monitoringRisks : risks(RiskList) <-
	if (RiskList \== null){
		cartago.invoke_obj(RiskList, size, Size);
		
		for(.range(I, 0, Size-1)){
			cartago.invoke_obj(RiskList, get(I), Risk);
			-+risk(Risk);
			cartago.invoke_obj(Risk, getId, Id);
			cartago.invoke_obj(Risk, getName, Name);
			cartago.invoke_obj(Risk, getCostP, CP);
			-+costP(CP);
			cartago.invoke_obj(Risk, getCostI, CI);
			-+costI(CI);
			cartago.invoke_obj(Risk, getTimeP, TP);
			-+timeP(TP);
			cartago.invoke_obj(Risk, getTimeI, TI);
			-+timeI(TI);
			cartago.invoke_obj(Risk, getScopeP, SP);
			-+scopeP(SP);   
			cartago.invoke_obj(Risk, getScopeI, SI);
			-+scopeI(SI);    	
			!calculateRiskExposure(Id);
			!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, "Risk Information.");		
			iActions.internalStateARis(Id);
		};
		
		//SOLUCAO DE CONTROLE VIA ESTADO INTERNO DO AGENTE
		iActions.internalStateARis(exit, InternalState);
		-+internalStateARis(InternalState);
		
		//SOLUCAO DE CONTROLE VIA AMBIENTE DO ARIS
		//riskControl(RiskList);
		
		if (InternalState \== null){
			.length(InternalState, LengthRiksList);
			.print("I received a risk list in my internal state. This lis contains ", LengthRiksList," risks.");
		}	
			
	}.

+tick : instant(K) & changeRequest(CR) <-
	if(CR == false){
		!monitoringRisks;
	}.
	
+project(P) <- 
	cartago.invoke_obj(P, getId, IdProject);
	+idProject(IdProject);
	setProject(P); //setando a propriedade observavel novamente
	.print("ARis watching the project ", IdProject).

+!calculateRiskExposure(Id): costP(CP) & costI(CI) & timeP(TP) & timeI(TI) & scopeP(SP) & scopeI(SI) & risk(Risk)<-
	TotalRiskExposure = CP*CI+TP*TI+SP*SI;
//	.print("CP = ", CP);
//	.print("CI = ", CI);
//	.print("TP = ", TP);
//	.print("TI = ", TI);
	cartago.invoke_obj(Risk, setTotalRiskExposure(TotalRiskExposure));
	//.print("Risk = ",Id," RE = ",TotalRiskExposure); 
	-+totalRiskEsposure(TotalRiskExposure).	
	
+!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, Msg): instant(K) & cenario(Cenario) & totalRiskEsposure(TotalRiskExposure) <-
	iActions.recordLogARis(P, Id, Cenario, K, Name, CP, CI, TP, TI, SP, SI, TotalRiskExposure, Msg).

