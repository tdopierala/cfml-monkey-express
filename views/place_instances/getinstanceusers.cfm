<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			
			<h2 class="admin_placeusers">Uczestnicy</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Zdjęcie</th>
						<th>Imię i nazwisko</th>
						<th>Telefon</th>
						<th>Email</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="users">
						<tr>
							<td class="first">&nbsp;</td>
							<td class="c">
								
								<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
									<div class="thumbnailsmall">
										#linkTo(
											text=imageTag(source="avatars/thumbnailsmall/#photo#",alt="#givenname# #sn#",title="#givenname# #sn#"),
											controller="Users",
											action="view",
											key=userid,
											title="#givenname# #sn#")#
									</div>
								<cfelse>
									<div class="thumbnailsmall">
										#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#givenname# #sn#",title="#givenname# #sn#")#
									</div>
								</cfif>
								
							</td>
							<td>#givenname# #sn#<br/>#position#</td>
							<td>#phone#</td>
							<td>
								
								#mailTo(
									emailAddress=mail,
									name=mail)#
								
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</div>
	</div>
	
</cfoutput>