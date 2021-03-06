<cfoutput>
<div class="wrapper">
	<h3>Lista użytkowników</h3>

	<cfif flashKeyExists("success")>
    	<span class="success">#flash("success")#</span>
	</cfif>

	<table id="usersTable" class="tables">
	    <thead>
    	    <tr>
        	    <th>Login użytkownika</th>
				<th>Data utworzenia</th>
				<th class="c">Zdjęcie</th>
				<th>Akcje</th>
        	</tr>
	    </thead>
    	<tbody>
    		<cfset i = 1>
        	<cfloop query="users">
            	<tr <cfif i%2 IS 0> class="odd" <cfelse> class="even"</cfif>>
                	<td>#users.login#</td>
					<td>#DateFormat(users.created_date, "d.mm.yyyy")#</td>
					<td class="c">
						<div class="photoThumb">
							<div class="photoThumbImg">
								<!--- 
								Miniaturka zdjęcia została utworzona przy tworzeniu nowego użytkownika 
								Aby nie był zwrócony błąd, sprawdzam najpierw, czy plik istnieje. Jeśli istnieje to go wyświetlam.
								--->
								<cfif FileExists(ExpandPath("images/avatars/thumbnail")&"/#users.photo#")>
									#imageTag(source="avatars/thumbnail/#users.photo#")#
								</cfif>
							</div>
						</div>
					</td>
        	        <td>
            	        #linkTo(
                	        text="edytuj", 
							action="edit", 
							key=users.id,
	                        title="Edytuj użytkownika #users.login#")#
        	            #linkTo(
							text="atrybuty",
							controller="UserAttributes",
							action="edit",
							key=users.id)#
	                    #linkTo(
    	                    text="usuń", 
							action="delete", 
							key=users.id,
                	        title="Usuń użytkownika #users.login#",
                    	    confirm="Czy na pewno chcesz usunąć użytkownika #users.login#?")#
    	                #linkTo(
							text="zobacz",
							action="view",
							key=users.id,
							title="Zobacz profil użytkownika.")#
						#linkTo(
							text="grupy",
							controller="Users",
							action="manageUserGroups",
							key=users.id,
							title="Zarządzaj grupami użytkownika")#
						#linkTo(
							text="rss",
							controller="Users",
							action="addFeed",
							title="Dostepne kanały RSS")#
 	               </td>
    	        </tr>
			<cfset i++>
        	</cfloop>
	    </tbody>
		<tfoot>
			<tr>
				<td colspan="4">
					<div class="paginator">
						#paginationLinks(prependToPage="<span class='page'>",appendToPage="</span>",linkToCurrentPage=true)#
					</div>
				</td>
			</tr>
		</tfoot>
	</table>
</div>
</cfoutput>
