<cfoutput>

	<div class="wrapper">
	
		<div class="forms">
	
			#startFormTag(controller="Users",action="smsAuth")#
			#hiddenFieldTag(name="login",value=myuser.login)#
			<ol>
				<li>
					#textFieldTag(
						name="token",
						label="Token",
						labelPlacement="before",
						class="input")#
				</li>
				<li>
					#submitTag(value="Zaloguj",class="formButton")#
				</li>
			</ol>
			#endFormTag()#
	
		</div>
	
	</div>

</cfoutput>