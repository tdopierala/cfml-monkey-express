<cfdiv id="search_user_cfdiv" >

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wyniki wyszukiwania użytkowników</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<div class="search-result-summary">
			<cfoutput>
            	
				<p>Znaleziono <span class="strong">#qUSearchCount#</span> pracowników centrali
				oraz <span class="strong">#qUSearchCountP#</span> partnerów 
				pasujących do frazy: <span class="strong">#search#</span></p>
				
							<!---<div id="search-archiv-button">
								<a 
									class="searchparamlink navigate" 
									data-container = "search_user_cfdiv" 
									href="#URLFor(controller='Search', action='findUsers', params='user_page=1&elements=#session.search_filter.elements#&user_order=#user_order#&order=asc&result_type=8')#">
										
										Wyszukaj partnerów pasujących do: <span class="strong">"#search#"</span>
								</a>
							</div>--->
				
            </cfoutput>
		</div>
		
		<cfif structKeyExists(session, "search_filter") 
			and structKeyExists(session.search_filter, "order")
			and session.search_filter.order eq 'desc'>
				
			<cfset _order = 'asc' />
			<cfset _order_label = 'rosnąco' />
		<cfelse>
			<cfset _order = 'desc' />
			<cfset _order_label = 'malejąco' />
		</cfif>
		
		<cfif qUSearch.recordcount gt 0>
		
			<table class="search-result-table">
				
				<thead>
					<tr>
						<th class="th rt">L.p.</th>
						<th class="th rt">Zdjęcie</th>
						<th class="th rt thsort tooltp" title="Imię i nazwisko">
							<span>Imię i nazwisko</span>
							<cfoutput>
	                        	<a 
									class = "searchparamlink navigate tooltp" 
									title = "Sortuj #_order_label#" 
									data-container = "search_user_cfdiv" 
									href = "#URLFor(controller='Search', action='findUsers', params='user_page=1&elements=#session.search_filter.elements#&user_order=sn&order=#_order#')#">								
										
										<cfif user_order eq 'sn'>
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
						<th class="th rt thsort tooltp" title="Stanowisko">
							<span>Stanowisko</span>
							<cfoutput>
	                        	<a 
									class = "searchparamlink navigate tooltp" 
									title = "Sortuj #_order_label#" 
									data-container = "search_user_cfdiv" 
									href = "#URLFor(controller='Search', action='findUsers', params='user_page=1&elements=#session.search_filter.elements#&user_order=position&order=#_order#')#">								
										
										<cfif user_order eq 'position'>
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
						<th class="th rt thsort tooltp" title="Departament">
							<span>Departament</span>
							<cfoutput>
	                        	<a 
									class = "searchparamlink navigate tooltp" 
									title = "Sortuj #_order_label#" 
									data-container = "search_user_cfdiv" 
									href = "#URLFor(controller='Search', action='findUsers', params='user_page=1&elements=#session.search_filter.elements#&user_order=departmentname&order=#_order#')#">								
										
										<cfif user_order eq 'departmentname'>
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
						<th class="th rt">Telefon</th>
						<th class="th ">Email</th>
					</tr>
				</thead>
				
				<tbody>
					<cfset loop_counter=(user_page-1)*elements />
					<cfloop query="qUSearch">
						<cfset loop_counter++ />
						<cfoutput>
	                    	<tr>
								<td class="td bt aleft lp">#loop_counter#</td>
								<td class="td bt acenter photo" data-id="#id#">
									<!---<span class="uiListItemContent thumbnail">
										<span class="uiListItemContent avatar">
											<span class="uiListItemContent avatar container">--->
											
										<cfif fileExists(expandPath("images/avatars/thumbnail/#photo#"))>
											<div class="userAvatar" style="background-image:url('images/avatars/thumbnail/#photo#')">
												
												<a href="#URLFor(controller="Users", action="view", key=id)#">
																												
													<cfimage
														action="writeToBrowser"
														source="#ExpandPath('images/transparent.png')#"
														title="#givenname# #sn#"
														width="70"
														height="70">
												
												</a>
											</div>
															
										<cfelse>
											
											<div class="userAvatar">
												
												<a href="#URLFor(controller="Users", action="view", key=id)#">
																												
													<cfimage
														action="writeToBrowser"
														source="#ExpandPath('images/transparent.png')#"
														title="#givenname# #sn#"
														width="70"
														height="70">
												
												</a>
											</div>
											
										</cfif>
														<!---<cfimage
															action="writeToBrowser"
															source="#ExpandPath('images/avatars/thumbnail/#photo#')#"
															title="#givenname# #sn#">--->
														<!---<cfimage
															action="writeToBrowser"
															source="#ExpandPath('images/avatars/thumbnailsmall/monkeyavatar.png')#"
															title="#givenname# #sn#">--->
					
													
		
											<!---</span>
										</span>
									</span>--->
								</td>
								<td class="td bt normal">#sn# #givenname#</td>
								<td class="td bt normal">#position#</td>
								<td class="td bt small">#departmentname#</td>
								<td class="td bt normal">#phone#<br />#mobile#</td>
								<td class="td bt normal">
									<a href="mailto:#mail#">#mail#</a>
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
			<cfif qUSearchCount gt elements>
				
				<cfset pages = Ceiling(qUSearchCount / session.search_filter.elements) />
				
				<cfif user_page gt 1>
					<cfoutput>
                    	<a 
							class="paginationlink navigate"
							title="poprzednia strona"
							data-container="search_user_cfdiv"
							href="#URLFor(controller='Search', action='findUsers', params='user_page=#user_page-1#&elements=#session.search_filter.elements#&user_order=#user_order#&order=#session.search_filter.order#')#">								
							
							&laquo;
						</a>
                    </cfoutput>
				</cfif>
		
				<cfloop index="idx" from="1" to="#pages#">
					
					<cfif idx gt user_page - 5 and idx lt user_page + 5>
						<cfif idx eq user_page>
							<cfoutput>
		                       	<a 
									class="paginationlink selected navigate" 
									title="nastepna strona"
									data-container="search_user_cfdiv"
									href="#URLFor(controller='Search', action='findUsers', params='user_page=#idx#&elements=#session.search_filter.elements#&user_order=#user_order#&order=#session.search_filter.order#')#">								
									
									#idx#
								</a>
							</cfoutput>
						<cfelse>
							<cfoutput>
		                       	<a 
									class="paginationlink navigate" 
									title="nastepna strona"
									data-container="search_user_cfdiv"
									href="#URLFor(controller='Search', action='findUsers', params='user_page=#idx#&elements=#session.search_filter.elements#&user_order=#user_order#&order=#session.search_filter.order#')#">								
									
									#idx#
								</a>
							</cfoutput>
						</cfif>
					</cfif>
					
				</cfloop>
				
				<cfif user_page lt pages>
					<cfoutput>
                       	<a 
							class="paginationlink navigate" 
							title="nastepna strona"
							data-container="search_user_cfdiv"
							href="#URLFor(controller='Search', action='findUsers', params='user_page=#user_page+1#&elements=#session.search_filter.elements#&user_order=#user_order#&order=#session.search_filter.order#')#">								
							
							&raquo;
						</a>
					</cfoutput>
				</cfif>
				
			</cfif>
		</div>

		<!---<div class="uiFooter">

			<cfset paginator = 1 />
			<cfset pages = Ceiling(qUSearchCount.c / session.search_filter.elements) />

			<cfloop condition="paginator LESS THAN OR EQUAL TO pages" >

				<a
						href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Search',action='findUser',params='user_page=#paginator#&elements=#session.search_filter.elements#')#</cfoutput>', 'search_user_cfdiv');"
					title="#paginator#"
					class="uiPaginatorLink clearfix <cfif paginator eq session.search_filter.user_page> active </cfif>">
						<span class="uiListItemLabel">
							<cfoutput>#paginator#</cfoutput>
						</span>
					</a>
				<cfset paginator++ />

			</cfloop>

		</div>--->
	</div>
</div>

<div class="footerArea">

</div>

<!---<script type="text/javascript">
	$.getScript("javascripts/ajaximport/search.user.tooltip.js");
</script>--->

<script>
	$(function(){
		//$(".tooltipshow").tooltip();
		
		//$("#search_result_cfdiv").find(".td").css({"font-weight": "bold"});
		
		//$("table th").tooltip();
		
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

</cfdiv>
<!---<cfdump var="#qUSearch#">--->