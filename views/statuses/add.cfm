<cfoutput>

	<div class="wrapper">
	
		<h3>Dodawanie nowego statusu obiegi dokumentów</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
				<ol>
					<li>
						#textField(
							objectName="status",
							property="statusname",
							label="Nazwa statusu",
							labelPlacement="before",
							class="input")#
					</li>
					<li>#submitTag(value="Zapisz",class="formButton")#</li>
				</ol>
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>