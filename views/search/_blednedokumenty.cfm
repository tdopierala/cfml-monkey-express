<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaRoot" >
		<cfinvokeargument name="groupname" value="root" />
	</cfinvoke>
</cfsilent>
	
<cfdiv id="search_workflow_cfdiv" >

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wyniki wyszukiwania dla błędnie wprowadzonych dokumentów</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent" id="uiSearch"></div>
	<div class="contentArea uiContent">
		
		<div class="search-result-summary">
			<p>Znaleziono <span class="strong"><cfoutput>#bledneDokumenty.RecordCount#</cfoutput></span> dokumentów pasujących do frazy: <span class="strong"><cfoutput>#search#</cfoutput></span></p>
		</div>
		
		<cfif bledneDokumenty.recordcount gt 0>
		
			<table class="search-result-table">
				<thead>
					<tr>
						<th class="th rt">L.p.</th>
						<th class="th rt" title="Numer faktury">
							<span>Nr faktury</span>
						</th>
						<th class="th rt" title="Nazwa kontrahenta">
							<span>Nazwa</span>
						</th>
						<th class="th rt" title="Data wystawienia">
							<span>Data zgłoszenia błędu</span>
						</th>
						<th class="th rt"><span>Powód odrzuenia</span></th>
						<th class="th">Opis</th>
						<th class="th" colspan="3"></th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfloop query="bledneDokumenty">
						<cfoutput>
	                    	<tr>
	                    		<td class="td bt aleft lp">#indeks#</td>
								<td class="td bt acenter nrfv">#numer_faktury#</td>
								<td class="td bt aleft">#nazwa1#</td>
								<td class="td bt acenter date">#DateFormat(created, 'yyyy/mm/dd')#</td>
								<td class="td bt aleft">
									<cfset powod = REReplace(reason, '<[^>]*>','','all') />
									<cfif Len(powod) GT 70>
										#Left(powod, 70)#...
									<cfelse>
										#powod#
									</cfif>
								</td>
								<td class="td bt aleft big">
									<cfset stepnote = REReplace(workflowstepnote,'<[^>]*>','','all') />
									<span class="tooltipshow" title="#stepnote#">
										<cfif Len(stepnote) gt 70>
											#Left(stepnote, 70)#...
										<cfelse>
											#stepnote#
										</cfif>
									</span>
								</td>
								<td class="td bt acenter short">
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=document_archives&action=restore&workflowid=#workflowid#&documentid=#documentid#', 'uiSearch')" class="icon-restore" title="Przywróć dokument">
										<img src="images/icon-restore.png" />
									</a>
								</td>
								<td class="td bt acenter short">
									<a class="" title="Pobierz fakturę pdf" href="#URLFor(controller="Document_archives",action="get-document",key=documentid)#" target="_blank">								
										#imageTag("file-pdf.png")#
									</a>
								</td>
							</tr>
	                    </cfoutput>
	                    <cfset indeks++ />
					</cfloop>
				</tbody>
			</table>
		
		<cfelse>
			
			<div class="search-result-info">
				<p>Nie znaleziono żadnych wyników wyszukiwania dla wpisanej frazy.</p>
			</div>
			
		</cfif>
		
		<div class="search-pagination-box">
			
		</div>

		<div class="uiFooter">

		</div>
	</div>
</div>

</cfdiv>
<script>
	<!---$(function(){
		
		$("#search_result_cfdiv").on("mouseenter", ".thsort", function(){
			var idx = $(this).index() + 1;
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$("#search_result_cfdiv").on("mouseleave", ".thsort", function(){
			var idx = $(this).index() + 1;
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
	});--->
</script>