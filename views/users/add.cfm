<cfoutput>
	<div class="wrapper">
		<h3>Nowy użytkownik</h3>
		
		<div class="forms">
			#startFormTag(action="actionAdd", multipart="true")#
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
						#textField(
							objectName="user", 
							property="companyemail", 
							label="Email służbowy", 
							class="input",
							labelPlacement="before")#
					</li>
					<li>
						#selectTag(
							label="Departament", 
							name="user[departmentid]", 
							options=departments,
							prependToLabel="", 
							append="", 
							labelPlacement="before",
							includeBlank="---")#
					</li>
					<li>
						#fileField(
							label="Fotografia", 
							objectName="user", 
							property="photo",
							labelPlacement="before")#
					</li>
					<li>#submitTag(value="Zapisz",class="formButton")#</li>
				</ol>
			#endFormTag()#
		</div>
	</div>
</cfoutput>