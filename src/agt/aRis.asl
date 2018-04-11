// Agent aRis in project projectManagement

/* Initial beliefs and rules */
internalStateARis(null).
useTimeContingencyReserve(0).
useCostContingencyReserve(0).
actualTimeContingencyReserve(0).
actualCostContingencyReserve(0).
pucr(0).
putr(0).
costCRCounter(0).
timeCRCounter(0).
scopeCRCounter(0).
totalChangeRequests(0).
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
	makeArtifact("EnvRiskControl", "workspaces.EnvironmentRiskControl", [], AuxR); 
	.print("EnvironmentRiskControl artifact created!");
	focus(AuxR).		

-?myEnvironment(CRId) : true
	<-	
		.wait(100);
		!create.	
/*Message */
+!kqml_received(Sender, tell, Variables, Response) : instant(K)  & project(P) & initialTimeContingencyReserve(ITCR) & initialCostContingencyReserve(ICCR) & useTimeContingencyReserve(UTCR) & useCostContingencyReserve(UCCR) & changeRequest(CR) <-
	
	-+changeRequest(true);
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
	
	
		if(TimeAdd>0){ //se mudanca aumenta o tempo de uma atividade
			DeltaTimeActivity = ETimeAP*TimeAdd; //percentual de variação
			
			NewTimeActivity = ETimeAP + DeltaTimeActivity; //novo tempo considerando o percentual de variação
			
			UseTimeContingencyReserve = UTCR  + DeltaTimeActivity;
			
		}else{
			if(TimeRem>0){ 
				DeltaTimeActivity = ETimeAP*TimeRem;
				
				NewTimeActivity = ETimeAP - DeltaTimeActivity;
				
				UseTimeContingencyReserve = UTCR - DeltaTimeActivity;
			}
			
		}	
		
		if(CostAdd>0){ //se mudanca diminui o tempo de uma atividade
				DeltaCostActivity = ECostAP*CostAdd;
				
				NewCostActivity = DeltaCostActivity + ECostAP;
				
				UseCostContingencyReserve = UCCR + DeltaCostActivity;

		}else{
				
			if(CostRem>0){
				DeltaCostActivity = ECostAP*CostRem;
				
				NewCostActivity =  ECostA - DeltaCostActivity;
				
				UseCostContingencyReserve = UCCR - DeltaCostActivity;
			}
			
		}
		
	ActualTimeContingencyReserve = ITCR - DeltaTimeActivity; // Atualizando o valor da Reserva de Tempo (esses valores nao sao de fato descontados do projeto)
	ActualCostContingencyReserve = ICCR - DeltaCostActivity;
	
	.print("Activity ", Label, " Cost variation= ", DeltaCostActivity, " New Cost= ", NewCostActivity);
	.print("Activity ", Label, " Time variation= ", DeltaTimeActivity, " New Time= ", NewTimeActivity);
	.print("Amount of cost reserve after change= ", ActualCostContingencyReserve);
	.print("Amount of time reserve after change= ", ActualTimeContingencyReserve);
	
	.print("Dear manager, if you apply this change to the project, the following riks will be affected:");
	
	PUCR = UseCostContingencyReserve/ICCR;
	PUTR = UseTimeContingencyReserve/ITCR;
	-+pucr(PUCR);
	-+putr(PUTR);

	cartago.invoke_obj(P, getRisks, RiskList);
	if (RiskList \== null){
		cartago.invoke_obj(RiskList, size, Size);
		
		// PUTR E PUCR Porcentagem de uso das reservas de tempo e custo.
		
		.print("Percentage of Use of Cost Reserve!", PUCR);
		.print("Percentage of Use of Time Reserve!", PUTR);
	
		for(.range(I, 0, Size-1)){
			
			cartago.invoke_obj(RiskList, get(I), Risk);
			cartago.invoke_obj(Risk, getId, RiskId);
			cartago.invoke_obj(Risk, getCostP, CostP);
			cartago.invoke_obj(Risk, getCostI, CostI);
			cartago.invoke_obj(Risk, getTimeP, TimeP);
			cartago.invoke_obj(Risk, getTimeI, TimeI);
			
			if((CostAdd\==0 | CostRem\==0) & CostP \== 0 & CostI \== 0){
				setNewCostP(PUCR*(1-CostP) + CostP);
				getNewCostP(NewCostP);
				
				.print("Risk ",RiskId,", initial PC = ", CostP,", PC after change =", NewCostP);
				
				cartago.invoke_obj(Risk, setCostP(NewCostP));
				setNewCostP(0.0);
				
			}
			if((TimeAdd\== 0 | TimeRem\==0) & TimeP \== 0 & TimeI \==0){
				setNewTimeP(PUTR*(1-TimeP) + TimeP);
				getNewTimeP(NewTimeP);
				
				.print("Risk ",RiskId,", initial PT = ", TimeP,", PT after change =", NewTimeP);
				
				cartago.invoke_obj(Risk, setTimeP(NewTimeP));
				setNewTimeP(0.0);
			}
		}
		
		.print("Percentege of cost reserve that will be used= ", PUCR);
		.print("Percentege of time reserve that will be used=", PUTR);
		
	}else{
		.print("No risks affected.");
	};
	
	-+actualTimeContingencyReserve(ActualTimeContingencyReserve); //quantidade de reserva de tempo disponivel no projeto
	-+actualCostContingencyReserve(ActualCostContingencyReserve); //quantidade de reserva de custo disponivel no projeto
	-+useTimeContingencyReserve(0); //percentual de uso da reserva de tempo que esta mudanca utiliza
	-+useCostContingencyReserve(0); //percentual de uso da reserva de custo que esta mudanca utiliza
	-+initialCostContingencyReserve(ActualCostContingencyReserve);
	-+initialTimeContingencyReserve(ActualTimeContingencyReserve).

