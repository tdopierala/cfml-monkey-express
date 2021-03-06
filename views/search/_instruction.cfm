<cfdiv id="search_instruction_cfdiv" >

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wyniki wyszukiwania dla wewntrznych aktów prawnych</h3>
	</div>
</div>

		<cfif structKeyExists(session, "search_filter") 
			and structKeyExists(session.search_filter, "result_type")
			and session.search_filter.result_type eq 2>
			
			<cfset result_count = qISearchCount.a.c />
			<cfset result_count_q = qISearchCount.a />
			<cfset result_class = 'archive' />
		<cfelse>
			<cfset result_count = qISearchCount.c.c />
			<cfset result_count_q = qISearchCount.c />
			<cfset result_class = '' />
		</cfif>

<div class="contentArea searchResultArea <cfoutput>#result_class#</cfoutput>">
	<div class="contentArea uiContent">
		
		<cfif structKeyExists(session, "search_filter") 
			and structKeyExists(session.search_filter, "order")
			and session.search_filter.order eq 'desc'>
				
			<cfset _order = 'asc' />
			<cfset _order_label = 'rosnąco' />
		<cfelse>
			<cfset _order = 'desc' />
			<cfset _order_label = 'malejąco' />
		</cfif>
		
		<cfoutput>
			<div class="search-result-summary">			
            	<div class="search-result-desc">
            		Znaleziono <span class="strong">#qISearchCount.c.c#</span> obowiązujących 
					oraz <span class="strong">#qISearchCount.a.c#</span> archiwalnych aktów prawnych 
					pasujących do frazy: <span class="strong">"#search#"</span>
				</div>
				<div class="search-result-subdesc">
					<cfif StructKeyExists(result_count_q, 'i')>
						Instruckji: #result_count_q.i#,
					</cfif> 
					
					<cfif StructKeyExists(result_count_q, 'w')>
						Wytycznych: #result_count_q.w#,
					</cfif>
					
					<cfif StructKeyExists(result_count_q, 'r')>
						Rozporządzeń: #result_count_q.r#
					</cfif>
				</div>
				
				<cfif qISearchCount.c.c gt 0>
					<cfif structKeyExists(session, "search_filter") 
						and structKeyExists(session.search_filter, "result_type")
						and session.search_filter.result_type eq 2>
						
						<div id="search-archiv-button">
							<a 
								class="searchparamlink navigate" 
								data-container = "search_instruction_cfdiv" 
								href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#&result_type=1')#">
									
									Zobacz dokumenty aktualnie obowiązujące pasujące do: <span class="strong">"#search#"</span>
							</a>
						</div>
						
					<cfelse>
						
						<div id="search-archiv-button">
							<a 
								class="searchparamlink navigate" 
								data-container = "search_instruction_cfdiv" 
								href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#&result_type=2')#">
									
									Zobacz archiwalne Akty prawne (#qISearchCount.a.c#) dla frazy: <span class="strong">"#search#"</span><br />
									<!---<div class="search-result-subdesc">
										<cfif StructKeyExists(qISearchCount.a, 'i')>
											Instruckji: #qISearchCount.a.i#,
										</cfif> 
										
										<cfif StructKeyExists(qISearchCount.a, 'w')>
											Wytycznych: #qISearchCount.a.w#,
										</cfif>
										
										<cfif StructKeyExists(qISearchCount.a, 'r')>
											Rozporządzeń: #qISearchCount.a.r#
										</cfif>
									</div>--->
							</a>
						</div>
					
					</cfif>
				</cfif>
				
			</div>
		</cfoutput>
		
		<cfif qISearch.recordcount gt 0>
			
			<table class="search-result-table">
				
				<cfif session.search_filter.result_type eq 2>
					<caption>Archiwalne Akty prawne</caption>
				</cfif>
				
				<thead>
					<tr>
						<th class="th rt">
							<span>L.p.</span>
						</th>
						<th class="th rt thsort aleft" title="Typ dokumentu">
							<span>Typ</span>
							<cfoutput>
	                        	<a 
									class = "searchparamlink navigate" 
									title = "Sortuj #_order_label#" 
									data-container = "search_instruction_cfdiv" 
									href = "#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=documenttypename&order=#_order#')#">								
										
										<cfif instruction_order eq 'documenttypename'>
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
						<th class="th rt thsort" title="Nr dokumentu">
							<span>Nr dokumentu</span>
							<cfoutput>
	                        	<a 
									class = "searchparamlink navigate" 
									title = "Sortuj #_order_label#" 
									data-container="search_instruction_cfdiv" 
									href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=instruction_number&order=#_order#')#">								
									
										<cfif instruction_order eq 'instruction_number'>
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
						<th class="th rt thsort acenter" title="Data publikacji">
							<span>Data</span>
							<cfoutput>
	                        	<a 
									class="searchparamlink navigate"
									title="Sortuj #_order_label#"
									data-container="search_instruction_cfdiv"
									href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=instruction_date_from&order=#_order#')#">								
									
										<cfif instruction_order eq 'instruction_date_from'>
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
						<th class="th rt thsort" title="Departament">
							<span>Depart.</span>
							<cfoutput>
	                        	<a 
									class="searchparamlink navigate"
									title="Sortuj #_order_label#"
									data-container="search_instruction_cfdiv"
									href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=1&elements=#session.search_filter.elements#&instruction_order=department_name&order=#_order#')#">								
									
										<cfif instruction_order eq 'department_name'>
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
						<th class="th ">
							<span>Opis</span>
						</th>
						<th class="th " colspan="3"></th>
					</tr>
				</thead>
				<tbody>
					<cfset loop_counter=(instruction_page-1)*elements />
					<cfloop query="qISearch">
					
						<cfset loop_counter++ />				
						<cfoutput>                	
							<tr>
								<td class="td bt aleft lp">#loop_counter#</td>
								<td class="td bt aleft dtype">#documenttypename#</td>
								<td class="td bt aleft inum">
									<cfset inumber = REReplace(instruction_number,'<[^>]*>','','all') />
									<span class="tooltipshow" title="#inumber#">
										<cfif Len(inumber) gt 20>
											#Left(inumber, 20)#...
										<cfelse>
											#inumber#
										</cfif>
									</span>
								</td>
								<td class="td bt acenter date">#DateFormat(instruction_date_from, "yyyy-mm-dd")#</td>
								<td class="td bt aleft td70">									
									#department_name#
								</td>
								<td class="td bt aleft desc">
									
									<cfscript>
										iabout = REReplace(instruction_about,'<[^>]*>','','all');
										
										_iabout = REReplace(iabout,"\s\s", " ", "all");
										while(_iabout != iabout) {
  											iabout = _iabout;
  											_iabout = REReplace(iabout,"\s\s", " ", "all");
										} 
									</cfscript>
									
									<span class="tooltipshow" title="#iabout#">
										<cfif Len(iabout) gt 65>
											#Left(iabout, 65)#...
										<cfelse>
											#iabout#
										</cfif>
									</span>
								</td>
								
								<td class="td bt acenter">
									#linkTo(
										text = imageTag("search_view.png"),
										controller = "Instructions",
										action = "preview",
										key = instruction_id,
										title = "Podgląd dokumentu",
										target="_blank")#
								</td>
								
								<td class="td bt acenter">
									#linkTo(
										text = imageTag("search_download.png"),
										controller = "Instructions",
										action = "view",
										key = instruction_id,
										title = "Pobranie dokumentu")#
								</td>
								
								<td class="td bt acenter">
									<cfif Len(instruction_view)>
										#imageTag(source="yes.png", alt="Dokument przeczytany #DateFormat(instruction_view,'yyyy-mm-dd')#", title="Dokument przeczytany #DateFormat(instruction_view,'yyyy-mm-dd')#")#
									<cfelse>
										#imageTag(source="yes.png", class="hidde")#
									</cfif>
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
			<cfif result_count gt elements>
				
				<cfset pages = Ceiling(result_count / session.search_filter.elements) />
				
				<cfif instruction_page gt 1>
					<cfoutput>
                    	<a 
							class="paginationlink navigate"
							title="poprzednia strona"
							data-container="search_instruction_cfdiv"
							href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=#instruction_page-1#&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#')#">								
							
							&laquo;
						</a>
                    </cfoutput>
				</cfif>
		
				<cfloop index="idx" from="1" to="#pages#">
					
					<cfif idx gt instruction_page - 5 and idx lt instruction_page + 5>
						<cfif idx eq instruction_page>
							<cfoutput>
		                       	<a 
									class="paginationlink selected navigate" 
									title="nastepna strona"
									data-container="search_instruction_cfdiv"
									href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=#idx#&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#')#">								
									
									#idx#
								</a>
							</cfoutput>
						<cfelse>
							<cfoutput>
		                       	<a 
									class="paginationlink navigate" 
									title="nastepna strona"
									data-container="search_instruction_cfdiv"
									href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=#idx#&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#')#">								
									
									#idx#
								</a>
							</cfoutput>
						</cfif>
					</cfif>
					
				</cfloop>
				
				<cfif instruction_page lt pages>
					<cfoutput>
                       	<a 
							class="paginationlink navigate" 
							title="nastepna strona"
							data-container="search_instruction_cfdiv"
							href="#URLFor(controller='Search', action='findInstruction', params='instruction_page=#instruction_page+1#&elements=#session.search_filter.elements#&instruction_order=#instruction_order#&order=#session.search_filter.order#')#">								
							
							&raquo;
						</a>
					</cfoutput>
				</cfif>
				
			</cfif>
		</div>

	</div>
</div>

<!---<cfif session.user.id eq 345>
	<cfdump var="#qISearch#" />
	<cfdump var="#qISearchCount#" />
</cfif>--->

</cfdiv>
<script>
	$(function(){
		//$(".tooltipshow").tooltip();
		
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