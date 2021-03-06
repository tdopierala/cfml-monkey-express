<div>
	
	<div class="details-table-sort">
		<label class="sort-label strong">Filtruj wyniki wg typu:</label>
		<label class="sort-label">
			<input type="checkbox" name="sort_checkbox" value="wplaty" id="payment_checkbox" class="sort-checkbox" <cfif StructKeyExists(params, "wplaty") or IsDefined("_wplaty_check")>checked="checked"</cfif> />&nbsp;Wpłaty gotówkowe
		</label>
		<label class="sort-label">
			<input type="checkbox" name="sort_checkbox" value="fv" id="fv_checkbox" class="sort-checkbox" <cfif StructKeyExists(params, "fv") or IsDefined("_fv_check")>checked="checked"</cfif> />&nbsp;Faktury
		</label>
		<label class="sort-label">
			<input type="checkbox" name="sort_checkbox" value="karty" id="card_checkbox" class="sort-checkbox" <cfif StructKeyExists(params, "karty") or IsDefined("_karty_check")>checked="checked"</cfif> />&nbsp;Transakcje kartą
		</label>
		<div style="clear:both"></div>
	</div>
	
	<table class="tables">
		<thead>
			<th>L.p.</th>
			<th>Data</th>
			<th>Opis</th>
			<th>Opis nag.</th>
			<th>Typ</th>
			<th>Kwota</th>
		</thead>
		<tbody>
			<cfset c=0 />
			<cfloop query="qStarter">
				<cfset c=c+1 />
				
				<cfset _kwota = LSParseNumber(kwota) />
				
				<cfif _kwota gt 0 and (typ eq 1 or typ eq 3)>
					<cfset _kwota = _kwota * (-1.0) />
				</cfif>
				
				<cfoutput>
					<tr>
						<td class="dlp">#c#</td>
						<td class="ddate">#DateFormat(data, "yyyy-mm-dd")#</td>
						<td class="ddescs" title="#opis#">
							<cfif Len(opis) gt 35>
								#Left(opis, 35)#...
							<cfelse>
								#opis#
							</cfif>
						</td>
						<td class="ddescl" title="#opisnag#">
							<cfif Len(opisnag) gt 72>
								#Left(opisnag, 72)#...
							<cfelse>
								#opisnag#
							</cfif>
						</td>
						<td class="dtype">
							<cfswitch expression="#typ#">
								<cfcase value="1">
									<span>Wpłata</span>
								</cfcase>
								<cfcase value="2">
									<span>Faktura</span>
								</cfcase>
								<cfcase value="3">
									<span>Transakcja&nbsp;kartą</span>
								</cfcase>
							</cfswitch>
						</td>
						
						<cfif _kwota lt 0>
							<cfset colorclass="mark_green" />
						<cfelseif _kwota gt 0>
							<cfset colorclass="mark_red" />
						<cfelse>
							<cfset colorclass="" />
						</cfif>
						
						<td class="number dvalue">
							<span class="#colorclass#">#Replace(NumberFormat(_kwota, "__,___.__"), ",", " ", "ALL") & " zł"#</span>
						</td>
					</tr>
				</cfoutput>
			</cfloop>
			
			<cfif not StructKeyExists(params,"full")>
				<tr>
					<td colspan="6" id="more_button">
						Pobierz wszystkie
					</td>
				</tr>
			</cfif>
			
		</tbody>
	</table>
	
</div>

<!---<cfdump var="#qStarter#">--->