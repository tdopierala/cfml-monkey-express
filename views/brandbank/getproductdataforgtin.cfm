<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Pobierz informacje o produkcie</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="get_product_data_form" action="index.cfm?controller=brandbank&action=get-product-data-for-gtin">
				<ol class="horizontal">
					<li>
						<label for="ean">Kod EAN</label>
						<cfinput type="text" class="input" name="ean" />
					</li>
					<li>
						<cfinput type="submit" name="get_product_data_form_submit" 
								 class="admin_button green_admin_button" value="Pobierz" />
					</li>
				</ol>
			</cfform>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>