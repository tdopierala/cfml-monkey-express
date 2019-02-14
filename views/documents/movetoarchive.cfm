<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="moveToArchive">
<div class="leftWrapper" style="padding:0;">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Przenieś do archiwum</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfif IsDefined("results")>
				Dokument został oznaczony do przeniesienia do archiwum. 
				Przeniesienie do archiwum odbywa się cyklicznie raz na dobę w 
				godzinach nocnych.
				
			</cfif>
				
			<cfform action="index.cfm?controller=documents&action=move-to-archive&documentid=#documentid#"
				name="move_to_archive_form"
				onsubmit="javascript:$('##reason').val(CKEDITOR.instances['reason'].getData())" >
				
				<cfinput type="hidden" name="documentid" value="#documentid#" />
					
				<table class="uiTable aosTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Komentarz</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="leftBorder rightBorder bottomBorder">
								<cftextarea 
									name="reason"
									class="textarea" >
													
								</cftextarea>
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<th colspan="2" class="leftBorder bottomBorder rightBorder">
								<cfinput type="submit" name="move_to_archive_form_submit" 
										 class="admin_button green_admin_button"
										 value="Zapisz" />
							</th>
						</tr>
					</tfoot>
				</table>
					
			</cfform>
				
			<div class="uiFooter">
				
			</div> <!-- /end uiFooter -->
		</div>
	</div> <!-- /end contentArea -->

	<div class="footerArea">
	</div>
</div>
</cfdiv>

<cfset ajaxOnLoad("initArchiveEditor") />