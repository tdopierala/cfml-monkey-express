<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj nowe zgłoszenie</h3>

		<div class="forms">
			#startFormTag(action="actionAdd")#
				<ol>
					<li>
						#textField(
							objectName="ticket",
							property="ticketname",
							label="Tytuł zgłoszenia",
							class="input",
							labelPlacement="before")#
					</li>
					<li>
						#textArea(
							objectName="ticket",
							property="ticketdescription",
							label="Opis zgłoszenia",
							class="textarea",
							labelPlacement="before")#
					</li>
					<li>
						#selectTag(
							label="Typ zgłoszenia", 
							name="ticket[tickettypeid]", 
							options=tickettypes,
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