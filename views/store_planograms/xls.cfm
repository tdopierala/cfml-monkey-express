<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Plik Excel z TOTAL UNITS</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfif IsDefined("newTotalUnitFile")>
				<div class="uiMessage <cfif newTotalUnitFile.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
					<cfoutput>#newTotalUnitFile.message#</cfoutput>
				</div>
			</cfif>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="store_planogram_excel_form" action="index.cfm?controller=store_planograms&action=xls"
					enctype="multipart/form-data">
				
				<cfinput type="hidden" name="storetypeid" value="#storetypeid#" />
				<cfinput type="hidden" name="shelftypeid" value="#shelftypeid#" />
				<cfinput type="hidden" name="shelfcategoryid" value="#shelfcategoryid#" />
				<cfinput type="hidden" name="planogramid" value="#planogramid#" />
				
				<ol class="horizontal">
					<li>
						<label for="xlsfile">Plik Excel z TOTAL UNITS</label>
						<cfinput type="file" name="xlsfile" id="xlsfile"
								 onchange="checkFileExcel(this);" />
					</li>
					<li>
						<cfinput type="submit" name="store_planogram_excel_form_submit"
								 class="admin_button green_admin_button" value="Zapisz" />
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

<script>
	function checkFileExcel(sender) { 
	var validExts = new Array(".xlsx", ".xls");
	var fileExt = sender.value;
	fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
	if (validExts.indexOf(fileExt) < 0) {
		alert("Wybrany plik jest niewłaściwego formatu! Dostępne formaty: " + validExts.toString() + ".");
		return false;
	}
	else return true;
}
</script>