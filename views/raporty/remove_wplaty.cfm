<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">
	<cfdiv id="raportWplat">
		
		<div class="leftWrapper">
			
			<div class="headerArea">
				<div class="headerArea uiHeader">
					<h3 class="uiHeaderTitle">Szczegóły raportu wpłat</h3>
				</div>
			</div>
			
			<div class="headerNavArea">
				<div class="headerNavArea uiHeaderNavArea">
					<cfform name="raport_wplat_form" action="index.cfm?controller=raporty&action=wplaty&t=true" >
						
						<ol class="filters" style="height: 27px;">
							<li>
								<cfinput type="datefield" 
									 name="data" 
									 class="input"
									 placeholder="Data raportu"
									 validate="eurodate" 
									 mask="yyyy-mm-dd"
									 value="#DateFormat(session.raporty.wplaty.data,"yyyy-mm-dd")#" />
							</li>
							<li>
								<cfinput type="submit" name="raport_wplat_form_submit" 
										 class="admin_button green_admin_button" value="Filtruj" />
							</li>
						</ol>
						
					</cfform>
				</div>
			</div>
		
			<div class="contentArea">
				<div class="contentArea uiContent">
					
					<a class="admin_button green_admin_button fr" href="index.cfm?controller=raporty&action=wplaty&format=xls" target="_blank">Eksportuj tabelę do Excela</a>
					
					<table class="uiTable">
						<thead>
							<tr>
								<th class="bottomBorder noBg">&nbsp;</th>
								<th class="topBorder rightBorder bottomBorder leftBorder">Sprzedaż CL</th>
								<th class="topBorder rightBorder bottomBorder">Sprzedaż elektroniczna</th>
								<th class="topBorder rightBorder bottomBorder">Kwota zwrotu</th>
								<th class="topBorder rightBorder bottomBorder">Karty elektroniczne</th>
							</tr>
						</thead>
						<tbody>
							<cfoutput query="raport">
								<tr>
									<th class="leftBorder bottomBorder headerBg">#location_number#</th>
									<td class="bottomBorder leftBorder rightBorder r">#products_sale_amount#</td>
									<td class="bottomBorder rightBorder r">
										<cfset sumaElektroniczna = 	electronic_sale_type_1_amount+electronic_sale_type_2_amount+electronic_sale_type_3_amount+electronic_sale_type_4_amount+electronic_sale_type_5_amount />
										#NumberFormat(sumaElektroniczna, "0.00")#
									</td>
									<td class="bottomBorder rightBorder r">
										-#promo_discount_amount#
									</td>
									<td class="bottomBorder rightBorder r">
										-#electronic_payment_amount#
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
</cfdiv>