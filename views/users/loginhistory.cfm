<cfoutput>
	
<div class="wrapper">
	
	<h3>Ostatnio zalogowani</h3>
		
	<div class="wrapper">
			
		<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
			
	</div>
		
	<div class="wrapper">
		<table id="loginhistory" class="new_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th class="c">Zdjęcie</th>
					<th class="c">Imię i nazwisko</th>
					<th class="c">Email</th>
					<th class="c" filter-type="ddl">Departament lub rola</th>
					<th class="c">Data ostatniego logowania</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1 />
				<cfloop query="myusers">
					<tr <cfif index % 2 eq 0> class="gray"</cfif>>
						<td class="first">&nbsp;</td>
						<td class="c">
							<cfif fileExists(ExpandPath('images/avatars/thumbnailsmall/#photo#'))>
								<cfimage
									action="writeToBrowser" 
									source="#expandPath('images/avatars/thumbnailsmall/#photo#')#" >
							<cfelse>
								<cfimage
									action="writeToBrowser" 
									source="#expandPath('images/avatars/thumbnailsmall/monkeyavatar.png')#" > 	
							</cfif>
						</td>
						<td>
							#givenname# #sn#
						</td>
						<td>
							#mailTo(
								emailAddress=mail)#
						</td>
						<td>
							<cfif Len(departmentname)>
								#departmentname#
							<cfelse>
								#rolahontrahenta#
							</cfif>
						</td>
						<td>
							#dateFormat(last_login, "dd-mm-yyyy")# #timeFormat(last_login, "HH:mm")#
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
	</div> <!--- wrapper przed tabelką --->
		
	
</div> <!--- wrapper całej strony --->
	
</cfoutput>

<script>
$(document).ready(function() {
	$('#loginhistory').tableFilter();
});
</script>