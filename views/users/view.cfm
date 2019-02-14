<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privPps" >
		<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRoot">
		<cfinvokeargument name="groupname" value="root" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRaportObiegu" >
		<cfinvokeargument name="groupname" value="Raport z obiegu dokumentów" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaIT" >
		<cfinvokeargument name="groupname" value="Departament Informatyki" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaPartnerzy" >
		<cfinvokeargument name="groupname" value="Partnerzy" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRaporty">
		<cfinvokeargument name="groupname" value="Raporty" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRaportPokryciaProduktow">
		<cfinvokeargument name="groupname" value="Raport pokrycia produktów" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRaportSprzedazy">
		<cfinvokeargument name="groupname" value="Sprzedaż na sklepach" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRaportWplat">
		<cfinvokeargument name="groupname" value="Raport wpłat" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaVideo">
		<cfinvokeargument name="groupname" value="Video" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaAkceptacjaWnioskow" >
		<cfinvokeargument name="groupname" value="Akceptacja wniosków" />
	</cfinvoke>
</cfsilent>

<script>
	$(function(){
		
		$(".photoContainer")
			.mouseenter(
				function(){
					$(".photoContainerOptionsCover").removeClass("hide");
				}
			).mouseleave(
				function(){			
					$(".photoContainerOptionsCover").addClass("hide");
				}
			);
		});
</script>

