<cfoutput>
	<div class="userStructDetails">
		<ul>
			<cfif fileExists(expandPath("images/avatars/thumbnail/#user.photo#"))>
				<li class="">
					<cfimage
						action="writeToBrowser"
						source="#ExpandPath('images/avatars/thumbnail/#user.photo#')#"
						title="#user.login#">
				</li>
			</cfif>
			<li>
				<label>Imię i nazwisko</label>
				<span>#user.givenname# #user.sn#</span>
			</li>
			<li>
				<label>Adres email</label>
				<span><a href="mailto:#user.mail#">#user.mail#</a></span>
			</li>
			
			<cfloop query="attribute">
				<cfif attribute.userattributevaluetext neq ''>
					<li>
						<cfif params.key neq 38 or attribute.attributeid neq 191>
							<label>#attribute.attributelabel#</label>
							<span>#attribute.userattributevaluetext#</span>
						</cfif>
					</li>
				</cfif>
			</cfloop>
		</ul>
	</div>
	<!--- <cfdump var="#user#"> --->
	<!--- <cfdump var="#attribute#"> --->
</cfoutput>