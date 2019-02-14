<cfsilent>

	<cfquery name="listaKandydatow" dbtype="query">
		select * 
		from formularze, uzytkownicy
		where formularze.userid = uzytkownicy.id
	</cfquery>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Lista kandydatów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="topBorder rightBorder bottomBorder leftBorder">#</th>
						<th class="topBorder rightBorder bottomBorder">Rekruter</th>
						<th class="topBorder rightBorder bottomBorder">Data dodania formularza</th>
						<th class="topBorder rightBorder bottomBorder">Status</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="listaKandydatow">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">#idFormularza#</td>
							<td class="bottomBorder rightBorder l">#givenname# #sn#</td>
							<td class="bottomBorder rightBorder r">#DateFormat(dataUtworzenia, "yyyy/mm/dd")#</td>
							<td class="bottomBorder rightBorder r">#idStatusuRekrutacji#</td>
							<td class="bottomBorder rightBorder">
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=edytuj-formularz&idFormularza=#idFormularza#', 'rekrutacja_rekrutacja')" class="icon-edit" title="Edytuj formularz"><span>Edytuj formularz</span></a>
								
								<a href="index.cfm?controller=rekrutacja_rekrutacja&action=podsumowanie-formularza&idFormularza=#idFormularza#" class="icon-pdf" title="Podsumowanie formularza" target="blank"><span>Podsumowanie formularza</span></a>
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
