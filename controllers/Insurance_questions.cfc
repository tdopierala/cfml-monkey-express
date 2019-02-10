<cfcomponent displayname="Insurance_questions" extends="Controller" output="false">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="private" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		<cfset categories = model("insurance_category").getAllCategories() />
		
		<cfif IsDefined("params.categoryid")>
			<cfset questions = model("insurance_question").getCategoryQuestionsTree(params.categoryid) />
		</cfif>
	</cffunction>
	
	<cffunction name="getCategoryQuestions" output="false" access="public" hint="">
		<cfif IsDefined("params.categoryid")>
			<cfset questions = model("insurance_question").getCategoryQuestionsTree(params.categoryid) />
			<cfset usesLayout(false) />
		</cfif>
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>			
			<cfset newQuestion = model("insurance_question").insert(
				categoryid = FORM.CATEGORYID,
				questiontypeid = FORM.QUESTIONTYPEID,
				question = FORM.QUESTION
			) />
			

			
			<cfif IsDefined("FORM.QUESTIONTYPEVALUE") && Len(FORM.QUESTIONTYPEVALUE)>
				<cfloop list="#FORM.QUESTIONTYPEVALUE#" index="i" delimiters=",">
					<cfset newQuestionValue = model("insurance_questiontypevalue").create({
						questionid = newQuestion,
						questiontypevalue = i}) />
				</cfloop> 
			</cfif>
		</cfif>
		
		<cfset categories = model("insurance_category").getAllCategories() />
		<cfset questiontypes = model("insurance_questiontype").getAllTypes() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="move" output="false" access="public" hint="">
		
		<cfset toMove = model("insurance_question").move(
			myId = params.my_root, 
			newId = params.new_parent,
			categoryid = params.categoryid) />
		<cfset questions = model("insurance_question").getCategoryQuestionsTree(params.categoryid) />
		
		<cfset renderPage(controller="Insurance_questions",action="getCategoryQuestions",layout=false) />
		
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "OK",
			MESSAGE = "Usunięto"} />
		
		<cfif IsDefined("params.key")>
			<cfset toRemove = model("insurance_question").delete(params.key, params.categoryid) />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
</cfcomponent>