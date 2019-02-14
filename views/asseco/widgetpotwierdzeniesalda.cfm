<cfprocessingdirective pageencoding="utf-8" />

<div class="widgetBox">
	<div class="inner">
		
		<div class="widgetHeaderArea">
			<div class="widgetHeaderArea uiWidgetHeader">
				<h3 class="uiWidgetHeaderTitle">
					<cfoutput>Zestawienie należności na #DateFormat(saldo.nadzien, "dd.mm.yyyy")#</cfoutput>
				</h3>
			</div>
		</div>
		
		<div class="widgetContentArea">
			<div class="widgetContentArea uiWidgetContent">
						
				<div class="widgetContextual">
					<ul>
						<li>
							<a href="<cfoutput>#URLFor(controller='Asseco',action='eksportPotwierdzenieSalda',params='typ=xls')#</cfoutput>" title="Eksport do .XLS">Eksport do .XLS</a>
						</li>
					</ul>
				</div>
				
				<table class="uiTable" cellpadding="0" cellspacing="0"><cfoutput>
					<tbody>
						<tr><td class="l blackLeft blackTop blackRight"><span class="uiTableGrayText">Nadawca</span>#daneFirmy.nazwa1#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneFirmy.nazwa2#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneFirmy.ulica#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneFirmy.kodp#&nbsp;#daneFirmy.miasto#</td></tr>
						<tr><td class="l blackLeft blackRight">NIP: #daneFirmy.nip#</td></tr>
						<tr><td class="l blackLeft blackRight blackBottom">Telefon: #daneFirmy.telefon# Fax: #daneFirmy.fax#</td></tr>
					</tbody>
				</cfoutput></table>
				
				<table class="uiTable" cellpadding="0" cellspacing="0"><cfoutput>
					<tbody>
						<tr><td class="l blackLeft blackRight blackTop"><span class="uiTableGrayText">Adresat</span>#session.user.logo#<span class="uiTableGrayText">Projekt</span>#daneKontrahenta.projekt#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneKontrahenta.nazwa1#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneKontrahenta.nazwa2#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneKontrahenta.ulica#</td></tr>
						<tr><td class="l blackLeft blackRight">#daneKontrahenta.kodp#&nbsp;#daneKontrahenta.miasto#</td></tr>
						<tr><td class="l blackLeft blackRight blackBottom">NIP: #daneKontrahenta.nip#</td></tr>
					</tbody>
				</cfoutput></table>
				
				<table class="uiTable" cellpadding="0" cellspacing="0"><cfoutput>
					<thead>
						<tr>
							<th rowspan="2" class="blackLeft blackRight blackTop blackBottom">Lp.</th>
							<th colspan="2" class="blackRight blackTop blackBottom">Na dobro</th>
							<th colspan="2" class="blackRight blackTop blackBottom">Salda wynikają z nast pozycji</th>
						</tr>
						<tr>
							<th class="blackRight blackBottom">Nasze</th>
							<th class="blackRight blackBottom">Wasze</th>
							<th class="blackRight blackBottom">Data</th>
							<th class="blackRight blackBottom">Numer faktury</th>
						</tr>
					</thead>
					<tbody>
						<cfset lp = 1 />
						<cfloop query="saldo">
							<tr>
								<td class="blackLeft blackRight grayBottom">#lp#</td>
								<td class="r blackRight grayBottom">
									<cfif nasza_kwota NEQ 0.0>
										#nasza_kwota#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td class="r blackRight grayBottom">
									<cfif wasza_kwota NEQ 0.0>
										#wasza_kwota#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td class="l blackRight grayBottom">#DateFormat(dstart, "dd.mm.yyyy")#</td>
								<td class="l blackRight grayBottom">#symroz#</td>
							</tr>
						<cfset lp = lp + 1 />
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<th class="blackLeft blackBottom blackRight blackTop">Suma</th>
							<th class="blackBottom blackRight blackTop">#saldo.nasza_suma#</th>
							<th class="blackBottom blackRight blackTop">#saldo.wasza_suma#</th>
							<th colspan="2" class="blackTop">&nbsp;</th>
						</tr>
						<tr>
							<th class="blackLeft blackBottom blackRight">Saldo</th>
							<th class="blackBottom blackRight">#saldo.nasze_saldo#</th>
							<th class="blackRight blackBottom">#saldo.wasze_saldo#</th>
							<th colspan="2">&nbsp;</th>
						</tr>
					</tfoot>
				</cfoutput></table>
			</div>
		</div>
		
	</div>
</div>
