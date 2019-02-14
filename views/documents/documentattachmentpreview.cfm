<cfprocessingdirective pageencoding="utf-8" />

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Podgląd załącznika</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<cfif IsDefined("excelQueryData")>
			
		<table class="uiTable aosTable">
			<tbody>
				<tr>
					<td colspan="<cfoutput>#ListLen(excelQueryData.ColumnList)+1#</cfoutput>" class="bottomBorder">&nbsp;</td>
				</tr>
				<cfset queryIndex = 1 />
				<cfloop query="excelQueryData">
					<tr>
						<td class="leftBorder bottomBorder rightBorder">
							<cfoutput>#queryIndex#</cfoutput>
						</td>
						<cfloop list="#excelQueryData.ColumnList#" index="element" >
							<td class="bottomBorder rightBorder">
								<cfoutput>#excelQueryData["#element#"][queryIndex]#</cfoutput>
							</td>
							<!---<td class="bottomBorder rightBorder">#COL_2#</td>
							<td class="bottomBorder rightBorder">#COL_3#</td>
							<td class="bottomBorder rightBorder">#COL_4#</td>
							<td class="bottomBorder rightBorder">#COL_5#</td>
							<td class="bottomBorder rightBorder">#COL_6#</td>
							<td class="bottomBorder rightBorder">#COL_7#</td>--->
						</cfloop>
					</tr>
					<cfset queryIndex++ />
				</cfloop>
			</tbody>
		</table>
		
		<cfelse>
			
			Plik jest w niewłaściwym formacie lub jest pusty
			
		</cfif>
	</div>
</div> <!-- /end contentArea -->
		