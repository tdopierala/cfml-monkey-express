<cfoutput>

	<div class="wrapper">
	
		<h3>Edycja atrybutu</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionEdit")#
			#hiddenField(objectName="attribute", property="id")#
				<ol>
					<li>
						#textField(
							objectName="attribute",
							property="attributename",
							class="input",
							label="Atrybut",
							labelPlacement="before")#
					</li>
					<li>
						#selectTag(
							label="Typ atrybutu", 
							name="attributetypeid", 
							options=attributetypes,
							selected="#attribute.attributetypeid#",
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