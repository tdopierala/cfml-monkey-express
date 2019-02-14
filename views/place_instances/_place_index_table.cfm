<cfprocessingdirective pageEncoding="utf-8" />

<cfsilent>
	<cfinclude template="../include/place_privileges.cfm" />
	
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="priv" >

		<cfinvokeargument
			name="groupname"
			value="Przywracanie nieruchomości" />

	</cfinvoke>
	
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="priv_autorNieruchomosci" >

		<cfinvokeargument
			name="groupname"
			value="Zmiana autora nieruchomości" />

	</cfinvoke>
	
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="priv_Pelnomocnik" >

		<cfinvokeargument
			name="groupname"
			value="Pełnomocnik" />

	</cfinvoke>
					
</cfsilent>

	<cfoutput>
		<table class="admin_table" id="place_instance_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Numer</th>
					<th>Miejscowość</th>
					<th>Kod pocztowy</th>
					<th>Ulica</th>
					<th>
						Data utworzenia 
						<cfscript>
						if (isDefined("url.sort") and url.sort is 'asc')
						{
							writeOutput("
							<a href=""javascript:ColdFusion.navigate('#URLFor(controller="Place_instances",action="index",params="sort=desc")#', 'place_instances_index')""
							class=""place_sort desc"">
							<span>sort</span>
							</a>
							");
						} 
						else if (isDefined("url.sort") and url.sort is 'desc')
						{
							writeOutput("
							<a href=""javascript:ColdFusion.navigate('#URLFor(controller="Place_instances",action="index",params="sort=asc")#', 'place_instances_index')""
							class=""place_sort asc"">
							<span>sort</span>
							</a>
							");
						}
						else 
						{
							writeOutput("<a href=""javascript:ColdFusion.navigate('#URLFor(controller="Place_instances",action="index",params="sort=asc")#', 'place_instances_index')""
							class=""place_sort asc"">
							<span>sort</span>
							</a>
							");
						}
						</cfscript>
					</th>
					<th>Partner</th>
					<th>&nbsp;</th>
				</tr>
				<tr>
					<th colspan="8">
						Wyszukaj w tabeli:
						#textFieldTag(
							name="tablesearch",
							class="input input_search")#
					</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="places">
					<tr class="
					<cfscript>
						switch (source)
						{
							case 1: 
								writeOutput("imported");
								break;
							case 2:
								writeOutput("user_changed");
								break;
							default:
								break;
						}
					</cfscript>
					" >
						<td>
							#linkTo(
								text="<span>pobierz dane nieruchomości</span>",
								controller="Place_instances",
								action="getSteps",
								key=id,
								class="expand_step_forms")#
						</td>
						<td>#id#</td>
						<td>
							<cfif not Len(instanceplace)>
								&nbsp;
							<cfelse>
								#instanceplace#
							</cfif>
						</td>
						<td>
							<cfif not Len(instancepostalcode)>
								&nbsp;
							<cfelse>
								#instancepostalcode#
							</cfif>
						</td>
						<td>
							<cfif not Len(instancestreet)>
								&nbsp;
							<cfelse>
								#instancestreet# #streetnumber#
							</cfif>
						</td>
						<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(instancecreated, "yyyy-mm-dd")# #TimeFormat(instancecreated, "HH:mm")#</td>
						<td>#givenname# #sn#<br /><span class="i">#position#</span></td>
						<td>

							<!---
							19.11.2012
							Dodałem ikonkę, która zawiera komunikat, dlaczego lokalizacja została odrzucona.
							Aby dodać ikonkę najpierw sprawdzam, czy powód został wybrany.
							--->
							<cfif Len(instancereasonid) and instancereasonid neq 0>

								#linkTo(
									text="<span>Powód</span>",
									controller="Place_instances",
									action="getReason",
									key=id,
									class="ajaxmodallink place_reason",
									title="Powód")#

							<cfelse>

								&nbsp;

							</cfif>

							<!---
								10.01.2013
								Tutaj generuje podsumowanie obiegu nieruchomości.
							--->
							#linkTo(
								text="<span>Wygeneruj podsumowanie</span>",
								controller="Place_instances",
								action="getSummary",
								key=id,
								params="format=pdf",
								class="place_workflow_summary",
								target="_blank",
								title="Wygeneruj podsumowanie")#
							
							<!---
								Sprawdzam, czy jest ustawiony status inny niż
								"W trakcie". Jak tak dodaje guzik przywrócenia.
							--->	
							<cfif priv IS true and 
								(instancestatusid EQ 3 or 
								instancestatusid EQ 5 or 
								instancestatusid EQ 6 or 
								instancestatusid EQ 7 or
								instancestatusid EQ 8) >
									
								<a href="javascript:ColdFusion.navigate('#URLFor(controller='Place_instances',action='rollback',key=id)#')"
									class="restore_place"
									title="Przywróć nieruchomość">
										<span>Przywróć nieruchomość</span>
								</a>
									
							</cfif>
							
							<cfif ( priv_Pelnomocnik is true ) AND
								( instancestatusid EQ 3 ) >
								
								<a href="<cfoutput>#URLFor(controller='Place_instances',action='recallCommittee',key=id)#</cfoutput>"
									class="recall_committee_place"
									title="Przekaż do komitetu odwoławczego">
										<span>Przekaż do komitetu odwoławczego</span>
								</a>
								
							</cfif>
									
							<!---<cfif instancestatusid neq 1>
								#linkTo(
									text="<span>Przywróć nieruchomość</span>",
									controller="Place_instances",
									action="rollback",
									key=id,
									class="place_workflow_rollback",
									title="Przywróć nieruchomość")#
							</cfif>--->
							
							<!---
								9.07.2013
								Zmiana własciciela nieruchomości.
							--->
							<cfif priv_autorNieruchomosci IS true >
							
							<a 
								href="#URLFor(controller='Place_instances',action='changeOwner',key=id)#"
								class="movetouser_place"
								title="Zmień autora nieruchomości">
									
								<span>Zmień autora nieruchomości</span>
								
							</a>
							
							</cfif>
							

						</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th class="first">&nbsp;</th>
					<th colspan="6">

						<div class="places_pagination_box"> <!--- okienko paginacji --->

							<cfset paginator = 1 />
							<cfset pages_count = Ceiling(myplaces_count.c/session.places_filter.elements) />
							<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

								<cfif paginator eq session.places_filter.page>

									#linkTo(
										text="<span>#paginator#</span>",
										controller="Place_instances",
										action="index",
										key=session.user.id,
										class="active",
params="page=#paginator#&elements=#session.places_filter.elements#&statusid=#session.places_filter.status#&stepid=#session.places_filter.stepid#")#

								<cfelse>

									#linkTo(
										text="<span>#paginator#</span>",
										controller="Place_instances",
										action="index",
										key=session.user.id,
params="page=#paginator#&elements=#session.places_filter.elements#&statusid=#session.places_filter.status#&stepid=#session.places_filter.stepid#")#

								</cfif>

								<cfset paginator++ />

							</cfloop>

						</div> <!--- koniec okienka paginacji --->

					</th>
					<th>
						<ul class="admin_place_stats">
						<cfloop query="stats">
							<li>#statusname#: #statuscount#</li>
						</cfloop>
						</ul>
					</th>
				</tr>
			</tfoot>
		</table>
	</cfoutput>
	