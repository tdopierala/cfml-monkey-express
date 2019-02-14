<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj nową kategorię</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
			
				<ol>
					<li>
						#textField(
							objectName="shelfCategory",
							property="shelfcategoryname",
							label="Nazwa kategorii",
							labelPlacement="before",
							class="input")#
					</li>
					<li>
						#submitTag(value="Zapisz",class="button redButton")#
					</li>
				</ol>
			
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>