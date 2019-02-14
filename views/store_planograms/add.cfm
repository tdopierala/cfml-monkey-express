<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Nowy planogram</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif IsDefined("newTotalUnitFile")>
				<div class="<cfif newTotalUnitFile.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>"><cfoutput>#newTotalUnitFile.message#</cfoutput></div>
			</cfif>
			
			<cfif IsDefined("totalUnitValue")>
				<div class="<cfif totalUnitValue.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>"><cfoutput>#totalUnitValue.message#</cfoutput></div>
			</cfif>
			
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
				
			<cfform name="add_store_planogram_form" action="index.cfm?controller=store_planograms&action=add"
					enctype="multipart/form-data" >
						
				<cfinput type="hidden" name="storetypeid" value="#storetypeid#" />
				<cfinput type="hidden" name="shelfcategoryid" value="#shelfcategoryid#" />
				<cfinput type="hidden" name="shelftypeid" value="#shelftypeid#" /> 
		
				<ol class="horizontal">
					
					<li>
						<label for="date_from">Data obowiązywania od</label>
						<div class="uiFormElement">
							<cfinput type="dateField" name="date_from" class="input"
								 validate="eurodate" value="#DateFormat(now(),"dd/mm/yyyy")#" mask="dd/mm/yyyy" />
						</div>
					</li>
					<li>
						<label for="index_count">Ilość indeksów</label>
						<cfinput type="text" name="index_count" class="input" value="0" />
					</li>
					<li>
						<label for="note">Uwagi</label>
						<cftextarea name="note" class="textarea ckeditor">
						</cftextarea>
					</li>
					<li>
						<label for="file">Plik z planogramem</label>
						<cfinput type="file" name="file0"
								 onchange="checkFilePdf(this);" /> <span class="add_file">+</span>
					</li>
					<li>
						<label for="total_units_file">Plik Excel z TOTAL UNITS</label>
						<cfinput type="file" name="total_units_file"
								 onchange="checkFileExcel(this);" />
					</li>
					<li class="last">
						<cfinput type="submit" name="add_store_planogram_form_submit" 
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

function checkFilePdf(sender) { 
	var validExts = new Array(".pdf");
	var fileExt = sender.value;
	fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
	if (validExts.indexOf(fileExt) < 0) {
		alert("Wybrany plik jest niewłaściwego formatu! Dostępne formaty: " + validExts.toString() + ".");
		return false;
	}
	else return true;
}
</script>