<cfoutput>

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
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="avatar">
						<cfinvokeargument name="groupname" value="Aktualizacja avatara w profilu" />
					</cfinvoke>
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="personalny">
						<cfinvokeargument name="groupname" value="Departament Personalny" />
					</cfinvoke>
					
					<cfif avatar is true>
						
						<cfif personalny is true>
							<cfset userkey = params.key />
						<cfelse>
							<cfset userkey = session.user.id /> 
						</cfif>
						
						<div class="photoContainerOptionsCover hide">
							<div class="photoContainerOptions">
								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Users", action="editPhoto", key=userkey)#', 'user_profile_cfdiv');"
									title="edytuj zdjęcie">edytuj</a>
							</div>
						</div>
					</cfif>
				</div>
			</div> <!--- end #profilePhoto --->
			
			<!---
				02.04.2013
				Ramka z możliwością edyfji swojego profilu.
			--->
			<div class="profile_summary_block" id="edit_profile">
				<ul>
					<li>
						#linkTo(
						text="#user.givenname# #user.sn#",
						controller="Users",
						action="view",
						key=user.id,
						title="Zobacz profil #user.givenname# #user.sn#",
						class="b")#
						
						<span class="userLogOut">
							#linkTo(
								text="wyloguj",
								controller="Users",
								action="logOut",
								title="Wyloguj")#
						</span>
					</li>
					
					<li>
					
						<cfif structKeyExists(url, "edit") and url.edit is true>
						
							#linkTo(
								text="Zakończ edycje",
								controller="Users",
								action="view",
								key=user.id,
								params="edit=false",
								title="Edytuj profil")#
						
						<cfelse>
						
							#linkTo(
								text="Edytuj profil",
								controller="Users",
								action="view",
								key=user.id,
								params="edit=true",
								title="Edytuj profil")#
						
						</cfif>
					
					</li>
					
					<cfinvoke
						component="controllers.Tree_groupusers"
						method="checkUserTreeGroup"
						returnvariable="priv" >
						
						<cfinvokeargument
							name="groupname"
							value="Centrala" />
					
					</cfinvoke>
					
					<cfif priv is true>
					
						<li>
							<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="UserAttributes",action="updateUserAttributeValues")#', 'user_profile_cfdiv');"
								title="Edytuj wizytówkę">Edytuj wizytówkę</a>
						</li>
					
					</cfif>
					
					<cfif privPps is true>
					
						<li>
							<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Store_stores",action="edit")#', 'user_profile_cfdiv');"
								title="Edytuj dane">Edytuj dane</a>
						</li>
					
					</cfif>
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="root" />
					</cfinvoke>
					
					<cfif priv is true>
					
						<li>
							#linkTo(
								text="Panel administracyjny",
								controller="Admins",
								action="index",
								title="Panel administracyjny")#
						</li>
					
					</cfif>
				
				</ul>
			
			</div>
			<!---
				Koniec ramki z możliwością edycji swojego profilu.
			--->
			
			<!--- Ramka widoczna tylko dla PPS, zawierająca hasła do kanału audio --->
			<cfif privPps is true >
				<div class="profile_summary_block" id="audio_chanel">
					<h4>Kanał audio</h4>
					<ul>
						<li>Login: #kanal_audio.login#</li>
						<li>Login mobilny: #kanal_audio.loginMobilny#</li>
						<li>Hasło: #kanal_audio.haslo#</li>
					</ul>
				</div>
			</cfif>
			<!--- Koniec ramki dla PPS z hasłami audio --->
			
			<!---
				2.04.2013
				Ramka z podsumowaniem elementów należących do użytkownika.
				Podsumowanie zawiera liczbę aktualności, komunikatów, faktur
				przypisanych do usera.
			--->
			<div class="profile_summary_block" id="profile_summarize">
				<h4>Alerty</h4>
				<ul>
				
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Centrala" />
					</cfinvoke>
					
					<cfif priv is true>
					
						<li>
						
							<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#', 'intranet_left_content');"
								class="user_assigned_workflow"
								title="Faktury przypisane do użytkownika">
								
									<span>Faktury</span>
							</a>
							
							<span class="summarize_count <cfif stat_workflows.c gt 0> red_alert</cfif>">
								#stat_workflows.c#
							</span>
						</li>
						
						<li>
						
							<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Users",action="getUserWorkflow",key=session.user.id)#', 'user_profile_cfdiv');"
								class="user_archived_workflow"
								title="Archiwalne faktury">
							
									<span>Archiwalne faktury</span>
							</a>
						
						</li>
					
					</cfif>
					
					<!---<li>
						#linkTo(
							text="<span>Komunikaty</span>",
							controller="Messages",
							action="index",
							title="Komunikaty wysłane do użytkownika",
							class="user_assigned_messages")#
							
						<span class="summarize_count">6</span>
					</li>--->
					
					<cfinvoke
						component="controllers.Tree_groupusers"
						method="checkUserTreeGroup"
						returnvariable="priv" >
						
						<cfinvokeargument
							name="groupname"
							value="Centrala" />
					
					</cfinvoke>
					
					<cfif priv is true>
					
						<li>
						
							<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Posts",action="index")#', 'user_profile_cfdiv');"
								class="user_assigned_posts"
								title="Aktualności">
								
									<span>Aktualności</span>
							</a>
							
							<span class="summarize_count <cfif stat_posts.c gt 0> red_alert</cfif>">
								#stat_posts.c#
							</span>
						</li>
					
					</cfif>
					
					<!---<li>
						#linkTo(
							text="<span>Materiały szkoleniowe</span>",
							controller="Material_materials",
							action="index",
							title="Materiały edukacyjne",
							class="user_assigned_materials")#

						<span class="summarize_count">0</span>
					</li>--->

					<cfinvoke
						component="controllers.Tree_groupusers"
						method="checkUserTreeGroup"
						returnvariable="priv" >

						<cfinvokeargument
							name="groupname"
							value="Nieruchomości" />

					</cfinvoke>

					<cfif priv is true>

						<li>
							#linkTo(
								text="<span>Nieruchomości</span>",
								controller="Place_instances",
								action="index",
								title="Nieruchomości",
								class="user_assigned_estates")#

							<span class="summarize_count <cfif stat_places.c gt 0> red_alert</cfif>">
								#stat_places.c#
							</span>
						</li>

					</cfif>

					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Centrala" />
					</cfinvoke>

					<cfif priv is true>

						<li>
							<a href="javascript:ColdFusion.navigate('#URLFor(controller="Proposals",action="index")#', 'user_profile_cfdiv');"
								class="user_assigned_proposals"
								title="Moje wnioski">

								<span>Moje wnioski</span>

							</a>

							<span class="summarize_count <cfif stat_proposals.c gt 0> red_alert</cfif>">
								#stat_proposals.c#
							</span>
						</li>

					</cfif>

					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Dyrektorzy" />
					</cfinvoke>
					

					<cfif (priv is true) or (uprawnieniaAkceptacjaWnioskow is true)>

						<li>
							<a href="javascript:ColdFusion.navigate('#URLFor(controller="Proposals",action="user-proposals")#', 'user_profile_cfdiv', initDatePicker);"
								class="user_proposals_to_accept"
								title="Wnioski do akceptacji">

								<span>Wnioski do akceptacji</span>

							</a>

							<span class="summarize_count <cfif stat_proposals_to_accept.c gt 0> red_alert</cfif>">
								#stat_proposals_to_accept.c#
							</span>
						</li>

					</cfif>

					<li>
						<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Instructions",action="index")#', 'user_profile_cfdiv');"
								class="user_assigned_instructions"
								title="Wewnętrzne akty prawne">

								<span>Akty prawne</span>

						</a>

						<span class="summarize_count <cfif stat_instructions.c gt 0> red_alert</cfif>">
							#stat_instructions.c#
						</span>
					</li>

					<!---<li>
						#linkTo(
							text="<span>Pomysły</span>",
							controller="Ideas",
							action="index",
							title="Pomysły",
							class="user_assigned_ideas")#

						<span class="summarize_count">15</span>
					</li>--->

					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Rejestr korespondencji" />
					</cfinvoke>

					<cfif priv is true>
						<li>
							<!---<a
							href="javascript:ColdFusion.navigate('#URLFor(controller="Correspondences",action="index")#', 'user_profile_cfdiv');"
								class="user_assigned_correspondences"
								title="Korespondencja">

								<span>Korespondencja</span>

							</a>--->

							#linkTo(
								text="<span>Korespondencja</span>",
								controller="Correspondences",
								action="index",
								title="Korespondencja",
								class="user_assigned_correspondences")#

							<span class="summarize_count <cfif stat_correspondences.c gt 0> red_alert</cfif>">
								#stat_correspondences.c#
							</span>
						</li>

					</cfif>

					<cfif privPps is true>

						<li>
							<cfif IsDefined("stat_ssg") and not isBoolean(stat_ssg)>

							<a href="javascript:ColdFusion.navigate('#URLFor(controller="Ssg",action="store")#', 'user_profile_cfdiv');"
								class="user_assigned_ssg"
								title="Arkusz oceny sklepu">
									<span>Arkusz oceny sklepu</span>
							</a>

							<span class="summarize_count <cfif stat_ssg.c gt 0> red_alert</cfif>">
								#stat_ssg.c#
							</span>

							</cfif>
						</li>

					</cfif>
					
					<cfinvoke
						component="controllers.Tree_groupusers"
						method="checkUserTreeGroup"
						returnvariable="priv" >

						<cfinvokeargument
							name="groupname"
							value="Materiały szkoleniowe" />

					</cfinvoke>

					<cfif priv is true>

						<li>

							<a href="javascript:ColdFusion.navigate('#URLFor(controller="Material_materials",action="index")#', 'user_profile_cfdiv');"
								class="user_assigned_materials"
								title="Materiały szkoleniowe">
									<span>Materiały szkoleniowe</span>
							</a>

							<!---<span class="summarize_count <cfif stat_ssg.c gt 0> red_alert</cfif>">
								#stat_ssg.c#
							</span>--->

						</li>

					</cfif>
					
					<cfinvoke
						component="controllers.Tree_groupusers"
						method="checkUserTreeGroup"
						returnvariable="teczkiDokumentow" >

						<cfinvokeargument
							name="groupname"
							value="Teczki dokumentów" />

					</cfinvoke>
					
					<cfif teczkiDokumentow is true>
						
						<li>
							
							<a href="javascript:ColdFusion.navigate('#URLFor(controller="Folder_folders",action="index")#', 'user_profile_cfdiv');"
								class="user_folder_report"
								title="Teczki dokumentów">
									<span>Teczki dokumentów</span>
							</a>

							
							<span class="summarize_count <cfif stat_folder.c + stat_document.c gt 0> red_alert</cfif>">
								#stat_folder.c+stat_document.c#
							</span>
							
							
						</li>
						
					</cfif>
					
					<cfif uprawnieniaPartnerzy is true>
						<li>
							<a href="index.cfm?controller=user_users&action=external&module=questionnaires" title="Ankiety w Intranecie" class="management icon-question" target="_blank"><span>Ankiety</span></a>
							
							<span class="summarize_count <cfif stat_questionnaires.c gt 0> red_alert</cfif>">
								#stat_questionnaires.c#
							</span>
						</li>
					</cfif>
					
					<cfif uprawnieniaVideo is true>
						<li>
							<a href="http://intranet.monkey.xyz/video" title="Materiały szkoleniowe video" class="management icon-video" target="_blank"><span>Video</span></a>
							
							<span class="summarize_count <cfif stat_video.c gt 0> red_alert</cfif>">
								#stat_video.c#
							</span>
						</li>
					</cfif>
					
					<li>
						<a href="http://helpdesk.monkey.xyz" title="Baza zgłoszeń Helpdesk" class="management icon-helpdesk" target="blank"><span>Baza zgłoszeń Helpdesk</span></a>
					</li>

				</ul>
			</div>
			<!--- Koniec ramki z podsumowaniami. --->
			
			<!--- Ramka z raportami --->
			<div class="profile_summary_block" id="profile_summarize">
				<h4>Raporty</h4>
				<ul>
					<cfif uprawnieniaRaportSprzedazy is true>
						<li>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_sale_reports&action=index', 'user_profile_cfdiv')" title="Raport sprzedaży na sklepach" class="report-sales">
								<span>Sprzedaż na sklepach</span>
							</a>
						</li>
					</cfif>
					
					<cfif uprawnieniaRaportWplat is true>
						<li>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_contribution_reports&action=index', 'user_profile_cfdiv')" title="Raport wpłat" class="report-contribution">
								<span>Raport wpłat</span>
							</a>
						</li>
					</cfif>

					<cfif uprawnieniaRaportObiegu is true>
						<li>
							<a href="javascript:ColdFusion.navigate('#URLFor(controller="InvoiceReports",action="index")#', 'user_profile_cfdiv', initDatePicker);" class="user_invoice_report" title="Raport z obiegu dokumentów">
								<span>Obieg dokumentów</span>
							</a>
						</li>
					</cfif>
					
					<cfif uprawnieniaRaporty is true AND uprawnieniaRaportPokryciaProduktow is true>
						<li>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=raport-pokrycia-produktow', 'user_profile_cfdiv')" class="report-product-cover" title="Raport pokrycia produktów">
								<span>Pokrycie produktów</span>
							</a>
						</li>
					</cfif>
				</ul>
			</div>
			<!--- Koniec ramki z raportami --->
			
			<cfif uprawnieniaRoot is true or uprawnieniaIT is true>
				
				<!--- Ramka z zarządzaniem --->
				<div class="profile_summary_block" id="profile_summarize">
					<h4>Zarządzanie</h4>
					<ul>
						<li><a href="index.cfm?controller=user_users&action=management&module=users" class="management icon-users-edit" title="Konta użytkowników"><span>Konta użytkowników</span></a></li>
						<li><a href="index.cfm?controller=user_users&action=management&module=stores" class="management icon-stores-edit" title="Sklepy"><span>Sklepy</span></a></li>
					</ul>
				</div>
				<!--- Koniec ramki z zarządzaniem --->
			
			</cfif>

			<!--- 2.04.2013 Ramka z Redmine --->
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="Nieruchomości" />
			</cfinvoke>

			<cfif priv is true>

			<div class="profile_summary_block" id="profile_redmine">
				<h4>Redmine</h4>
				<ul>
				</ul>
			</div>

			</cfif>
			<!---
				Koniec ramki z Redmine
			--->

			<!---
				2.04.2013
				Ramka z avatarami ostatnio zalogowanych użytkowników
			--->
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="Centrala" />
			</cfinvoke>

			<cfif priv is true>

			<div class="profile_summary_block" id="profile_last_logged_in">
				<h4>Ostatnio zalogowani</h4>
				<ul>
					<cfloop query="last_logged_in">
						<li>
							<cfif fileExists(expandPath("images/avatars/thumbnailsmall/#photo#"))>

								<div class="last_logged_in_thumbnail">
									<a href="#URLFor(controller="Users", action="view", key=id)#">
									<cfimage
										action="writeToBrowser"
										source="#ExpandPath('images/avatars/thumbnailsmall/#photo#')#"
										title="#givenname# #sn#">
									</a>
								</div>

								<span class="last_logged_in_login">#login#</span>

							<cfelse>

								<div class="last_logged_in_thumbnail">
									
									<cfimage
										action="writeToBrowser"
										source="#ExpandPath('images/avatars/thumbnailsmall/monkeyavatar.png')#"
										title="#givenname# #sn#">
									
								</div>

								<span class="last_logged_in_login">#login#</span>

							</cfif>
						</li>
					</cfloop>
				</ul>
			</div>

			</cfif>
			<!---
				Koniec ramki z ostatnio zalogowanymi użytkownikami.
			--->

			<!---
				2.04.2013
				Ramka z poprzedniej wersji Intranetu z informacjami o użytkowniku.
				W nowej wersji nie mam pomysłu, gdzie ją umieścić. Dlatego narazie
				ją kasuje...
			--->
			<!---<div id="profileAttributes">
				<h5>Użytkownik</h5>
				<ul>
					<cfloop query="user_attribute">
						<li>#attributelabel# <span>#userattributevaluetext#</span></li>
					</cfloop>
					<li>Email #mailTo(user.mail)#</li>
				</ul>
			</div> <!--- end #profileAttributes --->--->

			<!---<div id="profileInformations">
				<h5>Informacje</h5>
				<ul>
					<!--- <li>Data utworzenia konta <br/><span>#dateFormat(user.created_date, "dd-mm-yyyy")#</span></li> --->
					<li>Data logowania <span>#dateFormat(user.last_login, "dd/mm/yy")#</span></li>
					<!--- <li>Strukturta
						<cfloop query="userorganizations">
							<span>#organizationunitname#</span>,
						</cfloop>
					</li> --->
				</ul>
			</div> <!--- end #profileInformations --->--->

			<!---
			<div id="profileActions">
				<ul>
					<li>
						</li>
				</ul>
			</div>
			--->

			<!---
				1.04.2013
				Sprawdzam, czy mam zapisany klucz do Redmine. Jak tak to
				wyświetlam ramkę z projektami. Jak nie to wyświetlam
				formularz zapisywania klucza.

				2.04.2013
				W nowej wersji profilu użytkownika integracja z redmine
				ma wyglądać inaczej. Ponieważ nie wiem jeszcze jak usuwam
				stare ramki... :)
			--->
			<!---<cfif Len(user.redmineapikey) and Len(user.redmineid)>

			<div id="redmine_projects" class="redmine">
				<h5>Redmine / projekty</h5>

				<div class="ajax_loader">
					#imageTag(source="ajax-loader-3.gif")#
				</div>

				<div class="ajax"></div>
			</div>

			<div id="redmine_issues" class="redmine">
				<h5>Redmine / zagadnienia</h5>

				<div class="ajax_loader">
					#imageTag(source="ajax-loader-3.gif")#
				</div>

				<div class="ajax"></div>
			</div>

			<cfelse>

			<div id="redmine_integration" class="redmine">
				<h5>Integracja z Redmine</h5>

				<cfform
					action="#URLFor(controller='Projects',action='updateUser')#">
						<ol>
							<li>
								<cfinput
									type="text"
									name="redmineapikey"
									class="input"
									placeholder="Redmine ApiKey" />
							</li>
							<li>
								<cfinput
									type="text"
									name="redmineid"
									class="input"
									placeholder="ID Uzytkownika w Redmine" />
							</li>
							<li>
								<cfinput
									type="submit"
									name="submituserredmine"
									class="admin_button green_admin_button"
									value="Zapisz" />
							</li>
						</ol>
				</cfform>
			</div> <!--- end #redmine_integration --->

			</cfif>--->
			<!---
				1.04.2013
				Koniec spawdzania, czy mogę pokazać ramkę z Redmine
			--->

		</div> <!--- end #leftCol --->
	</div> <!--- end .leftContent --->

	<div class="rightContent redmine_ajax">

		<div class="inner">

			<cfif flashKeyExists("error")>
				<span class="error">#flash("error")#</span>
			</cfif>

			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privRoot" >
				<cfinvokeargument name="groupname" value="root" />
			</cfinvoke>
					
			<cfif privRoot is true>
				
				<!---<cfdump var="#Decrypt(")5YO0A9A<*]:*", get('loc').intranet.securitysalt)#" />--->
				
				<!---<cfdump var="#Decrypt("(3K+IO:EV2:L ", get('loc').intranet.securitysalt)#" /> THUHZKRM--->
				<!---<cfdump var="#Decrypt("*5YO0A9A<*=:(Z@", get('loc').intranet.securitysalt)#" />--->
				
			</cfif>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaPps" >
				<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
			</cfinvoke>
			
			<!---
				2.04.2013
				Ramka do modyfikacji swojego profilu.
				Modyfikacja profilu odbywa się poprzez dodanie do niego
				widgetów z dostępnej listy.
			--->
			<cfif structKeyExists(url, "edit") and url.edit is true>
				<div id="widget_customize_panel" class="customize_panel">

					<h5>Konfiguracja profilu</h5>

					<cfform
						action="#URLFor(controller='Widget_widgets',action='assignWidgetToUser')#"
						name="widget_customize_form" >

						<ol>
							<li>
								<cfselect
									name="widgetid"
									query="user_available_widgets"
									display="widgetdisplayname"
									value="id"
									class="select_box" >

								</cfselect>
							</li>
							<li>
								<cfinput
									type="submit"
									class="admin_button green_admin_button"
									value="+"
									name="widget_customize_submit" />
							</li>
						</ol>

					</cfform>
				</div>
			</cfif>
			<!---
				Koniec ramki do modyfikowania swojego profilu.
			--->

			<div class="clear"></div>

			<!---
				4.04.2013
				DIV generowany przez ColdFusion. W nim są otwierane kolejne strony.
			--->

			<cfdiv id="user_profile_cfdiv" >
			
			<cfif uprawnieniaPps is true <!---or privRoot is true--->>
				<div class="widgetBox">
					<div class="inner">
						<div class="widgetHeaderArea">
							<div class="widgetHeaderArea uiWidgetHeader">
								<h3 class="uiWidgetHeaderTitle">Konkurs dla sprzedawców</h3>
							</div>
						</div>
						
						<div class="widgetContentArea">
							<div class="widgetContentArea uiWidgetContent">
								<div class="uiWidgetChart uiContent">
									
									<table class="uiTable">
										<thead>
											<tr>
												<th class="leftBorder topBorder rightBorder bottomBorder">Nr</th>
												<th class="topBorder rightBorder bottomBorder">Koszyk</th>
												<th class="topBorder rightBorder bottomBorder">Koszyk docelowy</th>
												<th class="topBorder rightBorder bottomBorder">Wyniki częściowe za I tydzień</th>
											</tr>
										</thead>
										<tbody>
											<cfloop query="konkurs_sprzedawcow">
												<tr>
													<td class="leftBorder rightBorder bottomBorder">#projekt#</td>
													<td class="rightBorder bottomBorder">#NumberFormat(koszyk, "__.__")# zł</td>
													<td class="rightBorder bottomBorder">#NumberFormat(koszyk_docelowy, "__.__")# zł</td>
													<td class="rightBorder bottomBorder">#NumberFormat(wynik_1, "__.__")# zł</td>
												</tr>
											</cfloop>
										</tbody>
									</table>
								
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfif>
			
			<div class="clear"></div>
			
			<!---
				22.12.2014
				Ramka z galerią dla Marketingu.
			--->
			<!---<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaGaleria" >
				<cfinvokeargument name="groupname" value="root" />
			</cfinvoke>--->
			
			<!---<cfif uprawnieniaGaleria is true>--->
			<!---
				<div class="widgetBox">
					<div class="inner">
						<div class="widgetHeaderArea">
							<div class="widgetHeaderArea uiWidgetHeader">
								<h3 class="uiWidgetHeaderTitle">Konkurs Świąteczny</h3>
							</div>
						</div>
						
						<div class="widgetContentArea">
							<div class="widgetContentArea uiWidgetContent">
								<cfdiv id="swieta2014">
									<cfdirectory action="list" directory="/home/admin/galeria/swieta" name="galeria" />
									<cfloop query="galeria">
										<a href="javascript:ColdFusion.navigate('index.cfm?controller=galerie&action=podglad-katalogu&katalog=#NAME#', 'swieta2014')" class="folder-icon" title="Zobacz zdjcia sklepu #NAME#">
											<span>#NAME#</span>
										</a>
									</cfloop>
								</cfdiv>
								
								<div class="uiWidgetFooter">
									Zdjęcia konkursowe na najładniejszy wystrój świateczny sklepów Monkey Express
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="clear"></div>
			--->
			<!---</cfif>--->
			

			<!---
				2.04.2013
				Ramki z podziałem strony na części. Część używana
				przy dodawania widgetów i ich wyświetlaniu.
			--->
			<!---
				Górna ramka. Szerokość jest na całą stronę.
			--->
			<div class="single_column_widget widget {widget_display: 'top'}">
				<cfloop query="user_widgets">
					<cfif widgetdisplay is "top">
						<div id="widget-id-#id#" class="widget_element {widget_display: 'top', id: #id#}">
							<div class="ajax_loader">
								#imageTag(source="ajax-loader-3.gif")#
							</div>
						</div>
					</cfif>
				</cfloop>
			</div>

			<div class="clear"></div>

			<!---
				Lewa kolumna. Szerokość jest ustawiona na stałe.
			--->
			<div class="double_column_widget widget left {widget_display: 'left'}">
				<cfloop query="user_widgets">
					<cfif widgetdisplay is "left">
						<div id="widget-id-#id#" class="widget_element {widget_display: 'left', id: #id#}">
							<div class="ajax_loader">
								#imageTag(source="ajax-loader-3.gif")#
							</div>
						</div>
					</cfif>
				</cfloop>
			</div>

			<!---
				Prawa kolumna. Szerokość jest ustawiona na stałe.
			--->
			<div class="double_column_widget widget right {widget_display: 'right'}">
				<cfloop query="user_widgets">
					<cfif widgetdisplay is "right">
						<div id="widget-id-#id#" class="widget_element {widget_display: 'right', id: #id#}">
							<div class="ajax_loader">
								#imageTag(source="ajax-loader-3.gif")#
							</div>
						</div>
					</cfif>
				</cfloop>
			</div>

			<div class="clear"></div>

			<!---
				Koniec ramek z podziałem strony dla widgetów.
			--->

			<!---
				4.04.2013
				Zamykam element cfdiv.
			--->
			</cfdiv>

		</div> <!--- end .inner --->

	</div>

	<div class="clear"></div>

</div> <!--- end .userProfile --->

</cfoutput>

<!---
	2.04.2013
	Jeżeli edytuje profil to doklejam do kodu strony JS odpowiedzialny
	za zarządzanie widgetami.

--->
<cfif structKeyExists(url, "edit") and url.edit is true>

<script>
$(function() {

	var d = false;
	var tmp = 0;

	$(".widget").sortable({
		connectWith: ".widget",
		stop : function(e, ui) {
			if (d) {
                d = false;
            }
		},
		update	:	function(e, ui) {
			if (tmp == 1) {
				var _order = $(this).sortable('toArray').toString();
				$.post("<cfoutput>#URLFor(controller='Widget_widgets',action='reorder')#</cfoutput>", {neworder:_order,display:ui.item.parent().metadata().widget_display});
			}
			tmp = 1 - tmp;
		}
	});

	 $(".double_column_widget").droppable({
	 	accept: ".widget_element",
		drop: function(e, ui) {
			d = true;
		}
	});

	var myFORM = $('#widget_customize_form');
	myFORM.bind('submit', function(e) {
		e.preventDefault();

		$('#flashMessages').show();

		$.ajax({
			dataType	:	'json',
			type		:	'post',
			data		:	myFORM.serialize(),
			url			:	myFORM.attr('action'),
			success		:	function (data) {

				$('.single_column_widget').append("<div id=\"widget-id-" + data.id + "\" class=\"widget_element {widget_display: 'top',widget_order: 0}\"></div>");
				$.post("/" + <cfoutput>'#get("loc").intranet.directory#'</cfoutput> + "/index.cfm?" + data.WIDGET.widgeturl, {}, function(response){ $("#widget-id-"+data.id).html(response).show();});

				$('#widgetid option[value="'+data.WIDGETID+'"]').remove();

				$('#flashMessages').hide();
			}

		});
		return false;
	});

});
</script>

</cfif>

<!---
	2.04.2013
	Dodaje do mojej trony widgety.
--->
<script>
$(function () {
	<cfloop query="user_widgets">
		 $('#widget-id-<cfoutput>#id#</cfoutput>').AddWidget('#<cfoutput>widget-id-#id#</cfoutput>', 'http://<cfoutput>#cgi.HTTP_HOST#/#get("loc").intranet.directory#/index.cfm?#widgeturl#</cfoutput>');
	</cfloop>
});
</script>

<!---
	Koniec dodawania widgetów do mojej strony.
--->

<cfset AjaxOnLoad("initWorkflowActions") />
<cfif structKeyExists(url, "edit") and url.edit is true>
	<cfset ajaxOnLoad("initWidgetRemove") />
</cfif>