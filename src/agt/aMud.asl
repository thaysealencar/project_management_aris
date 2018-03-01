// Agent aMud in project projectManagement

/* Initial beliefs and rules */

/* Initial goals */
!create.
!monitoring.

/* Plans */

+!monitoring : true 	<-	
		?myArtifact(ArtifactId). // descobrir artefato.
		
+!create: true <-
	?myEnvironment(CRId).

+?myArtifact(ArtifactId) : true
	<-	lookupArtifact("EnvProject", ArtifactId);
		focus(ArtifactId).		

-?myArtifact(ArtifactId) : true
	<-	
		.wait(100);
		!monitoring.		

+?myEnvironment(CRId) : true
	<-	
	makeArtifact("EnvChanges", "workspaces.EnvironmentChangeRequest", [], IdCR);
	focus(IdCR).		

-?myEnvironment(CRId) : true
	<-	
		.wait(100);
		!create.		

+!calculateImpact(Percent, Impact): true <-
	if (Percent > 20){
		Impact = 5;
	} else{
		if (Percent <= 20 & Percent >= 16){
			Impact = 4;
		} else{
			if (Percent >= 11 & Percent <= 15){
				Impact = 3;
			} else {
				if (Percent >= 6 & Percent <= 10){
					Impact = 2;
				}
				else{
					Impact = 1;
				}
			}
		}
	}.	

+!calculateUrgence(U): instant(K) & activity(A) <-
	cartago.invoke_obj(A, isRunning(K), Bool);
	if (Bool == true){
		U = 5;
	} else{
		cartago.invoke_obj(A, getStartInstant, StartK);
		InstantToStart = StartK - K;
		if (InstantToStart < 6){
			U = 4;
		} else{
			if (InstantToStart >= 6 & InstantToStart <= 10){
				U = 3;
			} else{
				if (InstantToStart >= 11 & InstantToStart <= 15){
					U = 2;
				} else{
					U = 1;
				}
			}
		}
	}	
	-+urgence(U).	

+!calculatePriority(P): impactCost(IC) & impactTime(IT) & urgence(U) <-
	P = IC * IT * U;	 
	-+priority(P).
	
+!checkRequests: requests(Rs) <-
	if (Rs \== null){
		cartago.invoke_obj(Rs, size, Size);
		for(.range(I, 0, Size-1)){
			cartago.invoke_obj(Rs, get(I), AR);
			-+change(AR);
			cartago.invoke_obj(AR, getState, State);
			cartago.invoke_obj(AR, getChange_id, Id);
			cartago.invoke_obj(AR, getDescriptionState, DescriptionState);
			cartago.invoke_obj("models.StateOfChange", getRequested, Requested);
			cartago.invoke_obj("models.StateOfChange", getObsolete, Obsolete);
			cartago.invoke_obj("models.TypeChange", getAddCost, AddCost);
			cartago.invoke_obj("models.TypeChange", getAddTime, AddTime);	
			cartago.invoke_obj("models.TypeChange", getRemCost, RemCost);
			cartago.invoke_obj("models.TypeChange", getRemTime, RemTime);
			
			cartago.invoke_obj(AR, getRequestValue(AddCost), DAddCost);
			cartago.invoke_obj(AR, getRequestValue(AddTime), DAddTime);
			cartago.invoke_obj(AR, getRequestValue(RemCost), DRemCost);
			cartago.invoke_obj(AR, getRequestValue(RemTime), DRemTime);
			
			cartago.invoke_obj(AR, getActivity, A);
			-+activity(A);
			
			if (State == Requested){			
					
					if (DAddCost > 0){
						!calculateImpact(DAddCost, ImpactCost);
						if (DAddTime > 0){
							!calculateImpact(DAddTime, ImpactTime);	
						}	else{
							!calculateImpact(DRemTime, ImpactTime);
						}
					} else{
						!calculateImpact(DRemCost, ImpactCost);
						if (DAddTime > 0){
							!calculateImpact(DAddTime, ImpactTime);	
						}	else{
							!calculateImpact(DRemTime, ImpactTime);
						}
					}
					!calculateUrgence(U);
					-+impactCost(ImpactCost);
					-+impactTime(ImpactTime);                 //permitir que na mesma solicitaï¿½ï¿½o possa acontecer as duas mudanï¿½as !!		
					!calculatePriority(P);
					if (ImpactCost == 4){
										!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "Impacto no custo e alto. Procure o Sponsor do projeto para negociar os custos.");
					} else{
								if (ImpactCost == 5){
										!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "Impacto no custo e muito alto. Procure o Sponsor do projeto para negociar os custos.");								
								}
						}
					if (ImpactTime == 4){
								!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "Impacto no tempo e alto. Verifique a possibilidade de paralelizar atividades.");
					} else{
							if (ImpactTime == 5){
									!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State,"Impacto no tempo e muito alto. Verifique a possibilidade de paralelizar atividades.");
							}
					}
					if (U == 4){
						!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "A urgencia da mudanca e alta, em breve se tornara obsoleta.");
					} else {
						if (U == 5){
								!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State,"A urgencia da mudanca e muito alta, em breve se tornara obsoleta.");
						}
					};
					if (P > 27){
							!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "Atencao! Existe solicitacao de mudanca com prioridade alta!");				
					}					
			}
			else{
					if (State == Obsolete){
							!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, "Solicitacao esta obsoleta.");
					}
			}					
		};		//fim for
	}.
		
		
