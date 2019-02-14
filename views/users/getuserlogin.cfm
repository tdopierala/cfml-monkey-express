<cfoutput>
	
	<div class="wrapper">
		
		<h3>Autoryzacja</h3>
		
		<cfif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div class="forms">
			
			#startFormTag(controller="Users",action="actionSendSms")#
				<ol class="horizontal">
					
					<li>
						#textFieldTag(
							name="login",
							label="Twój login",
							class="input",
							labelPlacement="before")#
					</li>
					<li>
						#submitTag(value="Dalej",class="formButton")#
					</li>
					
				</ol>
			#endFormTag()#
			
		</div>
		
	</div>
	
</cfoutput>