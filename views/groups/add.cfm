<cfoutput>

	<div class="wrapper">
	
		<h3>Nowa grupa</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
				<ol>
					<li>
						#textField(
							objectName="group",
							property="groupname",
							label="Nazwa grupy",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#textArea(
							objectName="group",
							property="groupdescription",
							label="Opis grupy",
							labelPlacement="before",
							class="textarea")#
					</li>
					<li>#submitTag(value="Zapisz",class="formButton")#</li>
				</ol>
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>