<style>
	table { font-size: 11px; font-family: verdana,arial,helvetica,sans-serif; background-color: #884488; }
	th { background-color: #FFDDFF; font-weight: normal; text-align: left; padding: 2px 5px; }
	td { background-color: #ffffff; padding: 2px 5px; min-width: 70px; }
	table tbody tr:hover td { background-color: #dedede; }
	.thead { background-color: #AA66AA; color: #ffffff; font-weight: bold; }
	.numeric { text-align: right; }
	.lp { background-color: #FFDDFF; min-width: 20px; }
	.minus { color: #ff0000; }
</style>
<cfoutput>
	
	<table>
		<thead>
			<tr>
				<th colspan="23" class="thead">raport sprzedazy</th>
			</tr>
			<tr>
				<th rowspan="2">##</th>
				<th rowspan="2">projekt</th>
				<th rowspan="2">miejscowosc</th>
				<th colspan="2">od 2014-04-07 do #DateFormat(DateAdd("d", -2, Now()),"yyyy-mm-dd")#</th>
				<th colspan="2">od #DateFormat(DateAdd("d", -(DayOfWeek(Now())-2), Now()),"yyyy-mm-dd")# do #DateFormat(DateAdd("d", -1, Now()),"yyyy-mm-dd")#</th>
				
				<th rowspan="2">przyrost %<br />(brutto)</th>
				<th rowspan="2">przyrost %<br />(netto)</th>
				
				<cfquery dbtype="query" name="dayly"> 
		    		SELECT e_day FROM salesdayly
					GROUP BY e_day
					ORDER BY e_day DESC
				</cfquery>
					
				<cfloop query="dayly">
					<th colspan="2">#DateFormat(e_day, "yyyy-mm-dd")#</th>
				</cfloop>
				
			</tr>
			<tr>
				<th>srednia (brutto)</th>
				<th>srednia (netto)</th>
				
				<th>srednia (brutto)</th>
				<th>srednia (netto)</th>
				
				<cfloop query="dayly">
					<th>brutto</th>
					<th>netto</th>
				</cfloop>
			</tr>
		</thead>
		<tbody>
			<cfset c=0 />
			<cfloop query="salessum">
				<cfset c++ />
				
				<cfquery dbtype="query" name="dayly"> 
			    	SELECT c_brutto, d_netto, e_day AS c FROM salesdayly
			    	WHERE b_sklep=<cfqueryparam value="#salessum.a_sklep#" cfsqltype="cf_sql_integer" maxLength="20">
					ORDER BY e_day ASC
				</cfquery>
				
				<tr>
					<td class="numeric lp">#c#</td>
					<td class="numeric">#b_projekt#</td>
					<td class="numeric">#c_miejscowosc#</td>
					
					<td class="numeric">#d_srednia_brutto_z_tyg#</td>
					<td class="numeric">#g_srednia_netto_z_tyg#</td>
					
					<td class="numeric">#e_obrot_brutto_na_dzien#</td>
					<td class="numeric">#h_obrot_netto_na_dzien#</td>
					
					<td class="numeric">
						<cfif f_przyrost_brutto lt 0>
							<span class="minus">#f_przyrost_brutto#</span>
						<cfelse>
							<span>#f_przyrost_brutto#</span>
						</cfif>
					</td>
					<td class="numeric">
						<cfif i_przyrost_netto lt 0>
							<span class="minus">#i_przyrost_netto#</span>
						<cfelse>
							<span>#i_przyrost_netto#</span>
						</cfif>
					</td>
					
					<cfloop query="dayly">
						<td class="numeric">#c_brutto#</td>
						<td class="numeric">#d_netto#</td>
					</cfloop>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>