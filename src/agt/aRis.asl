// Agent aRis in project projectManagement

/* Initial beliefs and rules */
internalStateARis(null).
internalStateAMud(null).
useTimeContingencyBudget(0). //
useCostContingencyBudget(0).
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
+!kqml_received(Sender, tell, Variables, Response) : instant(K)  & project(P) & risks(RiskList) & timeContingencyBudget(TCB) & costContingencyBudget(CCB) & useTimeContingencyBudget(UTCB) & useCostContingencyBudget(UCCB)<-
 		
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
	CostRem  = RemCost/100;
	TimeRem  = RemTime/100;
	
	
		if(TimeAdd>0){ //aumenta o tempo de uma atividade
			DeltaTimeActivity = ETimeAP*TimeAdd;
			
			NewTimeActivity = DeltaTimeActivity + ETimeAP;
		}else{
			if(TimeRem>0){ 
				DeltaTimeActivity = ETimeAP*TimeRem;
				
				NewTimeActivity = ETimeAP - DeltaTimeActivity;
			}
			
		}	
		
		
		if(CostAdd>0){ //diminui o tempo de uma atividade
				DeltaCostActivity = ECostAP*CostAdd;
				
				NewCostActivity = DeltaCostActivity + ECostAP;
		}else{
				
			if(CostRem>0){
				DeltaCostActivity = ECostAP*CostRem;
				
				NewCostActivity =  ECostA - DeltaCostActivity;
			}
			
		}
	// ATRIBUINDO VALORES
	TimeReserve = TCB - DeltaTimeActivity; // Atualizando o valor da Reserva de Tempo 
	CostReserve = CCB - DeltaCostActivity;
	UseTimeContingencyBudget = UTCB  + DeltaTimeActivity;
	UseCostContingencyBudget = UCCB + DeltaCostActivity;
	PURCT = UseTimeContingencyBudget/ TCB; // Porcentagem do uso da reserva de contingencia de tempo
	PURCC = UseCostContingencyBudget/ CCB; // Porcentagem do uso da reserva de contingencia de custo
	//
	if (RiskList \== null){
		cartago.invoke_obj(RiskList, size, Size);
		for(.range(I, 0, Size-1)){
			
			cartago.invoke_obj(RiskList, get(I), Risk);
			cartago.invoke_obj(Risk, getCostP, CostP);
			cartago.invoke_obj(Risk, getCostI, CostI);
			cartago.invoke_obj(Risk, getTimeP, TimeP);
			cartago.invoke_obj(Risk, getTimeI, TimeI);
			
			if((CostAdd\==0 | CostRem\==0) & CostP \== 0 & CostI \== 0){
				NewCostP = (PURCT*(1-CostP)) + CostP;
			}
			if((TimeAdd\== 0 | TimeRem\==0) & TimeP \== 0 & TimeI \==0){
				NewTimeP = (PURCC*(1-TimeP)) + TimeP;
			}
		.print("CostP = ", CostP);
		.print("NewCostP =", NewCostP);
		//chamar calculateRiskExposure
		}
		//reordenar o vetor de riscos
		
	};
	// ATUALIZANDO CRENÇAS
	-+timeContingencyBudget(TimeReserve);
	-+costContingencyBudget(CostReserve);
	-+useTimeContingencyBudget(UseTimeContingencyBudget);
	-+useCostContingencyBudget(UseCostContingencyBudget);
	
	.print("Actual Time Reserve = ",TimeReserve);
	.print("Actual CostReserve = ", CostReserve);
	.print("ACTIVITY ", Label, " DELTA TIME ", DeltaTimeActivity, " NEW TIME ", NewTimeActivity);
	.print("ACTIVITY ", Label, " DELTA COST ", DeltaCostActivity, " NEW COST ", NewCostActivity).
	
 //iActions.internalRiskControl(Title, Id, State, AddCost, AddTime, RemCost, RemTime, DAddCost, DAddTime, DRemCost, DRemTime, Instant, ActivityId, R);
 
 	

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
			cartago.invoke_obj(Risk, getCostP, TI);
			-+timeI(TI);
			cartago.invoke_obj(Risk, getScopeP, SP);
			-+scopeP(SP);   
			cartago.invoke_obj(Risk, getScopeI, SI);
			-+scopeI(SI);    	
			!calculateRiskExposure(Id);
			!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, "Informacoes do Risco.");		
			iActions.internalStateARis(Id);
		};
		
		//SOLUCAO DE CONTROLE VIA ESTADO INTERNO DO AGENTE
		iActions.internalStateARis(exit, InternalState);
		-+internalStateARis(InternalState);
		
		//SOLUCAO DE CONTROLE VIA AMBIENTE DO ARIS
		//riskControl(RiskList);
		
		if (InternalState \== null){
			.length(InternalState, LengthRiksList);
			.print("Recebi uma lista ordenada do meu estado interno. Ela contem  ", LengthRiksList," riscos.");
			
			
		}	
			
	}.

+tick : instant(K) <-
	!monitoringRisks.
	
	
+project(P) <- 
	cartago.invoke_obj(P, getId, IdProject);
	+idProject(IdProject);
	setProject(P); //setando a propriedade observavel novamente
	.print("ARis observando o Projeto ", IdProject).

+!calculateRiskExposure(Id): costP(CP) & costI(CI) & timeP(TP) & timeI(TI) & scopeP(SP) & scopeI(SI) & risk(Risk)<-
	TotalRiskExposure = (CP*CI)+(TP*TI)+(SP*SI);
	cartago.invoke_obj(Risk, setTotalRiskExposure(TotalRiskExposure));
	//.print("Risk = ",Id," RE = ",TotalRiskExposure); 
	-+totalRiskEsposure(TotalRiskExposure).	
	
+!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, Msg): instant(K) & cenario(Cenario) & totalRiskEsposure(TotalRiskExposure) <-
	iActions.recordLogARis(P, Id, Cenario, K, Name, CP, CI, TP, TI, SP, SI, TotalRiskExposure, Msg).

//+!controllingRisks(RiskList) <-
//	if (RiskList \== null){
//		iActions.internalStateARis(RiskList);
//	};   
//	-+internalStateARis(InternalState).