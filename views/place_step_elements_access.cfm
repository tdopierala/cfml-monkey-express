<cfoutput>

	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="6" class="admin_submenu_options">
			
			#imageTag(source="stop.png",class="accessdeny")#
			
			<div class="autherrorinfo">
				Nie masz uprawnień do przeglądania tej strony. #linkTo(text="Przejdź do swojego profilu",controller="users",action="view",key=session.userid)#.
				<br/>
				W przypadku pytań prosimy o kontakt z #mailTo(emailAddress="informatyka@monkey.xyz", name="Departamentem Informatyki")#.
			</div>
		</td>
	</tr>

</cfoutput>
	