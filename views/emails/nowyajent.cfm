<cfprocessingdirective pageencoding="utf-8" />

<cfoutput>

	<cfmail
		to="#arguments.user.mail#"
		from="Monkey<intranet@monkey.xyz>"
		replyto="intranet@monkey.xyz"
		bcc="intranet@monkey.xyz"
		subject="Nowe konto"
		type="html">

			Witaj #arguments.user.givenname#,<br />

			W systemie Intranet zostało utworzone Twoje konto. Aby się zalogować proszę wejść na stronę http://intranet.monkey.xyz/.<br />

			<br />
			<br />

			<div class="clear"></div>

			<dl class="workflow">

				<dt>Login</dt>
				<dd>#arguments.user.login#</dd>

				<dt>Hasło</dt>
				<dd>#Decrypt(arguments.user.password, get('loc').intranet.securitysalt)#</dd>

			</dl>

			<div class="clear"></div>

			<br /><br />
			W razie pytań o działanie Intranetu prosimy o kontakt pod adresen <a href="mailto:intranet@monkey.xyz">intranet@monkey.xyz</a>.

			<br />

			W razie innych pytań technicznych prosimy o kontakt pod adresem <a href="mailto:pomoc@monkey.xyz">pomoc@monkey.xyz</a>

			<br /><br />

			Pozdrawiamy,<br />
			Monkey Group


	</cfmail>

</cfoutput>
