<cfsilent>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="ramkaZmianaKontrahenta">

	<div class="leftWrapper">
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Zmiana kontrahenta</h3>
			</div>
		</div>

		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<table class="uiTable aosTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Numer faktury</th>
							<th class="topBorder rightBorder bottomBorder">Kontrahent</th>
							<th class="topBorder rightBorder bottomBorder">NIP</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="leftBorder bottomBorder rightBorder"><cfoutput>#dokument.numer_faktury_zewnetrzny# (#dokument.numer_faktury#)</cfoutput></td>
							<td class="bottomBorder rightBorder"><cfoutput>#dokument.nazwa2#</cfoutput></td>
							<td class="bottomBorder rightBorder"><cfoutput>#dokument.nip#</cfoutput></td>
						</tr>
					</tbody>
				</table>
				
			</div>
		</div> <!-- /end contentArea -->
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Nowy kontrahent</h3>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfform name="zmiana_kontrahenta_form"
						action="index.cfm?controller=documents&action=change-contractor" >
					
					<cfinput type="hidden" name="documentid" value="#dokument.documentid#" />
					
				<table class="uiTable aosTable nowyKontrahent">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">LOGO</th>
							<th colspan="4" class="topBorder rightBorder bottomBorder">
								<input type="text"
										name="logoKontrahenta"
										class="input"
										id="logoKontrahenta" />
							</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
				
				</cfform>
				
			</div>
		</div> <!-- /end contentArea -->
		
	</div>

</cfdiv>

<cfset ajaxOnLoad("zmianaKontrahenta") />