+!recordLog(Id, ValueAC, ValueRC, ValueAT, ValueRT, State, Str): instant(K) & cenario(Cenario) & impactCost(ImpactCost) &impactTime(ImpactTime) 
	& urgence(U) & priority(P)  & activity(A) <-
	cartago.invoke_obj(A, getLabel, Label);
	iActions.recordLogAMud(Id, Cenario, K, Label, ValueAC, ValueRC, ValueAT, ValueRT, State, ImpactCost, ImpactTime, U, P, Str);
	.concat(Str, ". Request for activity: ", Label, Msg);
	+msg(Msg).			

//Perceptions
+project(P) <- 
	cartago.invoke_obj(P, getId, IdProject);
	setProject(P);
	.print("Observing Project ", IdProject).

+tick : instant(K) & activities(A)<-
	setActivities(A, K);
	!checkRequests.
	
+status(S): S == "newRequest"  & actualRequest(AR) & instant(K) <-
	cartago.invoke_obj(AR, getActivity, A);
	cartago.invoke_obj(A, getId, ActivityId);
	-+activity(A);
	cartago.invoke_obj(A, getLabel, Label);
	cartago.invoke_obj(AR, getChange_title, Title);
	cartago.invoke_obj(AR, getChange_id, Id);
	cartago.invoke_obj(AR, getDescriptionState, State);
	cartago.invoke_obj("models.TypeChange", getAddCost, AddCost);
	cartago.invoke_obj("models.TypeChange", getAddTime, AddTime);	
	cartago.invoke_obj("models.TypeChange", getRemCost, RemCost);
	cartago.invoke_obj("models.TypeChange", getRemTime, RemTime);	
	
	cartago.invoke_obj(AR, getRequestValue(AddCost), DAddCost);
	cartago.invoke_obj(AR, getRequestValue(AddTime), DAddTime);
	cartago.invoke_obj(AR, getRequestValue(RemCost), DRemCost);
	cartago.invoke_obj(AR, getRequestValue(RemTime), DRemTime);
	
	
	.concat("I noticed a new request for ", Title, " at the instant ", K, " for the task: ", Label, Str);	
	println(Str);
	iActions.dataPackageAMud(Title, Id, State, AddCost, AddTime, RemCost, RemTime, DAddCost, DAddTime, DRemCost, DRemTime, K, ActivityId, DataPackage);
	
	.wait(1000);
	.send(aRis, tell, DataPackage);
	
	if (DAddCost > 0){
		!calculateImpact(DAddCost, ImpactCost);
		if (DAddTime > 0){
			!calculateImpact(DAddTime, ImpactTime);	
		}	else{
			!calculateImpact(DRemTime, ImpactTime);
		}
	} else{
		!calculateImpact(DRemCost, ImpactCost);
		if (DAddTime > 0){
			!calculateImpact(DAddTime, ImpactTime);	
		}	else{
			!calculateImpact(DRemTime, ImpactTime);
		}
	}
	!calculateUrgence(U);
	-+impactCost(ImpactCost);
	-+impactTime(ImpactTime);   		
	!calculatePriority(P);
	!recordLog(Id, DAddCost, DRemCost, DAddTime, DRemTime, State, Str).
	
	
+msg(S): change(C) & instant(K) <-	
	cartago.invoke_obj(C, getDescriptionState, DescriptionState);
	-+statusSolicitacao(DescriptionState).
	
	
+statusSolicitacao(SS): instant(K) & msg(S) & impactCost(ImpactCost) &impactTime(ImpactTime) & urgence(U) & priority(P) <- 
	println("Instant: ", K,  " Message: ", S);
	println("IC=", ImpactCost, " IT=", ImpactTime, " U=",U, " Priority=",P).	
	
+!kqml_received(Sender, tell, ChangeId, Response): requests(R) & actualRequest(AR) <- 
	
	getChangeRequestById(ChangeId, ChangeRequest);
	cartago.invoke_obj(ChangeRequest, getChange_title, CT);
	.print("Titulo da mudança : ", CT);
	cartago.invoke_obj(ChangeRequest, setState(2))
	getChangeRequestById(1, UpdatedChangeRequest);//pegando a mudanca novamente apos atualizar o status da mesma
	
	clearChangeRequests(NewList);
	addChangeRequest(UpdatedChangeRequest);
	-+actualRequest(UpdatedChangeRequest);
	getRequests(NewList2);
	-+requests(NewList2);
	
	getChangeRequestById(ChangeId, CR);
	cartago.invoke_obj(CR, getState, State);
	.print("State da mudança atual: ", State).
	
/*+urgence(U): statusSolicitacao(SS)& instant(K) & msg(S) & impactCost(ImpactCost) &impactTime(ImpactTime) <-
	println("Instante: ", K,  " Mensagem: ", S);
	P = U * ImpactCost * ImpactTime;
	println("IC=", ImpactCost, " IT=", ImpactTime, " U=",U, " Prioridade=",P).*/