<cfsilent>
	
	<cfquery name="raportPoUzytkownikach" dbtype="query" >
		select * 
		from raport, uzytkownicy
		where raport.userid = uzytkownicy.id;
	</cfquery>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />


<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Ilość osób zaproszonych na rozmowy</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<td class="bottomBorder" colspan="2"></td>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="raportPoUzytkownikach">
					<tr>
						<td class="leftBorder bottomBorder rightBorder b" colspan="2">#givenname# #sn#</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość osób zaproszonych na rozmowy (TAK+NIE)</td>
						<td class="bottomBorder rightBorder r">#iif(Len(tak) EQ 0, 0, tak)+iif(Len(nie) EQ 0, 0, nie)#</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Brak decyzji</td>
						<td class="bottomBorder rightBorder r">#brakDecyzji#</td>
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
