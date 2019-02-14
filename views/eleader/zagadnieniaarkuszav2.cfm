<cfprocessingdirective pageencoding="utf-8" />

<tr class="expand-child">
	<td class="bottomBorder leftBorder">&nbsp;</td>
	<td colspan="5" class="bottomBorder rightBorder bialy">
		
		<!---<cfif notatka.recordCount GT 0>
			<div class="aosNotatkaDoArkusza">
			<a href="javascript:void(0)" onclick="podgladNotatkiDoArkusza(<cfoutput>#notatka.id#</cfoutput>)" title="Zobacz notatkę pokontrolną">Do tego AOS jest sporządzona notatka. Ocena wypadkowa: <span><cfoutput>#notatka.score#</cfoutput></span></a>
			</div>
		</cfif>--->
		
		<table class="uiTable">
			<thead>
				<tr>
					<th class="topBorder rightBorder bottomBorder leftBorder w24">&nbsp;</th>
					<th class="topBorder rightBorder bottomBorder">Nazwa zagadnienia</th>
					<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
					<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="zagadnienia">
					<tr class="<cfif uzyskane eq '' or uzyskane lt douzyskania> nie </cfif>" >
						<td class="leftBorder bottomBorder rightBorder">
							<a href="javascript:void(0)" class="extend" title="Pokaż odpowiedzi" onclick="pobierzOdpowiedziV2('#idaktywnosci#', '#zagadnienia.iddefinicjizadania#', $(this))"><span>&nbsp;</span></a>
						</td>
						<td class="bottomBorder rightBorder l">#nazwazadania#</td>
						<td class="bottomBorder rightBorder r">#iif(uzyskane eq '', 0, uzyskane)# / #iif(douzyskania eq '', 0, douzyskania)#</td>
						<td class="bottomBorder rightBorder r"></td>
					</tr>
				</cfoutput>
			</tbody>
		</table>
		
	</td>
</tr>