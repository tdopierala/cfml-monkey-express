<cfoutput>
<h4>Nieobecni <span class="substitutionscount">(#substitutions.RecordCount#)</span> <span class="showhidesubstitutions">pokaż/ukryj</span></h4>

<div class="usersubstitutions">

	<table class="newtables">
		<thead>
			<tr class="top">
				<th class="bottomBorder" colspan="5"></th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="substitutions">
				<!--- 
				Tutaj muszę sprawdzać, czy została wybrana osoba na zastępstwo.
				Jeżeli jej nie ma to wypisuje tylko informację o nieobecnym.
				--->
				<cfif Len(substitutionid)>
				
					<tr>
						
						<td class="bottomBorder c"> <!--- Avatar pracownika --->
						
							<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
								#imageTag(source="avatars/thumbnailsmall/#photo#",alt="#usergivenname#",title="#usergivenname#")#
							<cfelse>
								#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#usergivenname#",title="#usergivenname#")#
							</cfif>
							
							#linkTo(
								text="#usergivenname#",
								controller="Users",
								action="view",
								key=userid,
								class="small_text",
								title="Profil użytkownika #usergivenname#")#
						
						</td>
						
						<td class="bottomBorder">
						
							<span class="proposalfromto small_text">od #proposaldatefrom# do #proposaldateto#</span>
						
						</td>
						
						<td class="bottomBorder c">
						
							<span class="small_text">przez</span>
						
						</td>
						
						<td class="bottomBorder c">
						
							<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#substitutephoto#")>
								#imageTag(source="avatars/thumbnailsmall/#substitutephoto#",alt="#substitutename#",title="#substitutename#")#
							<cfelse>
								#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#substitutename#",title="#substitutename#")#
							</cfif>
							
							#linkTo(
								text="#substitutename#",
								controller="Users",
								action="view",
								key=substituteid,
								class="small_text",
								title="Profil użytkownika #substitutename#")#
						
						</td>
						
					</tr>
				
				<cfelse> <!--- Jeśli nie ma wybranej osoby zastępującej to wypisuje tylko nieobecność --->
				
					<tr>
						<td class="bottomBorder c"> <!--- Avatar pracownika --->
						
							<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
									#imageTag(source="avatars/thumbnailsmall/#photo#",alt="#usergivenname#",title="#usergivenname#")#
							<cfelse>
									#imageTag(source="avatars/thumbnailsmall/monkeyavatar.png",alt="#usergivenname#",title="#usergivenname#")#
							</cfif>
							
							#linkTo(
								text="#usergivenname#",
								controller="Users",
								action="view",
								key=userid,
								class="small_text",
								title="Profil użytkownika #usergivenname#")#
						
						</td>
						<td class="bottomBorder l"> 
						
							<span class="proposalfromto">od #proposaldatefrom# do #proposaldateto#</span>
						
						</td>
						<td class="bottomBorder">&nbsp;</td>
						<td class="bottomBorder">&nbsp;</td>
					</tr>
				
				</cfif>
				
			</cfloop>
		</tbody>
	</table>

</div>

</cfoutput>