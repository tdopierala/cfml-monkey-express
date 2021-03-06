<cfoutput>
<div class="correspondence_block">
	<div class="inner">
		<h5>Rejestr poczty przychodzącej</h5>

		<div class="admin_submenu_bar">
			<cfform
				name="correspondence_in_filter_form"
				action="#URLFor(controller='Correspondences',action='filterCorrespondenceIn')#" >

				<ul class="correspondence_filters">
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="data_wplywu"
							placeholder="Data wpływu"
							value="" />
					</li>
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="pismo_z_dn"
							placeholder="Pismo z dnia"
							value="" />
					</li>
					<li>
						<select
							name="typeid"
							class="select_box">

							<option value="">[Typ]</option>

							<cfloop query="my_types">
								<option value="#id#" <cfif id eq session.correspondence_in_filter.typeid> selected="selected"</cfif>>#typename#</option>
							</cfloop>

						</select>
					</li>
					<li>
						<select
							name="categoryid"
							class="select_box">

							<option value="">[Kategoria]</option>

							<cfloop query="my_categories">
								<option value="#id#" <cfif id eq session.correspondence_in_filter.categoryid> selected="selected"</cfif>>#categoryname#</option>
							</cfloop>

						</select>
					</li>
					<li>
						<cfinput
							type="text"
							class="input"
							name="szukaj"
							placeholder="Szukaj"
							value="" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="correspondence_in_filter_submit"
							class="admin_button green_admin_button"
							value="Filtruj" />
					</li>
				</ul>

			</cfform>
		</div>

		<table class="admin_table" id="correspondence_in_table">
			<thead>
				<tr>
					<th class="c">Nr</th>
					<th class="c">Data wpłytu</th>
					<th class="c">Pismo z dn.</th>
					<th class="c">Sygnatura</th>
					<th class="c">Typ przesyłki</th>
					<th class="c">Kategoria</th>
					<th class="c">Nadawca</th>
					<th class="c">Adres</th>
					<th class="c">Dotyczy</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="correspondence_in">
					<tr>
						<td>
							<cfif Len(nr)>
								#nr#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(data_wplywu)>
								#data_wplywu#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(pismo_z_dn)>
								#pismo_z_dn#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(sygnatura)>
								#sygnatura#
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
							<cfif Len(nadawca)>
								#nadawca#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(adres)>
								#adres#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						<td>
							<cfif Len(dotyczy)>
								#dotyczy#
							<cfelse>
								&nbsp;
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
							action="in",
							class="admin_button green_admin_button new_correspondence_in")#

						<!---#linkTo(
							text="<span>Zapisz jako PDF</span>",
							controller="Correspondences",
							action="correspondenceInPrint",
							params="format=pdf",
							target="_blank",
							class="admin_button green_admin_button")#--->
					</th>
					<th colspan="6">
						<cfset paginator = 1 />
						<cfset pages_count = Ceiling(correspondence_in_count/session.correspondence_in_filter.elements) />
						<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

							<cfif paginator eq session.correspondence_in_filter.page>

								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Correspondences",action="filterCorrespondenceIn",params="page=#paginator#")#', 'refreshCorrespondenceIn');" class="active">#paginator#</a>

							<cfelse>

								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Correspondences",action="filterCorrespondenceIn",params="page=#paginator#")#', 'refreshCorrespondenceIn');">#paginator#</a>

							</cfif>

							<cfset paginator++ />

						</cfloop>
					</th>
				</tr>
			</tfoot>
		</table>

	</div>
</div>
</cfoutput>
