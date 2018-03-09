// Agent aMud in project projectManagement

/* Initial beliefs and rules */

/* Initial goals */
!monitoringEnvProject.
!monitoringEnvChanges.

/* Plans */

+!monitoringEnvProject : true 	<-	
	?myArtifact(ArtifactId). // descobrir artefato.
		
+!monitoringEnvChanges: true <-
	?myEnvironment(CRId).

+?myArtifact(ArtifactId) : true
	<-	lookupArtifact("EnvProject", ArtifactId);
		focus(ArtifactId).		

-?myArtifact(ArtifactId) : true
	<-	
		.wait(100);
		!monitoringEnvProject.		

+?myEnvironment(CRId) : true
	<-	
	lookupArtifact("EnvChanges",  IdCR);
	focus(IdCR).		

-?myEnvironment(CRId) : true
	<-	
		.wait(100);
		!monitoringEnvChanges.		


//Perceptions
+project(P) <- setProject(P).

+tick : instant(K) & activities(A) & requests(R) & actualRequest(AR) <- 
	if (K == 60){	
		// Essa mudança do instante 60 não poderá ser aprovada	
		cartago.invoke_obj(A, get(10), Task);
		cartago.invoke_obj("models.TypeChange", getAddCost, Cost);
		cartago.invoke_obj("models.TypeChange", getAddTime, Time);
		cartago.invoke_obj("models.StateOfChange", getRequested, State);		
		cartago.new_obj("models.Change", [3,"Changes in cost and time", K, Task, State], C);
		cartago.invoke_obj(C, addRequest(Cost, 15));
		cartago.invoke_obj(C, addRequest(Time, 40));
		cartago.invoke_obj(Task, getLabel, Label);
		println("Ordering instantly ", K, " an increase of 15% in cost and 40% in time for the activity ", Label);		
		addChangeRequest(C);
		-+actualRequest(C);
		getRequests(NewList);
		-+requests(NewList);	
	}.