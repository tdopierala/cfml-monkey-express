<cfoutput>

	<div class="wrapper">
	
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
	
		<h3>Nowa reguła</h3>
		
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
				<ol>
					<li>
						#textField(
							objectName="rule",
							property="name",
							class="input",
							label="Nazwa reguły",
							labelPlacement="before")#
					</li>
					<li>
						#textField(
							objectName="rule",
							property="kontroler",
							class="input",
							label="Kontroler",
							labelPlacement="before")#
					</li>
					<li>
						#textField(
							objectName="rule",
							property="action",
							class="input",
							label="Akcja",
							labelPlacement="before"
						)#
					</li>
					<li>
						#submitTag(value="Zapisz",class="formButton")#
					</li>
				</ol>
			#endFormTag()#
		
		</div>
	</div>

</cfoutput>