<cfoutput>

	<div class="wrapper">

		<div class="forms">

			<cfform
				name="user_token_form"
				action="#URLFor(controller='Users',action='token')#" >

				<ol>
					<li>
						<label for="login">Twój login</label>

						<cfinput
							type="text"
							name="login"
							class="input" />
					</li>
					<li>
						<label for="token">Token</label>

						<cfinput
							type="text"
							name="token"
							class="input" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="user_token_submit"
							value="Dalej" />
					</li>
				</ol>

			</cfform>

		</div>

	</div>

</cfoutput>