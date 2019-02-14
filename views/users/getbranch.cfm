<cfoutput>

	<ul class="level#user.level+1#">
		<cfloop query="branch">
		
			<cfif level eq user.level+1>
				
				<li>
					#linkTo(
						text="<span></span>#givenname# #sn#",
						controller="Users",
						action="view",
						key=id,
						title="Profil użytkownika #givenname# #sn#")#
					
					<span class="position">#position#</span>
					
					<cfif size>
					
						#linkTo(
							text="rozwiń/zwiń",
							controller="Users",
							action="getBranch",
							key=id,
							title="Pobierz strukturę organizacyjną dla #givenname# #sn#",
							class="ajaxexpand {id:#id#,lft:#lft#,rgt:#rgt#}")#
					
					</cfif>
					
					<span class="bottom"></span>
					
				</li>
				
			</cfif>
		
		</cfloop>
	</ul>

</cfoutput>