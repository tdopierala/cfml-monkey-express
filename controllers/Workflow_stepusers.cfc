<cfcomponent extends="Controller" output="false" hint="">
	
	<cffunction name="init" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="" >
		<cfset usesLayout(template="/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.bodyImportFiles &= ",workflowStepUsers" />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="" >
		<cfset workflowSteps = model("workflowStep").getWorkflowSteps() />
		<!--- Tworzenie listy z przypisanymi użytkownikami --->
		<cfset workflowStepUsers = structNew() />
		<cfloop query="workflowSteps">
			<cfset workflowStepUsers[workflowstepstatusname] = model("workflow_step_user").getStepUsers(id) />
		</cfloop>
	</cffunction>
	
	<cffunction name="adduser" output="false" access="public" hint="" >
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset newUser = model("workflow_step_user").create(FORM) />
		</cfif>
		
		<cfset workflowSteps = model("workflowStep").getWorkflowSteps() />
		<!--- Tworzenie listy z przypisanymi użytkownikami --->
		<cfset workflowStepUsers = structNew() />
		<cfloop query="workflowSteps">
			<cfset workflowStepUsers[workflowstepstatusname] = model("workflow_step_user").getStepUsers(id) />
		</cfloop>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeUser" output="false" access="public" hint="">
		<cfset myUser = model("workflow_step_user").deleteByKey(params.key) />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="stepUsers" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("params.search") AND IsDefined("params.step")>
			<cfset json = model("workflow_step_user").getStepUsers(stepid = params.step, search = params.search) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
</cfcomponent>