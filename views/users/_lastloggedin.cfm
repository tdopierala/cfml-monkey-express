<cfoutput>
	
	<h4>
		Ostatnio zalogowani
		<span class="all_users">
			#linkTo(
				text="wszyscy",
				controller="Users",
				action="loginHistory")#
		</span>
	</h4>
	<ul>
		<cfloop query="userslastloggedin">
			<li>
				<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
					<div class="thumbnailsmall">
						#linkTo(
							text=imageTag(source="avatars/thumbnailsmall/#photo#",alt="#givenname# #sn#",title="#givenname# #sn#"),
							controller="Users",
							action="view",
							key=id,
							title="#givenname# #sn#")#
						#imageTag(source="avatars/thumbnailsmall/#photo#",alt="#givenname# #sn#",title="#givenname# #sn#")#
					</div>
					<span>#login#</span>
				<cfelse>
					<div class="thumbnailsmall">
						#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#givenname# #sn#",title="#givenname# #sn#")#
					</div>
					<span>#login#</span>
				</cfif>
			</li>
		</cfloop>
	</ul>
	
</cfoutput>