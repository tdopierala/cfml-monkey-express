<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raport z ilości palet</h3>
		</div>
	</div>

	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<div class="workflow_filter_div">
				<cfform name="sms_notice_pallets_form"
						action="#URLFor(controller='SmsNotice',action='pallets')#" >
					<table class="workflow_filter_table">
						<tbody>
							<tr>
								<td class="label_column">Rok</td>
								<td class="value_column">
									<select id="year" name="year">
										<cfloop collection="#years#" item="year" ><cfoutput>
											<option value="#year#" <cfif year eq session.sms_notice.year> selected</cfif>>#years[year]#</option>
										</cfoutput></cfloop>
									</select>
								</td>
								<td class="label_column">Miesiąc</td>
								<td class="value_column">
									<select id="month" name="month">
										<cfset index = 1 />
										<cfloop array="#months#" index="i" ><cfoutput>
											<option value="#index#" <cfif index eq session.sms_notice.month> selected</cfif>>#i#</option>
										<cfset index++ />
										</cfoutput></cfloop>
									</select>
								</td>
								<td class="label_column">
									<cfinput type="submit"
											 value="Filtruj"
											 class="admin_button green_admin_button"
											 name="sms_notice_pallets_form_submit" />
								</td>
							</tr>
						</tbody>
					</table>	
				</cfform>
			</div>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
						<th class="rightBorder topBorder bottomBorder">Sklep</th>
						<th class="rightBorder topBorder bottomBorder">Miesiąc / Rok</th>
						<th class="rightBorder topBorder bottomBorder">Ilość</th>
					</tr>
				</thead>
				<tbody>
					<cfset lp = 1 />
					<cfoutput query="pallets">
						<tr>
							<td class="leftBorder rightBorder bottomBorder">#lp#</td>
							<td class="rightBorder bottomBorder">#sklep#</td>
							<td class="rightBorder bottomBorder">#m# / #y#</td>
							<td class="rightBorder bottomBorder">#sum_pallets#</td>
						</tr>
					<cfset lp = lp + 1 />
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