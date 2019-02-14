<cfprocessingdirective pageencoding="utf-8" />

<!---<table class="uiTable newUiTable" id="">
	<thead>
		<tr>
			<th class="leftBorder topBorder bottomBorder rightBorder"></th>
			<th class="topBorder rightBorder bottomBorder">Zdjęcie</th>
			<th class="topBorder rightBorder bottomBorder">Nazwa użytkownika</th>
			<th class="topBorder rightBorder bottomBorder">Email</th>
			<th class="topBorder rightBorder bottomBorder">Data utworzenia</th>
			<th class="topBorder rightBorder bottomBorder">Ostatnie logowanie</th>
			<th colspan="4" class="topBorder rightBorder bottomBorder"></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="uzytkownicy">
			<tr>
				<td class="leftBorder rightBorder bottomBorder"><input type="checkbox" name="user-#id#" value="#id#" class="userCheckbox" /></td>
				<td class="bottomBorder rightBorder l">
					<span class="userImageThumbnail">
						<cfif fileExists(expandPath("images/avatars/thumbnailsmall/#photo#"))>
							<cfimage action="writeToBrowser" source="#expandPath("images/avatars/thumbnailsmall/#photo#")#" />
						<cfelse>
							<cfimage action="writeToBrowser" source="#expandPath("images/avatars/thumbnailsmall/monkeyavatar.png")#" /> 
						</cfif>
					</span>
				</td>
				<td class="bottomBorder rightBorder l">
					#givenname# #sn#
					<span class="userLogin">(#login#)</span>
				</td>
				<td class="bottomBorder rightBorder l">#mail#</td>
				<td class="bottomBorder rightBorder r">#DateFormat(created_date, "yyyy/mm/dd")#</td>
				<td class="bottomBorder rightBorder r">#DateFormat(last_login, "yyyy/mm/dd")#</td>
				<td class="bottomBorder">
					<a href="javascript:void(0)" class="icon-remove" title="Usuń (zablokuj) użytkownika"><span>Usuń (zablokuj) użytkownika</span></a> 
				</td>
				<td class="bottomBorder">
					<a href="javascript:void(0)" class="icon-password" title="Zmień hasło"><span>Zmień hasło</span></a>
				</td>
				<td class="bottomBorder">
					<a href="javascript:void(0)" class="icon-key" title="Zarządzaj uprawnieniami"><span>Zarządzaj uprawnieniami</span></a>
				</td>
				<td class="bottomBorder rightBorder">
					<a href="javascript:void(0)" class="icon-reminder" title="Przypomnij hasło"><span>Przypomnij hasło</span></a>
				</td>
			</tr>
			<tr id="strona-#r.STRONA+1#"></tr>
		</cfoutput>
	</tbody>
</table>--->

<cfoutput>
<a href="http://intranet.monkey.xyz/helpdesk/index.cfm?#session.urltoken#">helpdesk</a>
<cfdump var="#session#" />
</cfoutput>