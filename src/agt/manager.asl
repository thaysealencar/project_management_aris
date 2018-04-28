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
	if(Cenario == "Cenario_1"){
		if(K == 20){
			.print("-------------The manager has detected a new Risk!-----------------");
			.print("The Risk is : ", "Unrealistic schedule!");
			.concat("Unrealistic schedule", Name);
			//(1, "Definition of scope", 0, 0, 0, 0, 0.3, 4, 0, RiskArea.SCOPE); 
			createRisk(Name, 0, 0, 0.9, 3, 0.4, 1, 0, 1, X3);
		}
	}
	if(Cenario == "Cenario_3"){
		if (K == 30){
	    	cartago.invoke_obj(A, get(8), TaskI);
	    	cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
			cartago.invoke_obj("models.TypeChange", getAddTime, Time);
			cartago.invoke_obj("models.StateOfChange", getRequested, State);
			
			cartago.new_obj("models.Change", [1,"Changes in cost and time", K, TaskI, State], Ci);		
			cartago.invoke_obj(Ci, addRequest(Cost, 11.9));
			cartago.invoke_obj(Ci, addRequest(Time, 11.8));
			cartago.invoke_obj(TaskI, getLabel, LabelI);
			println("Ordering instantly ", K, " an increase of 11.9% in cost and 11.8% in time for the activity ", LabelI);		
			addChangeRequest(Ci);
			-+actualRequest(Ci);
			getRequests(NewList);
			-+requests(NewList);
		
	    }
	    if(K == 34){
	    	getChangeRequestById(1, ActualRequest);
	    	cartago.invoke_obj(ActualRequest, getChange_id, ChangeId);
	    	cartago.invoke_obj(ActualRequest, getChange_title, ChangeTitle);
	    	ChangeStatus=2;
	    	
	    	iActions.dataPackageManager(ChangeId, ChangeStatus, DataPackage);
	    	-status;
	    	.send(aMud, tell, DataPackage); 
	    	
	    	.print("CHANGE REQUEST APPROVED! : ID-", ChangeId, " , TITLE-", ChangeTitle); 
	    	
	    }
	    
		if (K == 50){		
			// Essa mudança do instante 50 não poderá ser aprovada
			cartago.invoke_obj(A, get(7), TaskH);
			cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
			cartago.invoke_obj("models.TypeChange", getAddTime, Time);
			cartago.invoke_obj("models.StateOfChange", getRequested, State);
					
			cartago.new_obj("models.Change", [2,"Changes in cost and time", K, TaskH, State], Ch);		
			cartago.invoke_obj(Ch, addRequest(Cost, 5.95));
			cartago.invoke_obj(Ch, addRequest(Time, 5.9));
			cartago.invoke_obj(TaskH, getLabel, LabelH);
			println("Ordering instantly ", K, " an increase of 5.9% in cost and of 5.9% in time for the activity ", LabelH);		
			addChangeRequest(Ch);	
			-+actualRequest(Ch);
			getRequests(NewList2);
			-+requests(NewList2);	
		}
		
		if(K == 54){
	    	getChangeRequestById(2, ActualRequest);
	    	cartago.invoke_obj(ActualRequest, getChange_id, ChangeId);
	    	cartago.invoke_obj(ActualRequest, getChange_title, ChangeTitle);
	    	ChangeStatus=3;
	    	
	    	iActions.dataPackageManager(ChangeId, ChangeStatus, DataPackage);
	    	-status;
	    	.send(aMud, tell, DataPackage); 
	    	
	    	.print("CHANGE REQUEST REJECTED! : ID-", ChangeId, " , TITLE-", ChangeTitle); 
	    	
	    }
	    
	    if (K == 60){	
			// Essa mudança do instante 60 não poderá ser aprovada	
			cartago.invoke_obj(A, get(10), Task);
			cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
			//cartago.invoke_obj("models.TypeChange", getAddTime, Time);
			cartago.invoke_obj("models.StateOfChange", getRequested, State);		
			cartago.new_obj("models.Change", [3,"Change in cost", K, Task, State], C);
			cartago.invoke_obj(C, addRequest(Cost, 15));
			//cartago.invoke_obj(C, addRequest(Time, 40));
			cartago.invoke_obj(Task, getLabel, Label);
			println("Ordering instantly ", K, " an increase of 15% in cost and 40% in time for the activity ", Label);		
			addChangeRequest(C);
			-+actualRequest(C);
			getRequests(NewList);
			-+requests(NewList);	
		}
	
	
		if(K == 64){
		    getChangeRequestById(3, ActualRequest);
		    cartago.invoke_obj(ActualRequest, getChange_id, ChangeId);
		    cartago.invoke_obj(ActualRequest, getChange_title, ChangeTitle);
		    ChangeStatus=2;
		    	
		    	iActions.dataPackageManager(ChangeId, ChangeStatus, DataPackage);
		    	-status;
		    	.send(aMud, tell, DataPackage); 
		    	
		    	.print("CHANGE REQUEST APPROVED! : ID-", ChangeId, " , TITLE-", ChangeTitle); 
		    	// VERIFICAR SE PEGOU OS DADOS DA SIMULACAO DO INSTANT 30
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