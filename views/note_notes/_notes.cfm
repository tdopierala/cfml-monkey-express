<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="usuniecieNotatki" >
		
		<cfinvokeargument name="groupname" value="Usunięcie notatki" />
	</cfinvoke>
	
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="edycjaNotatki" >
		
		<cfinvokeargument name="groupname" value="Edycja notatki" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaPps">
		<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaKos">
		<cfinvokeargument name="groupname" value="KOS" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaCentrala">
		<cfinvokeargument name="groupname" value="Centrala" />
	</cfinvoke>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

	<cfif uprawnieniaPps is false and 
		uprawnieniaKos is false>
<a href="index.cfm?controller=note_notes&action=add" title="Dodaj notatkę" class="admin_button green_admin_button">Dodaj notatkę</a>
				<a href="index.cfm?controller=note_notes&action=print&format=pdf" title="Agreguj notatki" class="admin_button gray_admin_button" target="_blank" onclick="goToPrint($(this)); return false;">Agreguj notatki</a>

	</cfif>
<table class="uiTable">
	<thead>
		<tr>
			<th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
			<th class="rightBorder topBorder bottomBorder">
				<cfif Find("projekt:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=n.projekt:desc')">
						<span class="asc">Sklep</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=n.projekt')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("projekt:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=n.projekt:asc')">
						<span class="desc">Sklep</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=n.projekt')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=n.projekt:asc')">
						<span class="">Sklep</span>
					</a>
					
				</cfif>
			</th>

			<th class="rightBorder topBorder bottomBorder">
				
				<cfif Find("ulica:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=ulica:desc')">
						<span class="asc">Ulica</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=ulica')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("ulica:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=ulica:asc')">
						<span class="desc">Ulica</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=ulica')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=ulica:asc')">
						<span class="">Ulica</span>
					</a>
					
				</cfif>
					
			</th>
			<th class="rightBorder topBorder bottomBorder">
				
				<cfif Find("miasto:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=miasto:desc')">
						<span class="asc">Miasto</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=miasto')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("miasto:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=miasto:asc')">
						<span class="desc">Miasto</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=miasto')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=miasto:asc')">
						<span class="">Miasto</span>
					</a>
					
				</cfif>

			</th>
			<th class="rightBorder topBorder bottomBorder">
				
				<cfif Find("u2.givenname:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u2.givenname:desc')">
						<span class="asc">KOS</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=u2.givenname')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("u2.givenname:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u2.givenname:asc')">
						<span class="desc">KOS</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=u2.givenname')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u2.givenname:asc')">
						<span class="">KOS</span>
					</a>
					
				</cfif>
				
			</th>
			<th class="rightBorder topBorder bottomBorder">
				<cfif Find("inspection_date:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=inspection_date:desc')">
						<span class="asc">Kontrola</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=inspection_date')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("inspection_date:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=inspection_date:asc')">
						<span class="desc">Kontrola</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=inspection_date')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=inspection_date:asc')">
						<span class="">Kontrola</span>
					</a>
					
				</cfif>
			</th>
			<th class="rightBorder topBorder bottomBorder">
				<cfif Find("note_created:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=note_created:desc')">
						<span class="asc">Data powstania</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=note_created')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("note_created:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=note_created:asc')">
						<span class="desc">Data powstania</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=note_created')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=note_created:asc')">
						<span class="">Data powstania</span>
					</a>
					
				</cfif>
			</th>
			<th class="rightBorder topBorder bottomBorder">
				<cfif Find("u.givenname:asc", session.note_notes.sortString)>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u.givenname:desc')">
						<span class="asc">Twórca</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=u.givenname')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("u.givenname:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u.givenname:asc')">
						<span class="desc">Twórca</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=u.givenname')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=u.givenname:asc')">
						<span class="">Twórca</span>
					</a>
					
				</cfif>
			</th>
			<th class="rightBorder topBorder bottomBorder">
				<cfif Find("score:asc", session.note_notes.sortString)>
				
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=score:desc')">
						<span class="asc">Ocena</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=score')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelseif Find("score:desc", session.note_notes.sortString)>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=score:asc')">
						<span class="desc">Ocena</span>
					</a>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=remove-sort-column&sort=score')" title="Usuń kolumnę sortowania" class="removeSortColumn">x</a>
					
				<cfelse>
					
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&sort=score:asc')">
						<span class="">Ocena</span>
					</a>
					
				</cfif>
			</th>
			<th class="rightBorder topBorder bottomBorder">&nbsp;</th>
			<th class="rightBorder topBorder bottomBorder">&nbsp;</th>
			<th class="topBorder rightBorder bottomBorder">#</th>
		</tr>
	</thead>
	<tbody>
		<cfset lp = 1 />
		<cfloop query="notes">
			<cfoutput>
			<cfif isPrivate EQ 1 and uprawnieniaCentrala EQ false>
				<cfcontinue />
			</cfif>
			<tr>
				<td class="leftBorder rightBorder bottomBorder">
					<a href="index.cfm?controller=note_notes&action=view&key=#id#">
						#lp#
					</a>
				</td>
				<td class="rightBorder bottomBorder l">#UCase(projekt)#</td>
				<td class="rightBorder bottomBorder l">#ulica#</td>
				<td class="rightBorder bottomBorder l">#miasto#</td>
				<td class="rightBorder bottomBorder l">#partner_givenname# #partner_sn#</td>
				<td class="rightBorder bottomBorder r">#DateFormat(inspectiondate, "yyyy/mm/dd")#</td>
				<td class="rightBorder bottomBorder r">#DateFormat(notecreated, "yyyy/mm/dd")#</td>
				<td class="rightBorder bottomBorder l">#UCase(Left(user_givenname, 1))##LCase(Right(user_givenname, Len(user_givenname)-1))# #UCase(Left(user_sn, 1))##LCase(Right(user_sn, Len(user_sn)-1))#</td>
				<td class="rightBorder bottomBorder r">#score#</td>
				<td class="rightBorder bottomBorder">
					<input type="checkbox" name="noteid" value="#id#"/>
				</td>
				<td class="rightBorder bottomBorder inlineIcons">
					<cfif edycjaNotatki is true>
						<a href="index.cfm?controller=note_notes&action=edit&key=#id#" class="edit" title="Edytuj notatkę">
							<span>Edytuj</span>
						</a>
					</cfif>
					
					<cfif usuniecieNotatki is true>
						<a href="index.cfm?controller=note_notes&action=del&key=#id#" class="remove" title="Usuń notatkę">
							<span>Usuń</span>
						</a>
					</cfif>
					
					<a href="index.cfm?controller=note_notes&action=view&key=#id#" class="preview" title="Podgląd notatki">
						<span>Podgląd</span>
					</a>
				</td>
				<td class="rightBorder bottomBorder r">#id#</td>
			</tr>
			<cfset lp = lp + 1 />
			</cfoutput>
		</cfloop>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="11">
				<cfif uprawnieniaPps is false and
					uprawnieniaKos is false>
				
				<a href="index.cfm?controller=note_notes&action=add" title="Dodaj notatkę" class="admin_button green_admin_button">Dodaj notatkę</a>
				<a href="index.cfm?controller=note_notes&action=print&format=pdf" title="Agreguj notatki" class="admin_button gray_admin_button" target="_blank" onclick="goToPrint($(this)); return false;">Agreguj notatki</a>
				
				</cfif>
			</td>
		</tr>
	</tfoot>
</table>
