<cfoutput>

	<div class="wrapper">

		<cfif flashKeyExists("error")>
	    	<span class="error">#flash("error")#</span>
		</cfif>

		<cfif flashKeyExists("message")>
	    	<span class="message">#flash("message")#</span>
		</cfif>

		<div class="forms">

			<cfform
				name="user_sms_form"
				action="#URLFor(controller='Users',action='sms')#" >

				<ol>
					<li>
						<label for="login">Twój login</label>

						<cfinput
							type="text"
							name="login"
							class="input" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="user_sms_submit"
							value="Dalej" />
					</li>
				</ol>

			</cfform>

		</div>

	</div>

</cfoutput>