<script language="JavaScript">
	$(document).ready(function(){
		$("#ideas-table thead td select, select#elements").change(function(){
			$("#ideas-form").submit();
		});
	});
</script>
<cfoutput>
	
	<div class="wrapper">
		
		<h3>Good Monkey / Lista pomysłów</h3>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
			<cfinvokeargument name="groupname" value="Komisja ds. Pomysłów" />
		</cfinvoke>
		
		<div class="topLink">
			#linkTo(
				text="Dodaj nowy pomysł",
				controller="ideas",
				action="new")#
		</div>
		
		<cfform method="get" id="ideas-form">
			
			<cfinput name="controller" type="hidden" value="#params.controller#" />
			<cfinput name="action" type="hidden" value="#params.action#" />
			
			<cfinput name="sortby" type="hidden" value="#params.sortby#" />
			<cfinput name="sortset" type="hidden" value="#params.sortset#" />
			
			<cfinput name="page" type="hidden" value="1" />
			<!---<cfinput name="elements" type="hidden" value="#params.elements#" />--->
			
			<cfif params.sortset eq 'asc'>
				<cfset sortset = 'desc' />
			<cfelse>
				<cfset sortset = 'asc' />
			</cfif>
			
			<table id="ideas-table" class="tables">
				<thead>
					<tr>
						<th>#linkTo(text="Tytuł", 
								params="user=#params.user#&status=#params.status#&sortby=title&sortset=#sortset#&page=#params.page#")#</th>
						<th>#linkTo(text="Data utworzenia", 
								params="user=#params.user#&status=#params.status#&sortby=date&sortset=#sortset#&page=#params.page#")#</th>
						<th>Autor</th>
						<th>Status</th>
						<cfif priv is true>
							<th>Głosy</th>
						</cfif>
						<th>Akcje</th>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td>
							<cfselect name="user">
								<option value="0">-- wszyscy --</option>
								<cfloop query="user">
									<option value="#user.id#" <cfif params.user eq user.id>selected</cfif>>#user.givenname#&nbsp;#user.sn#</option>
								</cfloop>
							</cfselect>
						</td>
						<td>
							<cfselect name="status">
								<option value="0">-- wszystkie --</option>
								<cfloop query="status">
									<option value="#status.id#" <cfif params.status eq status.id>selected</cfif>>#status.name#</option>
								</cfloop>
							</cfselect>
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
				</thead>
				<tbody>
					<cfloop query="ideas">
						<tr>
							<td title="#ideas.title#">
								<cfif Len(ideas.title) gt 50>
									#Left(ideas.title, 50)#...
								<cfelse>
									#ideas.title#
								</cfif>
							</td>
							<td>#DateFormat(ideas.date, "yyyy-mm-dd")#&nbsp;#TimeFormat(ideas.date, "HH:mm:ss")#</td>
							<td>
								#ideas.user#
								<cfif ideas.store neq ''>
									(#ideas.store#)
								</cfif>
							</td>
							<td>#ideas.name#</td>
							
							<cfif priv is true>
								<td>#ideas.votes#/11</td>							
							</cfif>
							
							<td>
								<cfif priv is true>
									#linkTo(
										controller="ideas", 
										action="view", 
										title="Wydruk w pliku PDF",
										text=imageTag(source="file-pdf.png", width="20", height="20"), 
										key=ideas.id,
										params="view=pdf")#
									&nbsp;
								</cfif>
								#linkTo(
									controller="ideas", 
									action="view",
									title="Podglad",
									text=imageTag(source="view.png", width="20", height="20"),
									key=ideas.id)#
								<!---&nbsp;
								<cfif _access eq 1>
									#linkTo(
										controller="ideas", 
										action="delete", 
										text="usuń", 
										key=ideas.id, 
										confirm="Jesteś pewien, że chcesz usunąć tą pozycje?")#
								</cfif>--->
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		<!--- paginator dla listy pomysłów --->
			<div id="ideas-paginator">
				
				<cfset paginator = 1 />
				<cfset pages_count = Ceiling(ideas_count.c/params.elements) />
				
				<cfif params.page gt 1>
						
					#linkTo(text="<span>&laquo;</span>",
							params="user=#params.user#&status=#params.status#&sortby=#params.sortby#&sortset=#params.sortset#&page=#params.page-1#&elements=#params.elements#")#
				<cfelse>
					<span>&laquo;</span>
				</cfif>
				
				<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >
				
					<cfif paginator eq params.page>
					
						#linkTo(text="<span>#paginator#</span>",
								class="active",
								params="user=#params.user#&status=#params.status#&sortby=#params.sortby#&sortset=#params.sortset#&page=#paginator#&elements=#params.elements#")#
					
					<cfelse>
					
						#linkTo(text="<span>#paginator#</span>",
								params="user=#params.user#&status=#params.status#&sortby=#params.sortby#&sortset=#params.sortset#&page=#paginator#&elements=#params.elements#")#
					
					</cfif>
					
					<cfset paginator++ />
				
				</cfloop>
				
				<cfif params.page lt pages_count>
						
					#linkTo(text="<span>&raquo;</span>",
							params="user=#params.user#&status=#params.status#&sortby=#params.sortby#&sortset=#params.sortset#&page=#params.page+1#&elements=#params.elements#")#
				<cfelse>
					<span>&raquo;</span>
				</cfif>
				
				<!---<span class="elements">
					<label>Ilość wierszy na stronie:</label>
					<select name="elements" id="elements">
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="50">50</option>
					</select>
				</span>--->
				
			</div>
		<!--- koniec: paginator dla listy pomysłów --->
		
		</cfform>
		
	</div>
	
</cfoutput>
<!--- <cfdump var="#ideas#" /> --->