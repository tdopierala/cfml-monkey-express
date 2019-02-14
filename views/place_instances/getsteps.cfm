<cfsilent>
	<cfinclude template="../include/place_privileges.cfm" />
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv">
		<cfinvokeargument name="groupname" value="Przywracanie nieruchomości" />
	</cfinvoke>
</cfsilent>

<cfoutput>
	
	<tr>
		<td class="first"></td>
		<td colspan="7" class="admin_submenu_options">
			<!---<cfdiv id="place_instance_#instanceId#">---> <!--- Ajaxowe ładowanie posortowanej tabelki --->
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Etap</th>
						<th>
							Data utworzenia etapu
						</th>
						<th>Status</th>
						<th>Data zmiany statusu</th>
						<th>Użytkownik</th>
						<th>Akcja</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="placesteps">
						<tr
						
							<cfswitch expression="#statusid#" >
								<cfcase value="1" >
									class=""
								</cfcase>
								
								<cfcase value="2" >
									class="accepted_place_step"
								</cfcase>
								
								<cfcase value="3">
									class="refused_place_step"
								</cfcase>
							</cfswitch>
						
						>
							<td>
								#linkTo(
									text="<span>pobierz elementy etapu</span>",
									controller="Place_instances",
									action="getInstanceStepElements",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#stepname#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(start, "yyyy-mm-dd")# #TimeFormat(start, "HH:mm")#</td>
							<td>#statusname#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(stop, "yyyy-mm-dd")# #TimeFormat(stop, "HH:mm")#</td>
							<td>#givenname# #sn#<br /><span class="i">#position#</span></td>
							<td>
								
								<!---
									Jeżeli status jest "W trakcie" to pokazuje przyciski.
								--->
								<cfif statusid eq 1>
								
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="acceptprivilege") >
									
										#linkTo(
											text="<span>Akceptuje krok</span>",
											controller="Place_instances",
											action="acceptStep",
											key=id,
											class="accept_place_step",
											title="Zaakceptuj krok")#
										
									</cfif>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="refuseprivilege")>
									
										#linkTo(
											text="<span>Odrzucam krok</span>",
											controller="Place_instances",
											action="refuseStep",
											key=id,
											class="reject_place_step",
											title="Odrzuć krok")#
									
									</cfif>
										
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="archiveprivilege")>
										
										#linkTo(
											text="<span>Przenieś do archiwum</span>",
											controller="Place_instances",
											action="archiveStep",
											key=id,
											class="archive_place_step",
											title="Przenieś do archiwum")#
										
									</cfif>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="deleteprivilege")>
										
										#linkTo(
											text="<span>Usuń nieruchomość</span>",
											controller="Place_instances",
											action="delete",
											key=id,
											class="delete_place_step",
											title="Usuń nieruchomość")#
										
									</cfif>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="moveprivilege")>
										
											#linkTo(
												text="<span>Przekaż do etapu</span>",
												controller="Place_instances",
												action="move",
												key=id,
												class="move_place_step",
												title="Przekaż do etapu")#
										
									</cfif>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="controllingprivilege")>
										
											#linkTo(
												text="<span>Zawieszone przez controlling</span>",
												controller="Place_instances",
												action="controllingStep",
												key=id,
												class="controlling_place_step",
												title="Zawieszone przez Controlling")#
										
									</cfif>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="dtprivilege")>
										
											#linkTo(
												text="<span>Zawieszone przez DT</span>",
												controller="Place_instances",
												action="dtStep",
												key=id,
												class="dt_place_step",
												title="Zawieszone przez DT")#
										
									</cfif>
								
								<!---
									Jeżeli status jest inny niż "W trakcie" to ukrywam przyciski
									i daje tylko możliwość usunięcia nieruchomości.
								--->
								<cfelse>
									
									<cfif checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=stepid,accessname="deleteprivilege")>
										
										#linkTo(
											text="<span>Usuń nieruchomość</span>",
											controller="Place_instances",
											action="delete",
											key=id,
											class="delete_place_step",
											title="Usuń nieruchomość")#
										
									</cfif>
									
									<cfif priv is true>
										<a href="javascript:ColdFusion.navigate('#URLFor(controller='Place_instances',action='rollback',key=id)#')"
											class="restore_place"
											title="Przywróć nieruchomość">
												<span>Przywróć nieruchomość</span>
										</a>
									</cfif>
										
								</cfif>
								
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<!---</cfdiv>--->
		</td>
	</tr>

</cfoutput>