+!monitoringRisks : instant(K) & project(P) & calculatingMetric(CM) <- 
	
	if(CM \== 0){ //soh monitora se não estiver calculando metricas, ou seja, quando CM=1
		cartago.invoke_obj(P, getRisks, RiskList);
	
		.println("Instant ", K, "- Project's risks:");
	
		if (RiskList \== null){
			cartago.invoke_obj(RiskList, size, Size);
			//.print("Tamanho da RL que chegou pro aris", Size);
			
			for(.range(I, 0, Size-1)){
				cartago.invoke_obj(RiskList, get(I), Risk);
				cartago.invoke_obj(Risk, getId, Id);
				cartago.invoke_obj(Risk, getName, Name);
				cartago.invoke_obj(Risk, getCostP, CP);
				cartago.invoke_obj(Risk, getCostI, CI);
				cartago.invoke_obj(Risk, getTimeP, TP);
				cartago.invoke_obj(Risk, getTimeI, TI);
				cartago.invoke_obj(Risk, getScopeP, SP);
				cartago.invoke_obj(Risk, getScopeI, SI);
				TotalRiskExposure = (CP*CI)+(TP*TI)+(SP*SI);
				cartago.invoke_obj(Risk, setTotalRiskExposure(TotalRiskExposure));
				
				iActions.internalStateARis(Id); //Adiciona risco na lista. Isso é feito iterativamente pois as propriedades dos riscos sofrem alterações no decorrer do tempo.
			};
			
			iActions.internalStateARis(exit, InternalState); //Apos adicionar todos os riscos o agente ordena a lista de riscos pela ER.	
			-+project(P);
		}
	}.
	
+tick : instant(K) <-
	!monitoringRisks;
	calculateInstantCounter(K);
	getInstantCounter(InstantCounter);
    if(InstantCounter \== -1){
		//.print("multiplo de 4-->", InstantCounter);
		!calculateProjectMetrics;
	}.
	
	
+project(P) <- 
	cartago.invoke_obj(P, getId, IdProject);
	setProject(P); //setando a propriedade observavel novamente (atualizando)
	.print("Observing Project", IdProject).
	
