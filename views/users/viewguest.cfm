<cfoutput>
	<div class="wrapper">
		<h3>Profil użytkownika <span>#user.givenname# #user.sn#</span></h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
					
		</div>
	
		<div class="userProfile">
			<div class="leftContent">
				<div id="leftCol">
					<div id="profilePhoto">
						<div class="photoContainer">
							<cfif FileExists(ExpandPath("images/avatars/thumbnail")&"/#user.photo#")>
								#imageTag(source="avatars/thumbnail/#user.photo#",alt="#user.givenname# #user.sn#",title="#user.givenname# #user.sn#")#
							<cfelse>
								#imageTag(source="avatars/monkeyavatar.png",alt="#user.givenname# #user.sn#",title="#user.givenname# #user.sn#")#
							</cfif>
							<div class="photoContainerOptionsCover hide">
								<div class="photoContainerOptions">#linkTo(text="edytuj",controller="Users",action="editPhoto",class="ajaxmodallink",key=params.key)#</div>
							</div>
						</div>
					</div>
					
					<div id="profileAttributes">
						<h5>Użytkownik</h5>
						<ul>
							<cfloop query="user_attribute">
								<li>#attributelabel# <span>#userattributevaluetext#</span></li>
							</cfloop>
							<li>Email #mailTo(user.mail)#</li>
						</ul>
					</div>

				
					<div id="profileInformations">
						<h5>Informacje</h5>
						<ul>
							<li>Data logowania <span>#dateFormat(user.last_login, "dd/mm/yy")#</span></li>
						</ul>
					</div>
					
					<!--- Struktura organizacyjna firmy --->
					<div id="organizationStructure">
						<!--- #includePartial(partial="organizationstructure")# --->
					</div>
					<!--- Struktura organizacyjna firmy --->
									
				</div> <!--- Koniec leftCol --->
			</div> <!--- Koniec leftContent --->
		
			<div class="rightContent">
			
				<cfif flashKeyExists("error")>
			    	<span class="error">#flash("error")#</span>
				</cfif>
				
				<div class="wrapper privatemessages">
					<h5>Prywatne wiadomości</h5>
					
					<table class="newtables" id="privatemessages">
						<thead>
							<tr class="top singlemessageoptions">
								<th colspan="5" class="nopadding">
									
									#linkTo(
										text="<span>Dodaj prywatny komunikat</span>",
										controller="Messages",
										action="addUserMessage",
										key=user.id,
										class="addprivatemessage ajaxlink",
										style="margin-bottom: 10px;",
										title="Dodaj nowy komunikat")#
								
								</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="privatemessages">
								<tr class="#priorityname#">
									<td class="bottomBorder">
										#checkBoxTag(name="messageid",value=messageid,label=false)#
									</td>
									<td class="bottomBorder">
										#linkTo(
											text=messagetitle,
											controller="Messages",
											action="view",
											key=messageid,
											class="ajaxlink",
											title=messagetitle)#
									</td>
									<td class="bottomBorder">
										#linkTo(
											text=Left(messagebody, 64)&"…",
											controller="Messages",
											action="view",
											key=messageid,
											class="ajaxlink",
											title=messagetitle)#
									</td>
									<td class="bottomBorder messageauthor">#givenname# #sn#</td>
									<td class="bottomBorder datetime">
										#DateFormat(messagecreated, "dd/mm")# #TimeFormat(messagecreated, "HH:mm")#
									</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					
				</div>
													
			</div> <!--- Koniec rightContent --->
			
			<div class="clear"></div>
		</div>
	</div>
</cfoutput>