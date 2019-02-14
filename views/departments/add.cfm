<cfoutput >
	<div class="wrapper">
	
		<h3>Nowy departament</h3>
	
		<div class="forms">
			#startFormTag(action="actionAdd", multipart="false")#
			<ol>
				<li>#textField(objectName="department", 
						property="department_name", 
						label="Nazwa departamentu", 
						class="input",
						labelPlacement="before")#</li>
				<li>#submitTag(value="Dodaj",class="formButton")#</li>
			</ol>
			#endFormTag()#
		</div>
	
	</div>
</cfoutput>