+!updateEnvironment(accepted) : instant(K) & project(P) & initialTimeContingencyReserve(ITCR) & initialCostContingencyReserve(ICCR) & actualTimeContingencyReserve (ATCR) & actualCostContingencyReserve(ACCR) 
& costCRCounter(CcrC) & timeCRCounter(TcrC) & scopeCRCounter(ScrC) & pucr(PUCR) & putr(PUTR) & costCRCounter(A) & timeCRCounter(B) <- 

	-+costReserveAfterLastAcceptedChange(ATCR); // valor da reserva de custo ao final da ultima mudança aceita
	-+timeReserseAfterLastAcceptedChange(ACCR); // valor da reserva de tempo ao final da ultima mudanca aceita
	-+calculatingMetric(0);
	
	setPucr(PUCR);
	setPutr(PUTR);
	
	.print("ENVIRONMENT SUCCESSFULLY UPDATED!");
	
	if(K==64){
			TEMP = 1 + CcrC + TcrC + ScrC;
	}else{
			TEMP = 2 + CcrC + TcrC + ScrC;
		
	}
	
	
	if(PUCR \== 0){
		.println("-------------CALCULATING METRICS OF THE PROJECT ENVIRONMENT--------------");
		
		cartago.invoke_obj(P, getProjectTeam, ProjectTeam);
		cartago.invoke_obj(ProjectTeam, size, Size);
		
		.println("-------METRIC 1: Percentage of Cost Changes-------");
		
		if(PUCR > 0){
			setCostCRCounter(CcrC+1);
			getCostCRCounter(Aux_A);

			-+costCRCounter(Aux_A); //costChangeRequestCounter
			.print("Percentage of Cost Changes = ", Aux_A/TEMP);
		}else{
			getCostCRCounter(Aux_A);
			.print("Percentage of Cost Changes = ", Aux_A/TEMP);
		}
			
		.println("-------METRIC 2: Percentage of Cost Reserve-------");
		POCR = ACCR/ICCR;
		.print("Percentage of Cost Reserve = ", POCR);
			
		if(POCR > 0.60 & POCR < 1.00){
			 .print("Manager, the Project's Cost Reserve is low! Percentage of Cost Reserve = ", POCR);
			 	
		}
		if(POCR < 0.61){
				.println("Manager, I have detected a new risk in this project due to the percentage of cost reserve!");
				.println("Advice: You should talk to the project sponsor about the project budget.");
				.concat("Insufficient Cost Reserve to apply changes/handle threats in the project", Msg1);
				calculateMetrics(Msg1, POCR, 2,X1);
				P = X1;
		}
			
		.println("-------METRIC 3: Percentage of Time Changes-------");
		if(PUTR > 0){
			setTimeCRCounter(TcrC+1);
			getTimeCRCounter(Aux_B);
			
			-+timeCRCounter(Aux_B); //timeChangeRequestCounter
			.print("Percentage of Time Changes = ", Aux_B/TEMP);
		}else{
			getTimeCRCounter(Aux_B);
			.print("Percentage of Time Changes = ", Aux_B/TEMP);	
		}
		
		.println("-------METRIC 4: Percentage of Time Reserve-------");
		POTR = ATCR/ITCR;
		.print("Percentage of Time Reserve = ", POTR);
			
		if(POTR > 0.30 & POTR < 0.60){
			.print("Manager, the Project's Time Reserve is low! Percentage of Time Reserve = ", POTR);
		 	
		 	if(POTR < 0.31){
		 		.println("Manager, I have detected a new risk in this project due to the percentage of time reserve!");
				.println("Advice: You should check the team members' and activities schedule.");
				.concat("Insufficient Time Reserve to apply changes/handle threats in the project", Msg2);
				calculateMetrics(Msg2, POTR, 3,X2);
				P = X2;
			}
		}
		
		.println("-------METRIC 5: Percentage of Scope Changes-------");
		if(PUCR > 0){
			setScopeCRCounter(ScrC+1);
			getScopeCRCounter(Aux_C);
			
			-+scopeCRCounter(Aux_C); //timeChangeRequestCounter
			.print("Percentage of Time Changes = ", Aux_C/TEMP);
		}else{
			getScopeCRCounter(Aux_C);
			.print("Percentage of Time Changes = ", Aux_C/TEMP);	
		}
		
	}
	-+totalChangeRequests(TEMP);	
	-+project(P);
	-+calculatingMetric(1).
	
	
+!updateEnvironment(rejectecd) : instant(K) & project(P) & initialTimeContingencyReserve(ITCR) & initialCostContingencyReserve(ICCR) 
& actualTimeContingencyReserve (ATCR) & actualCostContingencyReserve(ACCR) & costReserveAfterLastAcceptedChange(CALAC)
& timeReserseAfterLastAcceptedChange(TALAC)  <-
	
	-+initialTimeContingencyReserve(CALAC);
	-+initialCostContingencyReserve(TALAC);
	-+actualTimeContingencyReserve(0);
	-+actualCostContingencyReserve(0);
	
	.print("SIMULATION DISCARDED!").
	
+!calculateProjectMetrics: instant(K) & project(P) & qualifiedWorkersTemp(QwT) <-
	-+calculatingMetric(0);
		.println("-------METRIC 6: Percentage of Qualified Workers-------");
		cartago.invoke_obj(P, getProjectTeam, ProjectTeam);
		cartago.invoke_obj(ProjectTeam, size, Size);
		
		if (ProjectTeam \== null){ 
			
			if(Size>0){
				.print("Total number of workers = ",Size);
				cartago.invoke_obj(QwT, clear);
				
				for(.range(I, 0, Size-1)){
					cartago.invoke_obj(ProjectTeam, get(I), Employee);
					cartago.invoke_obj(Employee, isQualified, Qualified);
					
					if(Qualified == true){
					  cartago.invoke_obj(QwT, add(Employee));
					}
					
				}
				
				if(QwT \== null){
					cartago.invoke_obj(QwT, size, SizeQwT);
					.print("Number of qualified workers = ", SizeQwT);	
					
					if(SizeQwT>0){
						Div = SizeQwT/Size;
						.print("Percentage of qualified workers = ", Div);
						
						if(Div > 0.30 & Div < 0.60 ){ 
							.println("Manager, I have detected a new risk in this project due to the percentage of qualified workers!");
							.println("Advice: You should hire more qualified workers or provide training to your team members.");
							.concat("Not enough qualified Team members on the project", Msg3);
							calculateMetrics(Msg3, Div, 5,X3);
							P = X3;
							//setProject(X3);
							//-+project(X3);
						}else{
							
							if(Div < 0.31){
								//RISCO ACONTECEU!----PROBABILIDADE=100 E ALTERAR AS RESERVAS DE CONTINGENCIA DO PROJETO
								.print("Manager, I have detected the risk X has happened.");
							}
						}
							
					}
					cartago.invoke_obj(QwT, clear);
					 -+qualifiedWorkersTemp(QwT);
				}
				
			}
			.println("-------------------------------------------------------------------------");
			
		}
	
	-+project(P);
	-+calculatingMetric(1).

	