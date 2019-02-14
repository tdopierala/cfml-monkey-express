<cfoutput>
				<cfloop query="products">
					<tr>
						<td class="tdcheckbox">
							<cfif params.ps eq 4>
								#checkBoxTag(name='indexchecker', value=id, class="product-checkbox")#
							</cfif>
						</td>
						<td>#id#</td>
						<td>
							<div class="product-title" title="#Replace(productname,'"',"'","ALL")#">
								<cfif type eq 1 or type eq 2 or type eq 5>
									<!---<cfif Len(productname) gt 30>
										#Left(productname,30)#...
									<cfelse>--->
										#productname#
									<!---</cfif>--->
								<cfelse>
									#productid#
								</cfif>
							</div>
						</td>
						<td>#DateFormat(acceptdate, "yyyy-mm-dd")#</td>
						<td>#productType.name[type]#</td>
						<td>#username#</td>
						<td>#status#</td>
						<td>#linkTo(
							text=imageTag("search_view.png"), 
							action="view", 
							key=id)#</td>
					</tr>
				</cfloop>
				
				<cfif params.ps eq 4 and _arch is true>
					<tr>
						<td colspan="7" class="product-table-options">
							<a href="##" class="product-select-all">Zaznacz wszystkie</a>
							<a href="##" class="product-move">Przenieś zaznaczone do archiwum</a>
						</td>
					</tr>
				</cfif>

<script>
	$(function(){
		$(".product-paginator").html('');
		var page = #params.page#;
		var pages = #pages#;
		
		if(page>1){
			$(".product-paginator").append(
				$("<a>").addClass("paginlink").data("page",page).attr("href", "##").html("&laquo;"));
		}
		
		for(i=1; i<=pages; i++){
			
			if((page+1) == i) var selected = 'selected';
			else var selected = '';
			
			if( i >= (page-3) && i <= (page+5) ){			
				$(".product-paginator").append(
					$("<a>").addClass("paginlink " + selected).data("page",i).attr("href", "##").text(i));
			}
		}
		
		if(page<pages){
			$(".product-paginator").append(
				$("<a>").addClass("paginlink").data("page",page+2).attr("href", "##").html("&raquo;"));
		}
		
		$(".product-select-all").on("click", function(){
			
			if($('.product-checkbox').is(':checked')){
				$(this).text('Zaznacz wszystkie');
				$('.product-checkbox').attr('checked', false);
			}
			else {
				$(this).text('Odznacz wszystkie');
				$('.product-checkbox').attr('checked', true);
			}
				
				
			return false;
		});
		
		var _timebox;
		$(".product-move").on("click", function(){
			
			//alert($( ".product-checkbox:checked" ).length);			
				
			_timebox = setInterval(function() {
      			
				if( $(".product-checkbox:checked").length == 0 )
					clearInterval(_timebox);
				else {
					var idx = $(".product-checkbox:checked").first();
					
					$.post("#URLFor(controller='Products',action='newstep')#", { indexid: idx.val(), stepid: 6, stepcomment: "" })
						.done(function(data) {
							idx.closest("tr").remove();
						});
						
					/*idx.closest("tr").find("td").slideUp(250, function() {
						idx.closest("tr").remove();
					});*/
					
					idx.closest("tr").find("td").animate({
						 opacity			:	0.25
						 ,height			:	"toggle"
						 ,"padding-top"		:	"-=5"
						 ,"padding-bottom"	:	"-=5"
					}, 300, function(){
						idx.closest("tr").remove();
					});
				}
							
			}, 700);
			
			return false;
		});
	});
</script>
</cfoutput>
