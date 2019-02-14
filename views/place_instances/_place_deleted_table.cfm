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
					<th>Data utworzenia</th>
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
					<tr>
						<td>&nbsp;</td>
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
								8.07.2013
								Ikonka pozwalająca na przywrócenie usuniętej 
								nieruchomości.
							--->
							<a 
							href="#URLFor(controller='Place_instances',action='unDelete',key=id)#"
							class="undelete_place"
							title="Przywróc nieruchomość">
								<span>Przywróć nieruchomość</span>
							</a>

						</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th class="first">&nbsp;</th>
					<th colspan="6">&nbsp;</th>
					<th>
						<ul class="admin_place_stats">
						
						</ul>
					</th>
				</tr>
			</tfoot>
		</table>
	</cfoutput>