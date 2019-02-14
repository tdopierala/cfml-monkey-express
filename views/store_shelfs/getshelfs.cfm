<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="privUsuniecieRegalu" >
						
		<cfinvokeargument
			name="groupname"
			value="Usunięcie regału" />
					
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageEncoding="utf-8" />

<table class="admin_table">
	<thead>
		<tr>
			<th class="first">&nbsp;</th>
			<th>Typ sklepu</th>
			<th>Kategoria regału</th>
			<th>Typ regału</th>
			<th>&nbsp;</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="shelfs">
			<tr>
				<td class="first">&nbsp;</td>
				<td class="storetypename">
					<cfif Len(storetypename)>
						<cfoutput>#storetypename#</cfoutput>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td class="shelfcategoryname"><cfoutput>#shelfcategoryname#</cfoutput></td>
				<td class="shelftypename"><cfoutput>#shelftypename#</cfoutput></td>
				<td>
					<cfif privUsuniecieRegalu is true>
						<a href="javascript:void(0)" title="Usuń regał" class="remove_shelf" onclick="javascript:removeShelf(<cfoutput>#id#</cfoutput>, $(this))">
							<span>Usuń regał</span>
						</a>
					</cfif>
				</td>
			</tr>
		</cfloop>
	</tbody>
	<tfoot>
		<tr>
			<th class="first">&nbsp;</th>
			<th>Zdefiniowanych: <cfoutput>#shelfsCount.c#</cfoutput></th>
			<th colspan="3">

				<cfset paginator = 1 />
				<cfset numberOfPages = Ceiling(shelfsCount.c/session.shelfs.elements) />
				<cfloop condition="paginator LESS THAN OR EQUAL TO numberOfPages" >

					<a
						href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Store_shelfs",action="getShelfs",params="page=#paginator#&elements=#session.shelfs.elements#")#</cfoutput>', 'shelf_table');"
						class="<cfif paginator EQ session.shelfs.page>active</cfif>"
						title="<cfoutput>#paginator#</cfoutput>">

						<span><cfoutput>#paginator#</cfoutput></span>

					</a>

					<cfset paginator++ />

				</cfloop>

			</th>
		</tr>
	</tfoot>
</table>