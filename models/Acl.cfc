<!---
create view acls as 
  select 
    ug.userid,
    g.id as groupid,
    r.id as ruleid,
    g.groupname, 
    ug.access as groupaccess, 
    r.controller, 
    r.action, 
    gr.access as ruleaccess 
  from user groups ug 
    inner join groups g on ug.groupid = g.id 
    inner join grouprules gr on gr.groupid = g.id 
    inner join rules r on gr.ruleid = r.id;
    
--->

<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset setPrimaryKey(property="userid,grouped,ruleid")>
	
	</cffunction>

</cfcomponent>