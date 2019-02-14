<cfoutput>
<div class="correspondence_block">
	<div class="inner">
		<h5>Rejestr poczty wychodzącej</h5>

		<div class="admin_submenu_bar">
			<cfform
				name="correspondence_out_filter_form"
				action="#URLFor(controller='Correspondences',action='filterCorrespondenceOut')#"
				onsubmit="javascript:ColdFusion.navigate('#URLFor(controller='Correspondences',action='filterCorrespondenceOut')#', 'refreshCorrespondenceOut', null, null, 'POST', 'correspondence_out_filter_form');return false;" >

				<ul class="correspondence_filters">
					<li>
						<cfinput
							type="text"
							name="data_wyslania"
							class="input pick_up_date"
							placeholder="Data wysłania"
							value="#iif( isDefined("session.correspondence_out_filter.data_wyslania"), DE( "#session.correspondence_out_filter.data_wyslania#" ) , "" )#" />
					</li>
					<li>
						<select
							name="typeid"
							class="select_box">

							<option value="">[Typ]</option>

							<cfloop query="my_types">
								<option value="#id#" <cfif id eq session.correspondence_out_filter.typeid> selected="selected"</cfif>>#typename#</option>
							</cfloop>

						</select>
					</li>
					<li>
						<select
							name="categoryid"
							class="select_box">

							<option value="">[Kategoria]</option>

							<cfloop query="my_categories">
								<option value="#id#" <cfif id eq session.correspondence_out_filter.categoryid> selected="selected"</cfif>>#categoryname#</option>
							</cfloop>

						</select>
					</li>
					<li>
						<cfinput
							type="submit"
							name="correspondence_out_filter_submit"
							value="Filtruj"
							class="admin_button green_admin_button" />
					</li>
				</ul>

			</cfform>
		</div>

		<table class="admin_table" id="correspondence_out_table">
			<thead>
				<tr>
					<th>Data wysłania</th>
					<th>Typ przesyłki</th>
					<th>Kategoria</th>
					<th>Ilość</th>
					<th>Uwagi</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="correspondence_out">
					<tr>
						<td>
							<cfif Len(data_wyslania)>
								#DateFormat(data_wyslania, "dd.mm.yyyy")#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(typename)>
								#typename#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(categoryname)>
								#categoryname#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(ilosc)>
								#ilosc#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(uwagi)>
								#uwagi#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfinvoke
								component="controllers.Tree_groupusers"
								method="checkUserTreeGroup"
								returnvariable="priv" >

								<cfinvokeargument
									name="groupname"
									value="Usuń wiersz" />

							</cfinvoke>

							<cfif priv is true>
								
								<a 
									href="javascript:ColdFusion.navigate('#URLFor(controller='Correspondences',action='delCorrespondenceOutRow',key=id)#', 'refreshCorrespondenceOut')"
									class="delete">
									<span>Usuń</span>
								</a>
								
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="3">
						#linkTo(
							text="<span>Edytuj</span>",
							controller="Correspondences",
							action="out",
							class="admin_button green_admin_button new_correspondence_out")#

						#linkTo(
							text="<span>Zapisz jako PDF</span>",
							controller="Correspondences",
							action="correspondenceOutPrint",
							params="format=pdf",
							target="_blank",
							class="admin_button green_admin_button")#
					</th>
					<th colspan="3">
						<cfset paginator = 1 />
						<cfset pages_count = Ceiling(correspondence_out_count/session.correspondence_out_filter.elements) />
						<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

							<cfif paginator eq session.correspondence_out_filter.page>

								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Correspondences",action="filterCorrespondenceOut",params="page=#paginator#")#', 'refreshCorrespondenceOut');" class="active">#paginator#</a>

							<cfelse>

								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Correspondences",action="filterCorrespondenceOut",params="page=#paginator#")#', 'refreshCorrespondenceOut');">#paginator#</a>

							</cfif>

							<cfset paginator++ />

						</cfloop>
						&nbsp;
					</th>
				</tr>
			</tfoot>
		</table>

	</div>
</div>
</cfoutput>