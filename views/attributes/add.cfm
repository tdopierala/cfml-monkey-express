<cfoutput>

	<div class="wrapper">
	
		<h3>Nowy atrybut</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
				<ol>
					<li>
						#textField(
							objectName="attribute",
							property="attributename",
							label="Nazwa atrybutu",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#selectTag(
							label="Typ atrybutu", 
							name="attribute[attributetypeid]", 
							options=attribute_types,
							prependToLabel="", 
							append="", 
							labelPlacement="before",
							includeBlank="---")#
					</li>
					<li>
						#textField(
							objectName="attribute",
							property="attributelabel",
							label="Etykieta atrybutu",
							labelPlacement="before",
							class="input")#
					</li>
					<li>#submitTag(value="Zapisz",class="formButton")#</li>
				</ol>
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>