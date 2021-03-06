<cfoutput>
	<div class="wrapper">
		<h3>Edytuj użytkownika #user.login#</h3>
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>

		<div class="forms">
			#startFormTag(action="actionEdit", multipart="true")#
			#hiddenField(objectName="user", property="id")#
	
			<ol>
				<li>
					#textField(
						objectName="user", 
						property="login", 
						label="Login użytkownika", 
						class="input",
						labelPlacement="before")#
				</li>
				<li>
					#selectTag(
						label="Departament", 
						name="user[departmentid]", 
						options=departments,
						selected="#user.departmentid#",
						prependToLabel="", 
						append="", 
						labelPlacement="before",
						includeBlank="---")#
				</li>
				<li>#submitTag(value="Zapisz",class="formButton")#</li>
			</ol>
			#endFormTag()#
		</div>
	</div>
</cfoutput>