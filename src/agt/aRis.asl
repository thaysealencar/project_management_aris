// Agent aRis in project projectManagement

/* Initial beliefs and rules */
internalStateARis(null).
internalStateAMud(null).
useTimeContingencyBudget(0).
useCostContingencyBudget(0).
changeRequest(false).
calculatingMetric(1).
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
+!kqml_received(Sender, tell, Variables, Response) : instant(K)  & project(P) & 
timeContingencyBudget(TCB) & costContingencyBudget(CCB) & useTimeContingencyBudget(UTCB) & useCostContingencyBudget(UCCB) & changeRequest(CR) <-

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
	CostRem  = RemCost/100;
	TimeRem  = RemTime/100;
	
	
		if(TimeAdd>0){ //aumenta o tempo de uma atividade
			DeltaTimeActivity = ETimeAP*TimeAdd; //percentual de variação
			
			NewTimeActivity = ETimeAP + DeltaTimeActivity; //novo tempo considerando o percentual de variação
			
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
	TimeReserve = TCB-DeltaTimeActivity; // Atualizando o valor da Reserva de Tempo, ser? atualizada quando esses valores da reserva forem descontados no projeto
	CostReserve = CCB-DeltaCostActivity;
	
	.print("CostReserve :", CostReserve);
	
	.print("Activity ", Label, " Cost variation= ", DeltaCostActivity, " New Cost= ", NewCostActivity);
	.print("Activity ", Label, " Cost variation= ", DeltaTimeActivity, " New Time= ", NewTimeActivity);
	.print("Amount of cost reserve after change= ", CostReserve);
	.print("Amount of time reserve after change= ",TimeReserve);
	.print("Dear manager, if you apply this change to the project, the following riks will be affected:");
	
	setPucr(UseCostContingencyBudget/CCB);
	setPutr(UseTimeContingencyBudget/TCB);
	// No futuro, trocar CCB e TCB por TimeReserve e CostReserve


	cartago.invoke_obj(P, getRisks, RiskList);
	if (RiskList \== null){
		cartago.invoke_obj(RiskList, size, Size);
		
		// PUTR E PUCR Porcentagem de uso das reservas de tempo e custo.
		getPucr(Pucr);
		.print("Percentage of Use of Cost Reserve!", Pucr);
		getPutr(Putr);
	   .print("Percentage of Use of Time Reserve!", Putr);
	
		for(.range(I, 0, Size-1)){
			
			cartago.invoke_obj(RiskList, get(I), Risk);
			cartago.invoke_obj(Risk, getId, RiskId);
			cartago.invoke_obj(Risk, getCostP, CostP);
			cartago.invoke_obj(Risk, getCostI, CostI);
			cartago.invoke_obj(Risk, getTimeP, TimeP);
			cartago.invoke_obj(Risk, getTimeI, TimeI);
			
			if((CostAdd\==0 | CostRem\==0) & CostP \== 0 & CostI \== 0){
				setNewCostP(Pucr*(1-CostP) + CostP);
				getNewCostP(NewCostP);
				
				.print("Risk ",RiskId,", initial PC = ", CostP,", PC after change =", NewCostP);
				
				cartago.invoke_obj(Risk, setCostP(NewCostP));
				setNewCostP(0.0);
			}
			if((TimeAdd\== 0 | TimeRem\==0) & TimeP \== 0 & TimeI \==0){
				setNewTimeP(Putr*(1-TimeP) + TimeP);
				getNewTimeP(NewTimeP);
				
				.print("Risk ",RiskId,", initial PT = ", TimeP,", PT after change =", NewTimeP);
				
				cartago.invoke_obj(Risk, setTimeP(NewTimeP));
				setNewTimeP(0.0);
			}
		}
		
		.print("Percentege of cost reserve that will be used= ", Pucr);
		.print("Percentege of time reserve that will be used=", Putr);
		
	}else{
		.print("No risks affected.");
	};
	!calculateMetrics(Purc, Putr, TimeReserve, CostReserve);
	//O agente deve esquecer:  PUCCB, PUTCB, NewCostP, NewTimeP
	
	
	-+timeContingencyBudget(TimeReserve);
	-+costContingencyBudget(CostReserve);
	-+useTimeContingencyBudget(0);
	-+useCostContingencyBudget(0).
	

+!monitoringRisks :  project(P) & calculatingMetric(CM) <- 
	if(CM \== 0){
	.print("Vou monitorar!");
	cartago.invoke_obj(P, getRisks, RiskList);
	if (RiskList \== null){
		.print("Monitorando!");
		cartago.invoke_obj(RiskList, size, Size);
		
		for(.range(I, 0, Size-1)){
			
			cartago.invoke_obj(RiskList, get(I), Risk);
			-+risk(Risk);
			cartago.invoke_obj(Risk, getId, Id);
			cartago.invoke_obj(Risk, getName, Name);
			cartago.invoke_obj(Risk, getCostP, CP);
			cartago.invoke_obj(Risk, getCostI, CI);
			cartago.invoke_obj(Risk, getTimeP, TP);
			cartago.invoke_obj(Risk, getCostP, TI);
			cartago.invoke_obj(Risk, getScopeP, SP);
			cartago.invoke_obj(Risk, getScopeI, SI);
			!calculateRiskExposure(CP, CI, TP, TI, SP, SI);
			-+risk(Risk);
			
			//!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, "Risk Information.");		
			iActions.internalStateARis(Id); //Adiciona risco na lista. Isso é feito iterativamente pois as propriedades dos riscos sofrem alterações no decorrer do tempo.
			
		};
		
		
		iActions.internalStateARis(exit, InternalState); //Apos adicionar todos os riscos o agente ordena a lista de riscos pela ER.	
		-+project(P);
	}
}.
+!calculateRiskExposure(CP, CI, TP, TI, SP, SI): risk(Risk)<-
	TotalRiskExposure = (CP*CI)+(TP*TI)+(SP*SI);
	cartago.invoke_obj(Risk, setTotalRiskExposure(TotalRiskExposure));
	-+totalRiskEsposure(TotalRiskExposure).	
	
//+!recordLog(Id, Name, CP, CI, TP, TI, SP, SI, Msg): instant(K) & cenario(Cenario) & totalRiskEsposure(TotalRiskExposure) <-
//	iActions.recordLogARis(P, Id, Cenario, K, Name, CP, CI, TP, TI, SP, SI, TotalRiskExposure, Msg).

+tick : instant(K) <-
	!monitoringRisks.
	
	
+project(P) <- // Toda vida que eu atualizar uma crença com -+, faço um "plano" com a crença e atualizo dentro do projeto :D 
	cartago.invoke_obj(P, getId, IdProject);
	+idProject(IdProject);
	setProject(P); //setando a propriedade observavel novamente
	.print("ARis is observing the project: ", IdProject).
	
+!calculateMetrics(Pucr, Putr, TimeReserve, CostReserve): project(P) & timeContingencyBudget(TCB) & costContingencyBudget(CCB)& 
costCRCounter(CcrC) & timeCRCounter(TcrC) & qualifiedWorkersTemp(QwT) & projectTeam(ProjectTeam) <-
	+calculatingMetric(0);
	.println("METRIC 1");
	if(Pucr > 0){
		A= CcrC+1;
		-+costCRCounter(A);
		.print("CostCRCounter is now ", A);
		
		POCR = CostReserve/CCB;
		.print("CostReserve/CCB = ", POCR);
		if(POCR > 0.90 & POCR < 0.99){
		 	.print("Manager, the Projects Cost Reserve is low! Percentage of Cost Reserve = ", POCR);
		 	
		 	if(POCR < 0.99){
				.print("Manager, I have detected a new risk in this project! You should talk to the project sponsor about the Cost Reserve.");
				cartago.invoke_obj(P, getRisks, RiskList);
				cartago.invoke_obj(RiskList, size, RLSize);
				Id = RLSize+1;
				.concat("Insufficient Cost Reserve to apply changes in the project", Msg);
				iActions.internalRiskControl(Id, Msg, POCR, 2);
			setProject(P);
			}
		}
	}
	.println("METRIC 2");
	if(Putr > 0){
		B = TcrC+1;
		-+timeCRCounter(B);
		.print("TimeCRCounter is now ", B);
		
		POTR = TimeReserve/TCB;
		.print("TimeReserve/TCB = ", POTR);
		if(POTR > 0.30 & POTR < 0.60){
		 	.print("Manager, the Projects Time Reserve is low! Percentage of Time Reserve = ", POTR);
		 	
		 	if(POTR < 0.31){
				.print("Manager, I have detected a new risk in this project! You should check your team members and activities schedule.");
				cartago.invoke_obj(P, getRisks, RiskList);
				cartago.invoke_obj(RiskList, size, RLSize);
				Id = RLSize+1;
				.concat("Insufficient Time Reserve to apply changes in the project", Msg);
				iActions.internalRiskControl(Id, Msg, POTR, 3);
			-+project(P);	
			}
		}
	}
	.println("METRIC 3");
	cartago.invoke_obj(P, getProjectTeam, ProjectTeam);
	if (ProjectTeam \== null){
		cartago.invoke_obj(ProjectTeam, size, Size);
		if(Size>0){
			.print("Total number of workers= ",Size);
			cartago.invoke_obj(QwT, clear);
			
			for(.range(I, 0, Size-1)){
				cartago.invoke_obj(ProjectTeam, get(I), Employee);
				cartago.invoke_obj(Employee, isQualified, Qualified);
				
				if(Qualified == true){
				  cartago.invoke_obj(QwT, add(Employee));
				  .print("Eu adicionei, Thayse, calma!");
				}
				
			}
			
			//-+qualifiedWorkersTemp(QwT); 
			if(QwT \== null){
				cartago.invoke_obj(QwT, size, SizeQwT);
				.print("Number of qualified workers is ", SizeQwT);	
				
				if(SizeQwT>0){
					Div = SizeQwT/Size;
					.print("The percentege of qualified workers is ", Div);
					
					if(Div > 0.30 & Div < 0.60 ){ 
						
					 	.print("Manager, I have detected a new risk in this project due to the percentege of qualified workers! You should hire more qualified workers or provide training to your team members.");
					 	cartago.invoke_obj(P, getId, Id);
					 	.print("Id do Projeto = ", Id);
						cartago.invoke_obj(P, getRisks, RiskList);
						cartago.invoke_obj(RiskList, size, RLSize);
						Id = RLSize+1;
						.concat("Team members are not qualified to the project", Msg);
						
						iActions.internalRiskControl(Id, Msg, Div, 5);
						
					 	setProject(P);
					}else{
						
						if(Div < 0.31){
							//RISCO ACONTECEU!----PROBABILIDADE=100 E ALTERAR AS RESERVAS DE CONTINGENCIA
							.print("Manager, I have detected the risk X has happened.");
							//iActions.internalRiskControl("Team members are not qualified to the project.",100, 0); 
						}
					}
						
				}
				//-+projectTeam(ProjectTeam);
				cartago.invoke_obj(QwT, clear);
				 -+qualifiedWorkersTemp(QwT);
			}
			
		}
	-+project(P);
	-+calculatingMetric(1);
	}.

	