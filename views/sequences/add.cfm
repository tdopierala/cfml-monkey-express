<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj sekwencje</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
			
				<ol>
					<li>
						#textField(
							objectName="sequence",
							property="sequencename",
							label="Nazwa",
							class="input",
							labelPlacement="before")#
					</li>
					<li>
						#selectTag(
							label="Użytkownik", 
							name="sequence[userid]", 
							options=users,
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