<cfoutput>
<div class="correspondence_block">
	<div class="inner">
		<h5>Książka nadawcza</h5>

		<div class="admin_submenu_bar">
			<cfform
				name="correspondence_filter_form"
				action="#URLFor(controller='Correspondences',action='filterCorrespondence')#">

				<ul class="correspondence_filters">
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="data_od"
							placeholder="Data od"
							value="#session.correspondence_filter.data_od#" />
					</li>
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="data_do"
							placeholder="Data do"
							value="#session.correspondence_filter.data_do#" />
					</li>
					<li>
						<cfinput
							type="text"
							class="input"
							name="adresat"
							placeholder="Adresat"
							value="#session.correspondence_filter.adresat#" />
					</li>
					<li>
						<cfinput
							type="submit"
							class="admin_button green_admin_button"
							name="correspondence_filter_submit"
							value="Filtruj" />
					</li>
				</ul>
			</cfform>
		</div>

				<table class="admin_table" id="correspondence">
					<thead>
						<tr>
							<th rowspan="2" class="first c">Lp.</th>
							<th rowspan="2" class="c">ADRESAT (imię i nazwisko lub nazwa)</th>
							<th rowspan="2" class="c">Dokładne miejsce doręczenia</th>
							<th colspan="2" class="c">Kwota zadekl. wart.</th>
							<th colspan="2" class="c">Masa</th>
							<th rowspan="2" class="c">Nr nadawczy</th>
							<th rowspan="2" class="c">Uwagi</th>
							<th colspan="2" class="c">Opłata</th>
							<th colspan="2" class="c">Kwota pobrania</th>
							<th rowspan="2" class="c">Data</th>
						</tr>
						<tr>
							<th class="first c">zł</th>
							<th class="first c">gr</th>
							<th class="first c">kg</th>
							<th class="first c">g</th>
							<th class="first c">zł</th>
							<th class="first c">gr</th>
							<th class="first c">zł</th>
							<th class="first c">gr</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="correspondence">
							<tr>
								<td>
									<cfif Len(lp)>
										#lp#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(adresat)>
										#adresat#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(miejsce_doreczenia)>
										#miejsce_doreczenia#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(kwota_zl)>
										#kwota_zl#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(kwota_gr)>
										#kwota_gr#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(masa_kg)>
										#masa_kg#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(masa_g)>
										#masa_g#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(nr_nadawczy)>
										#nr_nadawczy#
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
									<cfif Len(oplata_zl)>
										#oplata_zl#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(oplata_gr)>
										#oplata_gr#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(pobranie_zl)>
										#pobranie_zl#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(pobranie_gr)>
										#pobranie_gr#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>#DateFormat(correspondencecreated, "yyyy/mm/dd")#</td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<th colspan="14">
								#linkTo(
									text="Edytuj aktualną listę",
									controller="Correspondences",
									action="newList",
									class="admin_button green_admin_button new_correspondence")#

								#linkTo(
									text="<span>Zapisz jako PDF</span>",
									controller="Correspondences",
									action="printList",
									params="format=pdf",
									target="_blank",
									class="admin_button green_admin_button")#
							</th>
						</tr>
					</tfoot>
				</table>
			</div> <!--- Koniec .inner --->
			</div> <!--- Koniec .correspondence_block --->
</cfoutput>
