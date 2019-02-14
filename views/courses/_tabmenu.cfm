	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dp" >
		<cfinvokeargument name="groupname" value="Departament Personalny" />
	</cfinvoke>
	
	<ul class="intranet-tab-index">
		
		<cfif dp is true>
			<li class="<cfif params.action eq 'index'>chosen</cfif>">
				<cfoutput>#linkTo(text="Szkolenia", action="index", class="")#</cfoutput>
			</li>
		</cfif>
		
		<cfif dp is true>
			<li class="<cfif params.action eq 'students'>chosen</cfif>">
				<cfoutput>#linkTo(text="Kandydaci", action="students", class="")#</cfoutput>
			</li>
		</cfif>
		
		<cfif dp is true>
			<li class="<cfif params.action eq 'locations'>chosen</cfif>">
				<cfoutput>#linkTo(text="Stan rekrutacji", action="locations", class="")#</cfoutput>
			</li>
		</cfif>
		
		<li class="<cfif params.action eq 'recruitment'>chosen</cfif>">
			<cfoutput>#linkTo(text="Rekrutacja", action="recruitment", class="")#</cfoutput>
		</li>
	</ul>