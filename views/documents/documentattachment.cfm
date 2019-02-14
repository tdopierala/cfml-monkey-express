<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper" style="padding:0;">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Załączniki do faktury</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Data</th>
						<th class="topBorder rightBorder bottomBorder">Użytkownik</th>
						<th class="topBorder bottomBorder">Komentarz</th>
						<th class="topBorder bottomBorder rightBorder">&nbsp;</th>
					</tr>
				</thead>
				<tbody>

					<cfoutput query="pliki">
						<tr>
							<td class="leftBorder bottomBorder rightBorder r">#DateFormat(data_dodania, "yyyy/mm/dd")#</td>
							<td class="bottomBorder rightBorder l">#givenname# #sn#</td>
							<td class="bottomBorder l">
								<cfset nazwaMiniaturki = listToArray(file_src, ".") />
								<cfif fileExists(expandPath("files/attachments/thumb_#nazwaMiniaturki[1]#.png"))>
									<cfimage action="writeToBrowser" source="#expandPath("files/attachments/thumb_#nazwaMiniaturki[1]#.png")#" />
								</cfif>
								#komentarz#
							</td>
							<td class="bottomBorder rightBorder r">
								<a href="files/attachments/#file_src#" target="_blank" title="Pobierz plik" class="download_file_20x20"><span>Pobierz plik</span></a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=documents&action=document-attachment-preview&fileid=#document_file_id#', 'document_attachment_preview');" title="Podejrzyj plik" class="preview_file_20x20"><span>Podejrzyj plik</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">&nbsp;</td>
						<th class="leftBorder bottomBorder rightBorder">
							<a href="javascript:void(0);" onclick="initCfWindow('index.cfm?controller=documents&action=iframe&documentid=<cfoutput>#documentid#</cfoutput>', <cfoutput>#documentid#</cfoutput>)" class="zalacznikDoFakturyLink" title="Dodaj załącznik do faktury">
								<span>Dodaj załącznik</span>
							</a>
						</th>
					</tr>
				</tfoot>
			</table>
			
			<div class="uiFooter">
				
			</div> <!-- /end uiFooter -->
		</div>
	</div> <!-- /end contentArea -->
	
	<div id="document_attachment_preview"></div>

	<div class="footerArea">
	</div>

</div>