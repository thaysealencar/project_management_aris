// Agent manager in project projectManagement

/* Initial beliefs and rules */

/* Initial goals */

!create_and_use.
!monitoringEnvChanges.

/* Plans */

+!create_and_use : true
	<-	?artifactSetup(ArtifactId).

+?artifactSetup(Id) : true
	<-	
		makeArtifact("EnvProject", "workspaces.EnvironmentProject", [], Id);
		focus(Id);
		.println("Artifact created!").

-?artifactSetup(Id) : true
	<-	
		.wait(30);
		!create_and_use.
		
+!monitoringEnvChanges: true <-
	?myEnvironment(CRId).

+?myEnvironment(CRId) : true
	<-	
	lookupArtifact("EnvChanges",  IdCR);
	focus(IdCR).		

-?myEnvironment(CRId) : true
	<-	
		.wait(100);
		!monitoringEnvChanges.		
		

+tick : instant(K) & activities(A) & cenario(Cenario) & requests(R) & actualRequest(AR) <- 
	if(Cenario == "Cenario_1" | Cenario == "Cenario_3"){
		if(K == 45){
			.print("-------------The manager has detected a new Risk!-----------------");
			.print("The Risk is : ", "The requirements are out of scope !!!");
			.concat("Unrealistic Scope", Name);
			//(1, "Definition of scope", 0, 0, 0, 0, 0.3, 4, 0, RiskArea.SCOPE); 
			createRisk(Name, 0, 0, 0, 0, 0.3, 4, 0, 1, X3);
		}
	}
	if(Cenario == "Cenario_3"){
		if (K == 30){
	    	cartago.invoke_obj(A, get(8), TaskI);
	    	cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
			cartago.invoke_obj("models.TypeChange", getAddTime, Time);
			cartago.invoke_obj("models.StateOfChange", getRequested, State);
			
			cartago.new_obj("models.Change", [1,"Changes in cost and time", K, TaskI, State], Ci);		
			cartago.invoke_obj(Ci, addRequest(Cost, 11.903));
			cartago.invoke_obj(Ci, addRequest(Time, 11.8));
			cartago.invoke_obj(TaskI, getLabel, LabelI);
			println("Ordering instantly ", K, " an increase of 11.9% in cost and 11.8% in time for the activity ", LabelI);		
			requestChange(Ci);
			-+actualRequest(Ci);
			getRequests(NewList);
			-+requests(NewList);
			//.send(aMud, )
	    }
	    if(K == 34){
	    	getChangeRequestById(0 ,ActualRequest);
	    	cartago.invoke_obj(ActualRequest, getChange_id, ChangeId);
	    	cartago.invoke_obj(ActualRequest, getChange_title, ChangeTitle);
	    	.send(aMud, tell, ChangeId);
	    	//cartago.invoke_obj(AR, getActualRequest())
	    	.print("Change resquest approved: ", ChangeId, " , ", ChangeTitle); // Fazer o aMud colocar o status dessa mudança pra aprovada.
	    	
	    }
		if (K == 50){		
			
			cartago.invoke_obj(A, get(7), TaskH);
			cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
			cartago.invoke_obj("models.TypeChange", getAddTime, Time);
			cartago.invoke_obj("models.StateOfChange", getRequested, State);
					
			cartago.new_obj("models.Change", [2,"Changes in cost and time", K, TaskH, State], Ch);		
			cartago.invoke_obj(Ch, addRequest(Cost, 5.95));
			cartago.invoke_obj(Ch, addRequest(Time, 5.9));
			cartago.invoke_obj(TaskH, getLabel, LabelH);
			println("Ordering instantly ", K, " an increase of 5.9% in cost and of 5.9% in time for the activity ", LabelH);		
			requestChange(Ch);	
			-+actualRequest(Ch);
			cartago.invoke_obj(R, getRequests, newList);
			-+requests(newList);	
		}
	}.
	/*
	
	if (K == 6){                                                                                      //Cenário 2 (SBQS)		
		cartago.invoke_obj(A, get(11), TaskL);
		cartago.invoke_obj(A, get(12), TaskM);
		cartago.invoke_obj(A, get(8), TaskI);
		cartago.invoke_obj(A, get(7), TaskH);
		cartago.invoke_obj(A, get(3), TaskD);
		cartago.invoke_obj("models.TypeChange", getRemCost, Cost);
		cartago.invoke_obj("models.StateOfChange", getRequested, State);
				
		cartago.new_obj("models.Change", [1,"mudanças no custo ", K, TaskL, State], Cl);		
		cartago.invoke_obj(Cl, addRequest(Cost, 2.22));
		cartago.invoke_obj(TaskL, getLabel, LabelL);
		println("Solicitando no instante ", K, " um decréscimo de 2.22% no custo para a atividade ", LabelL);		
		requestChange(Cl);
				
		cartago.new_obj("models.Change", [2,"mudanças no custo ", K, TaskM, State], Cm);		
		cartago.invoke_obj(Cm, addRequest(Cost, 0.889));
		cartago.invoke_obj(TaskM, getLabel, LabelM);
		println("Solicitando no instante ", K, " um decréscimo de 0.889% no custo para a atividade ", LabelM);		
		requestChange(Cm);
		
		cartago.new_obj("models.Change", [3,"mudanças no custo ", K, TaskI, State], Ci);		
		cartago.invoke_obj(Ci, addRequest(Cost, 4.445));
		cartago.invoke_obj(TaskI, getLabel, LabelI);
		println("Solicitando no instante ", K, " um decréscimo de 4.445% no custo para a atividade ", LabelI);		
		requestChange(Ci);
		
		cartago.new_obj("models.Change", [4,"mudanças no custo ", K, TaskH, State], Ch);		
		cartago.invoke_obj(Ch, addRequest(Cost, 2.22));
		cartago.invoke_obj(TaskH, getLabel, LabelH);
		println("Solicitando no instante ", K, " um decréscimo de 2.22% no custo para a atividade ", LabelH);		
		requestChange(Ch);
		
		cartago.new_obj("models.Change", [5,"mudanças no custo ", K, TaskD, State], Cd);		
		cartago.invoke_obj(Cd, addRequest(Cost, 1.481));
		cartago.invoke_obj(TaskD, getLabel, LabelD);
		println("Solicitando no instante ", K, " um decréscimo de 1.481% no custo para a atividade ", LabelD);		
		requestChange(Cd);
	}.*/