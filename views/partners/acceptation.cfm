<cfsilent>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Akceptacja nieobecności partnerów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Imię i nazwisko</th>
						<th class="topBorder rightBorder bottomBorder">W dniach</th>
						<th class="topBorder rightBorder bottomBorder">Złożono</th>
						<th class="topBorder rightBorder bottomBorder">Uwagi</th>
						<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="nieobecnosci">
						<tr>
							<td class="leftBorder bottomBorder rightBorder l">#givenname# #sn#</td>
							<td class="bottomBorder rightBorder r">#DateFormat(absence_from, "yyyy/mm/dd")# - #DateFormat(absence_to, "yyyy/mm/dd")#</td>
							<td class="bottomBorder rightBorder r">#DateFormat(created, "yyyy/mm/dd HH:mm")#</td>
							<td class="bottomBorder rightBorder l">#note#</td>
							<td class="bottomBorder rightBorder">
								<a href="javascript:void(0)" onclick="acceptAbsence(#absenceid#, $(this))" class="accept" title="Akceptuje"><span>Akceptuje</span></a>
								<a href="javascript:void(0)" onclick="DeclineAbsence(#absenceid#, $(this))" class="decline" title="Odrzucam"><span>Odrzucam</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">

	</div>

</div>
</cfdiv>
