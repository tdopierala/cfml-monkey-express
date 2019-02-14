<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Raport obiegu dokumentów</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<cfform
			action="#URLFor(controller='invoiceReports',action='index')#"
			name="invoice_report_form"
			method="post"
			onsubmit="javascript:ColdFusion.navigate('#URLFor(controller='invoiceReports',action='index')#', false, null, 'POST', 'invoice_report_form');return false;" >
				
		<ul class="uiList uiForm">
			
			<li>
				<p>Data płatności</p>
				<cfinput
					type="text"
					name="invoice_payment_date_from"
					class="small_input date_picker"
					label="false"
					placeholder="od"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
				
				<cfinput
					type="text"
					name="invoice_payment_date_to"
					class="small_input date_picker leftSpace"
					label="false"
					placeholder="do"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
			</li>
			
			<li>
				<p>Data wpływu</p>
				<cfinput
					type="text"
					name="invoice_income_date_from"
					class="small_input date_picker"
					label="false"
					placeholder="od"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
				
				<cfinput
					type="text"
					name="invoice_income_date_to"
					class="small_input date_picker leftSpace"
					label="false"
					placeholder="do"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
			</li>
			
			<li>
				<p>Data sprzedaży</p>
				<cfinput
					type="text"
					name="invoice_sold_date_from"
					class="small_input date_picker"
					label="false"
					placeholder="od"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
				
				<cfinput
					type="text"
					name="invoice_sold_date_to"
					class="small_input date_picker leftSpace"
					label="false"
					placeholder="do"
					value="#DateFormat(Now(),'yyyy-mm-dd')#" />
			</li>
			
			<li>
				<p>Grupuj po kontrahencie</p>
				<cfinput
					type="radio" 
					name="group_by_contractor"
					value="true"
					checked="false" /> TAK
					
				<cfinput
					type="radio" 
					name="group_by_contractor"
					value="false"
					checked="true" /> NIE 
			</li>
			
			<li>
				<p>Eksportuj do pliku xls</p>
				<cfinput
					type="radio"
					name="invoice_export_to"
					value="xls"
					checked="true" /> <br />
					
				<p>Eksportuj do pliku csv</p>
				<cfinput
					type="radio"
					name="invoice_export_to"
					value="csv" />
			</li>
			
			<li>
				<cfinput
					type="submit"
					name="invoice_report_form_submit"
					value="Generuj"
					class="admin_button green_admin_button" />
			</li>
			
		</ul>
		
		</cfform>

		<div class="uiFooter">
			
		</div>
	</div>
</div>

<div class="footerArea">

</div>