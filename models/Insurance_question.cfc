<cfcomponent displayname="Insurance_question" output="false" extends="Model">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset table("insurance_questions") />
	</cffunction>
	
	<cffunction name="getCategoryQuestions" output="false" access="public" hint="">
		<cfargument name="categoryid" type="numeric" required="true" />
		
		<cfset var listaPytan = ""/>
		<cfquery name="listaPytan" datasource="#get('loc').datasource.intranet#">
			select id, categoryid, question, lft, rgt
			from insurance_questions
			where categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
			order by lft asc;
		</cfquery>
		
		<cfreturn listaPytan /> 
	</cffunction>
	
	<cffunction name="insert" output="false" access="public" hint="">
		<cfargument name="categoryid" type="numeric" required="true" />
		<cfargument name="questiontypeid" type="numeric" required="true" />
		<cfargument name="question" type="string" required="true" />
		
		<cfparam name="maxRgt" default="1" />
		<cfset var newQuestion = "" />
		<cfset var newQuestionResult = "" />
		<cftransaction >
			<cfquery name="newQuestion" result="newQuestionResult" datasource="#get('loc').datasource.intranet#">
				set @max_rgt = 1;
				select IFNULL(max(rgt), 1)
					into @max_rgt
				from insurance_questions where categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />;
				
				update insurance_questions set rgt = rgt + 2 where rgt >= @max_rgt and categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />;
				
				insert into insurance_questions (categoryid, questiontypeid, question, lft, rgt) 
				values (
					<cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.questiontypeid#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.question#" cfsqltype="cf_sql_varchar" />,
					@max_rgt,
					@max_rgt+1);
				
				select LAST_INSERT_ID() as lastId;
			</cfquery>	
		</cftransaction>

		<cfreturn newQuestion.lastId />
	</cffunction>
	
	<cffunction name="getCategoryQuestionsTree" output="false" access="public" hint="">
		<cfargument name="categoryid" type="numeric" hint="" />
		
		<cfset var listaPytan = "" />
		<cfquery name="listaPytan" datasource="#get('loc').datasource.intranet#">
			select
				O2.id as id
				,O2.question
				,O2.lft
				,O2.rgt
				,COUNT(O1.id) AS level
				,IFNULL((select id
					from insurance_questions t2
       				where t2.lft < O2.lft AND t2.rgt > O2.rgt and t2.categoryid = O2.categoryid
       				order by t2.rgt-O2.rgt ASC
       				limit 1), 0) as parentid
			from insurance_questions as O1, insurance_questions as O2
			where O2.lft between O1.lft and O1.rgt and O2.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" /> and O1.categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />
			group by O2.id order by O2.lft;
		</cfquery>
		
		<cfreturn listaPytan />
	</cffunction>
	
	<cffunction name="move" output="false" access="public" hint="">
		<cfargument name="myId" type="numeric" required="true" />
		<cfargument name="newId" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" required="true" />
		
		<cfset var moveQuestion = "" />
		<cfquery name="moveQuestion" datasource="#get('loc').datasource.intranet#">
			set @origin_lft = 0;
			set @origin_rgt = 0;
			set @new_parent_rgt = 0;
			
			select lft, rgt 
				into @origin_lft, @origin_rgt 
			from insurance_questions 
			where id = <cfqueryparam value="#arguments.myId#" cfsqltype="cf_sql_integer" />;
			
			select rgt 
				into @new_parent_rgt
			from insurance_questions 
			where id = <cfqueryparam value="#arguments.newId#" cfsqltype="cf_sql_integer" />; 
			
			UPDATE insurance_questions SET lft = lft +
			CASE
				WHEN @new_parent_rgt < @origin_lft
				THEN CASE
					WHEN lft BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_lft
					WHEN lft BETWEEN @new_parent_rgt AND @origin_lft - 1
					THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END

    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
    				WHEN lft BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_rgt - 1
    				WHEN lft BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
    				THEN @origin_lft - @origin_rgt - 1
    				ELSE 0 END
    			ELSE 0 END,
    		rgt = rgt +
    		CASE
    			WHEN @new_parent_rgt < @origin_lft
    			THEN CASE
    				WHEN rgt BETWEEN @origin_lft AND @origin_rgt
    				THEN @new_parent_rgt - @origin_lft
    				WHEN rgt BETWEEN @new_parent_rgt AND @origin_lft - 1
	    			THEN @origin_rgt - @origin_lft + 1
    				ELSE 0 END
    			WHEN @new_parent_rgt > @origin_rgt
    			THEN CASE
					WHEN rgt BETWEEN @origin_lft AND @origin_rgt
					THEN @new_parent_rgt - @origin_rgt - 1
					WHEN rgt BETWEEN @origin_rgt + 1 AND @new_parent_rgt - 1
					THEN @origin_lft - @origin_rgt - 1
					ELSE 0 END
				ELSE 0 END
			where categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />;
			
		</cfquery>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="delete" output="false" access="public" hint="">
		<cfargument name="node" type="numeric" required="true" />
		<cfargument name="categoryid" type="numeric" required="true" />
		
		<cfset var deleteQuestion = "" />
		<cfquery name="deleteQuestion" datasource="#get('loc').datasource.intranet#">
			set @drop_id = 0;
			set @drop_lft = 0;
			set @drop_rgt = 0;
			
			select id, lft, rgt 
				into @drop_id, @drop_lft, @drop_rgt 
			from insurance_questions
			where id = <cfqueryparam value="#arguments.node#" cfsqltype="cf_sql_integer" />;
			
			delete from insurance_questions 
			where lft between @drop_lft and @drop_rgt 
				and categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />;
			
			UPDATE insurance_questions
			SET lft = CASE
				WHEN lft > @drop_lft
				THEN lft - (@drop_rgt - @drop_lft + 1)
				ELSE lft END,
			rgt = CASE
				WHEN rgt > @drop_lft
				THEN rgt - (@drop_rgt - @drop_lft + 1)
				ELSE rgt END
			WHERE (lft > @drop_lft OR rgt > @drop_lft)
				and categoryid = <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_integer" />;
			 
		</cfquery>
		
		<cfreturn true />
	</cffunction>
</cfcomponent>