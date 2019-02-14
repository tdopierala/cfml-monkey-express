<cfdiv id="search_workflow_cfdiv" >

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wyniki wyszukiwania dla obiegu dokumentów</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<div class="search-result-summary">
			<p>Znaleziono <span class="strong"><cfoutput>#qWSearchCount.c#</cfoutput></span> dokumentów pasujących do frazy: <span class="strong"><cfoutput>#search#</cfoutput></span></p>
		</div>
		
		<cfif session.search_filter.order eq 'desc'>
			<cfset _order = 'asc' />
			<cfset _order_label = 'rosnąco' />
		<cfelse>
			<cfset _order = 'desc' />
			<cfset _order_label = 'malejąco' />
		</cfif>
		
		<cfif qWSearch.recordcount gt 0>
		
			<table class="search-result-table">
				<thead>
					<tr>
						<th class="th rt">L.p.</th>
						<th class="th rt thsort" title="Numer faktury">
							<span>Nr faktury</span>
							<cfoutput>
	                        	<a 
									class="searchparamlink navigate" 
									title="Sortuj #_order_label#"
									data-container = "search_workflow_cfdiv"  
									href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=1&elements=#session.search_filter.elements#&workflow_order=numer_faktury&order=#_order#')#">								
										
										<cfif workflow_order eq 'numer_faktury'>
											<cfif _order eq 'asc'>
												#imageTag("sort-asc.png")#
											<cfelse>
												#imageTag("sort-desc.png")#
											</cfif>
										<cfelse>
											#imageTag("sort-asc-desc.png")#
										</cfif>	
								</a>
	                        </cfoutput>
						</th>
						<th class="th rt thsort" title="Nazwa kontrahenta">
							<span>Nazwa</span>
							<cfoutput>
	                        	<a 
									class="searchparamlink navigate" 
									title="Sortuj #_order_label#" 
									data-container = "search_workflow_cfdiv"  
									href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=1&elements=#session.search_filter.elements#&workflow_order=nazwa1&order=#_order#')#">								
										
										<cfif workflow_order eq 'nazwa1'>
											<cfif _order eq 'asc'>
												#imageTag("sort-asc.png")#
											<cfelse>
												#imageTag("sort-desc.png")#
											</cfif>
										<cfelse>
											#imageTag("sort-asc-desc.png")#
										</cfif>	
								</a>
	                        </cfoutput>
						</th>
						<th class="th rt thsort" title="Data wystawienia">
							<span>Data</span>
							<cfoutput>
	                        	<a 
									class="searchparamlink navigate" 
									title="Sortuj #_order_label#" 
									data-container = "search_workflow_cfdiv"  
									href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=1&elements=#session.search_filter.elements#&workflow_order=data_wystawienia&order=#_order#')#">								
										
										<cfif workflow_order eq 'data_wystawienia'>
											<cfif _order eq 'asc'>
												#imageTag("sort-asc.png")#
											<cfelse>
												#imageTag("sort-desc.png")#
											</cfif>
										<cfelse>
											#imageTag("sort-asc-desc.png")#
										</cfif>	
								</a>
	                        </cfoutput>
						</th>
						<th class="th">Opis</th>
						<th class="th" colspan="3"></th>
					</tr>
				</thead>
				<tbody>
					<cfset loop_counter=(workflow_page-1)*elements />
					<cfloop query="qWSearch">
						<cfif todelete eq 1>
							<cfset class='deleteWorkflow'/>
						<cfelseif to_archive eq 1>
							<cfset class='archiveWorkflow'/>
						<cfelse>
							<cfset class=''/>
						</cfif>
						<cfset loop_counter++ />
						<cfoutput>
	                    	<tr class="#class#">
	                    		<td class="td bt aleft lp">#loop_counter#</td>
								<td class="td bt acenter nrfv">#numer_faktury#</td>
								<td class="td bt aleft big">#nazwa1#</td>
								<td class="td bt acenter date">#DateFormat(data_wystawienia,'yyyy-mm-dd')#</td>
								<td class="td bt aleft desc2">
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
									<cfif Len( workflowid )>
									<a class="navigateout" title="Podgląd dokumentu" href="javascript:ColdFusion.navigate('#URLFor(controller="Workflows",action="edit",key=workflowid)#', 'intranet_left_content')">								
										#imageTag("search_view.png")#
									</a>
									</cfif>
								</td>
								<td class="td bt acenter short">
									<a class="" title="Pobierz fakturę pdf" href="#URLFor(controller="Documents",action="get-document",key=documentid)#" target="_blank">								
										#imageTag("file-pdf.png")#
									</a>
								</td>
							</tr>
	                    </cfoutput>
					</cfloop>
				</tbody>
			</table>
		
		<cfelse>
			
			<div class="search-result-info">
				<p>Nie znaleziono żadnych wyników wyszukiwania dla wpisanej frazy.</p>
			</div>
			
		</cfif>
		
		<div class="search-pagination-box">
			<cfif qWSearchCount.c gt elements>
				
				<cfset pages = Ceiling(qWSearchCount.c / session.search_filter.elements) />
				
				<cfif workflow_page gt 1>
					<cfoutput>
                    	<a 
							class="paginationlink navigate" 
							title="poprzednia strona"
							data-container = "search_workflow_cfdiv"   
							href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=#workflow_page-1#&elements=#session.search_filter.elements#&workflow_order=#workflow_order#&order=#session.search_filter.order#')#">								
								
								&laquo;
						</a>
                    </cfoutput>
				</cfif>
		
				<cfloop index="idx" from="1" to="#pages#">
					
					<cfif idx gt workflow_page - 4 and idx lt workflow_page + 4>
						<cfif idx eq workflow_page>
							<cfoutput>
		                       	<a 
									class="paginationlink selected navigate" 
									title="nastepna strona"
									data-container = "search_workflow_cfdiv" 
									href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=#idx#&elements=#session.search_filter.elements#&workflow_order=#workflow_order#&order=#session.search_filter.order#')#">								
										
										#idx#
								</a>
							</cfoutput>
						<cfelse>
							<cfoutput>
		                       	<a 
									class="paginationlink navigate" 
									title="nastepna strona" 
									data-container = "search_workflow_cfdiv"
									href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=#idx#&elements=#session.search_filter.elements#&workflow_order=#workflow_order#&order=#session.search_filter.order#')#">								
										
										#idx#
								</a>
							</cfoutput>
						</cfif>
					</cfif>
					
				</cfloop>
				
				<cfif workflow_page lt pages>
					<cfoutput>
                       	<a 
							class="paginationlink navigate" 
							title="nastepna strona"
							data-container = "search_workflow_cfdiv"
							href="#URLFor(controller='Search', action='findWorkflow', params='workflow_page=#workflow_page+1#&elements=#session.search_filter.elements#&workflow_order=#workflow_order#&order=#session.search_filter.order#')#">								
								
								&raquo;
						</a>
					</cfoutput>
				</cfif>
				
			</cfif>
		</div>

		<!---<div class="uiFooter">

			<cfset paginator = 1 />
			<cfset pages = Ceiling(qWSearchCount.c / session.search_filter.elements) />

			<cfloop condition="paginator LESS THAN OR EQUAL TO pages" >

				<a
						href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Search',action='findWorkflow',params='workflow_page=#paginator#&elements=#session.search_filter.elements#')#</cfoutput>', 'search_workflow_cfdiv');"
					title="#paginator#"
					class="uiPaginatorLink clearfix <cfif paginator eq session.search_filter.workflow_page> active </cfif>">
						<span class="uiListItemLabel">
							<cfoutput>#paginator#</cfoutput>
						</span>
					</a>
				<cfset paginator++ />

			</cfloop>

		</div>--->
	</div>
</div>

<!---<div class="footerArea">
	<cfdump var="#workflow_page#" />
</div>--->

</cfdiv>
<script>
	$(function(){
		
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
	});
</script>