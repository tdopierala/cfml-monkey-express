		
		<cfif order eq 'desc'>
			<cfset _order = 'asc' />
			<cfset _order_label = 'rosnąco' />
		<cfelse>
			<cfset _order = 'desc' />
			<cfset _order_label = 'malejąco' />
		</cfif>
		
		<table class="tables debtrate-table">
			<thead>
				<tr class="thtop">
					<th rowspan="2"></th>
					<th rowspan="2">L.p.</th>
					<th colspan="2">Sklep</th>
					<th colspan="3">Wartość</th>
					<th class="tright thsort" rowspan="2">
						<span>Starter</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=starter&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'starter'>
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
					<th class="tright thsort" title="Wskaźnik zadłużenia" rowspan="2">
						<span>WZ</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=ratio&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'ratio'>
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
					<th colspan="2">
						Różnica wpłat
					</th>
				</tr>
				<tr class="thbottom">
					<th class="thsort" title="Numer sklepu / Projekt">
						<span>nr</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box"
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=sklep&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'sklep'>
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
					<th>
						<span>adres</span>
					</th>
					<th class="tright thsort">
						<span>faktur</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=fv&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'fv'>
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
					<th class="tright thsort">
						<span>wpłat</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=payment&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'payment'>
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
					<th class="tright thsort">
						<span>różnica</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=substract&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'substract'>
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
					<th class="thsort nextsort">
						<span>zł</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=exp&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'exp'>
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
					<th class="thsort nextsort">
						<span>%</span>
						<cfoutput>
							<a 
								class = "searchparamlink navigate" 
								title = "Sortuj #_order_label#" 
								data-container = "debtratio-table-box" 
								href = "#URLFor(controller='DebtRate', action='genereRatio', params='page=1&orderby=expratio&order=#_order#&projekt=#projekt#')#">								
											
								<cfif orderby eq 'expratio'>
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
				</tr>
			</thead>
			<tbody>
				
				<cfset c=(page*amount)-amount />
				<cfloop query="ratioList">
					<cfset c=c+1 />
					
					<cfif not IsNumeric(fv) or fv eq ''>
						<cfset _fv = "brak danych" />
					<cfelse>
						<cfset _fv = Replace(NumberFormat(fv, "__,___.__"), ",", " ", "ALL") />
					</cfif>
					
					<cfif not IsNumeric(sumpayment) or sumpayment eq ''>
						<cfset _sumpayment = "brak danych" />
					<cfelse>
						<cfset _sumpayment = Replace(NumberFormat(sumpayment, "__,___.__"), ",", " ", "ALL") />
					</cfif>
					
					<cfset substract_class = 'plus' />
					<cfif not IsNumeric(substract) or substract eq ''>
						<cfset _substract = "brak danych" />
					<cfelse>
						<cfif substract lt 0>
							<cfset substract_class = 'minus' />
						</cfif>
						
						<cfset _substract = Replace(NumberFormat(substract, "__,___.__"), ",", " ", "ALL") />
					</cfif>
					
					<cfif not IsNumeric(starter) or starter eq ''>
						<cfset _starter = "--" />
					<cfelse>
						<cfset _starter = Replace(NumberFormat(starter, "__,___.__"), ",", " ", "ALL") />
					</cfif>
					
					<cfif not IsNumeric(ratio) or ratio eq ''>
						<cfset _ratio = "--" />
					<cfelse>
						<cfset _ratio = Replace(NumberFormat((ratio*100), "___"), ",", " ", "ALL") & "%"/>
					</cfif>
					
					<cfset expected_class = 'plus' />
					<cfif not IsNumeric(expected) or expected eq ''>
						<cfset _expected = "--" />
					<cfelse>
						<cfif expected lt 0>
							<cfset expected_class = 'minus' />
						</cfif>
						
						<cfset _expected = Replace(NumberFormat(expected, "__,___.__"), ",", " ", "ALL") />
					</cfif>
					
					<cfif not IsNumeric(expected_ratio) or expected_ratio eq ''>
						<cfset _expected_ratio = "--" />
					<cfelse>
						<cfset _expected_ratio = Replace(NumberFormat((expected_ratio), "__,___.__"), ",", " ", "ALL") & "%" />
					</cfif>
					
					<cfif StructKeyExists(stores, "#projekt#")>
						<cfset adress = stores[projekt] />
					<cfelse>
						<cfset adress = "--" />
					</cfif>
					
					<cfoutput>
	                	<tr>
	                		<td class="tdbutton" data-logo="#logo#" data-projekt="#projekt#">
								#linkTo(
									href="##",
									text=imageTag("expand_right.png"),
									class="ratio-expand"
								)#
							</td>
							<td class="tdlp">#c#</td>
							<td class="tdprojekt">#projekt#</td>
							<td class="tdadress">#adress#</td>
							<td class="number tdfv">#_fv#</td>
							<td class="number tdsump">#_sumpayment#</td>
							<td class="number tdsubst #substract_class#">#_substract#</td>
							<td class="number tdstart">#_starter#</td>
							<!---<td class="number tdmratio">#NumberFormat(minratio, "__") & "%"#</td>--->
							
							<cfif IsNumeric(ratio) and (ratio*100) gt minratio>
								
								<td class="number tdratio ratio-over">
									<span>#_ratio#</span>
								</td>
								
							<cfelseif IsNumeric(ratio) and (ratio*100) lte minratio>
								
								<td class="number tdratio ratio-below">
									<span>#_ratio#</span>
								</td>
								
							<cfelse>
								
								<td class="number tdratio">
									<span>#_ratio#</span>
								</td>
								
							</cfif>
							
							<td class="number tdexpsum #expected_class#">#_expected#</td>
							
							<cfif IsNumeric(expected_ratio) and expected_ratio gt 100>
								<td class="number tdexpratio ratio-below">
									<span>#_expected_ratio#</span>
								</td>
							<cfelseif IsNumeric(expected_ratio) and expected_ratio lte 100>
								<td class="number tdexpratio ratio-over">
									<span>#_expected_ratio#</span>
								</td>
							<cfelse>
								<td class="number tdexpratio">
									<span>#_expected_ratio#</span>
								</td>
							</cfif>
						</tr>
	                </cfoutput>
				</cfloop>
			
			</tbody>
		</table>
		
		<div class="wrapper pagination-box">
			
			<cfset pages = Ceiling(ratioListCount.c / amount) />
			
			<cfoutput>
				<cfif page gt 1>
	            	<a 
						class="paginationlink navigate"
						title="poprzednia strona"
						data-container="debtratio-table-box"
						href="#URLFor(controller='DebtRate', action='genereRatio', params='page=#page-1#&orderby=#orderby#&order=#order#&projekt=#projekt#')#">
							&laquo;
					</a>
				<cfelse>
					<a 
						class="paginationlink navigate"
						title="poprzednia strona"
						data-container="debtratio-table-box"
						href="##" 
						onclick="return false;">
							&laquo;
					</a>
				</cfif>
				
				<cfloop index="idx" from="1" to="#pages#">
					
					<cfif idx gt page - 5 and idx lt page + 5>
						<cfif idx eq page>
							<cfoutput>
		                       	<a 
									class="paginationlink navigate selected"
									title="poprzednia strona"
									data-container="debtratio-table-box"
									href="#URLFor(controller='DebtRate', action='genereRatio', params='page=#idx#&orderby=#orderby#&order=#order#&projekt=#projekt#')#">								
									
									#idx#
								</a>
							</cfoutput>
						<cfelse>
							<cfoutput>
		                       	<a 
									class="paginationlink navigate"
									title="poprzednia strona"
									data-container="debtratio-table-box"
									href="#URLFor(controller='DebtRate', action='genereRatio', params='page=#idx#&orderby=#orderby#&order=#order#&projekt=#projekt#')#">								
									
									#idx#
								</a>
							</cfoutput>
						</cfif>
					</cfif>
					
				</cfloop>
				
				<cfif page lt pages>
					<a 
						class="paginationlink navigate" 
						title="nastepna strona"
						data-container="debtratio-table-box"
						href="#URLFor(controller='DebtRate', action='genereRatio', params='page=#page+1#&orderby=#orderby#&order=#order#&projekt=#projekt#')#">
							&raquo;
					</a>
				<cfelse>
					<a 
						class="paginationlink navigate" 
						title="nastepna strona"
						data-container="debtratio-table-box"
						href="##"
						onclick="return false;">
							&raquo;
					</a>
				</cfif>
				
            </cfoutput>
		</div>
		
		
<script>
	$(function(){
		
		$(".debtrate-table").on("mouseenter", ".thsort", function(){
			
			var idx = $(this).index() + 3;
			
			if($(this).parent().hasClass("thtop"))
				idx += 1;
			
			if($(this).hasClass("nextsort"))
				idx += 2;
				
			$(this).addClass("trhover");
			$("td:nth-child(" + idx + ")").addClass("trhover");
		});
		
		$(".debtrate-table").on("mouseleave", ".thsort", function(){
			var idx = $(this).index() + 3;
			
			if($(this).parent().hasClass("thtop"))
				idx += 1;
			
			if($(this).hasClass("nextsort"))
				idx += 2;
			
			$(this).removeClass("trhover");
			$("td:nth-child(" + idx + ")").removeClass("trhover");
		});
		
	});
</script>
<!---<cfif session.user.id eq 345>
	<cfdump var="#ratioList#" />
</cfif>--->