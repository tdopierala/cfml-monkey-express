<cfcomponent displayname="Insurance_insurances" extends="Controller" output="false">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="private" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<cfset insurances = model("insurance_instance").getUserInstances(session.user.id) />
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="Formularz zgłaszania szkód">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<!---<cfdump var="#FORM#" />
			<cfabort />--->
			
			<!--- Tworzę nowe zgłoszenie --->
			<cfset newInstance = model("insurance_instance").create(
				categoryid = FORM.CATEGORYID,
				userid = session.user.id,
				data_szkody = FORM.DATA_SZKODY,
				data_zgloszenia = FORM.DATA_ZGLOSZENIA) />
				
			<!---
				Utworzenie zgłoszenia automatycznie generuje listę pytań, odpowiadających 
				danej kategorii zgłoszenia. Pytania są puste (bez odpowiedzi).
				Kolejne formularze pozwolą wypełnić odpowiedzi.
			--->
			<cfset redirectTo(controller="Insurance_instances",action="edit",key=newInstance) />
				
		</cfif>
		
		<cfset categories = model("insurance_category").getAllCategories() />
	</cffunction>
	
	<cffunction name="edit" output="false" access="public" hint="">
		<cfif IsDefined("url.key") and not IsDefined("FORM.FIELDNAMES")>
			<cfset myInstance = model("insurance_instance").findByKey(url.key) />
			
			<!--- 
				Jeżeli nie ja dodałem tego zgłoszenia to przenoszę do strony dodawania 
			--->
			<cfif session.user.id NEQ myInstance.userid>
				<cfset redirectTo(controller="Insurance_instances",action="index") />
			</cfif>
			
			<!--- Pobieram listę pytań do kategorii --->
			<cfset questions = model("insurance_instancequestion").getInstanceQuestions(myInstance.id) />
			
			<!--- Na podstawie pobranej listy pytań pobieram możliwe wartości --->
			<cfset questionValues = structNew() />
			<cfloop query="questions">
				<cfset qVal = model("insurance_questiontypevalue").getQuestionValues(questionid) />
				<cfif qVal.RecordCount GT 0>
					<cfset structInsert(questionValues, questionid, qVal) />
				</cfif>
			</cfloop>
			
		<cfelseif IsDefined("FORM.FIELDNAMES")>
			
			<!--- Jeżeli przesłałem formularz to zapisuje odpowiedzi --->
			<cfloop collection="#FORM#" item="i" >
				<cfif isNumeric(i)>
					<cfset updateAnswer = model("insurance_instancequestion").update(i, FORM[i]) />
				</cfif>
			</cfloop>
			
			<cfset redirectTo(controller="Insurance_instances",action="index") />
			
		</cfif>
	</cffunction>
</cfcomponent>