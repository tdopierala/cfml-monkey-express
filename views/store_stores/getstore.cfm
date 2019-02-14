<cfoutput>

	<tr>
		
		<td class="first">&nbsp;</td>
		<td class="admin_submenu_options" colspan="5">
			
			<ul class="store_row_options">
				<li class="title">Regały</li>
				<cfloop query="my_shelfs">
					<li>
						
						<span class="place_element_count">#c#</span>
						
						<a 
							href="javascript:ColdFusion.Window.create('planograms_store_list-#shelfid#', 'Lista sklepów', '#URLFor(controller='Store_planograms',action='shelfStores',params='shelfid=#shelfid#')#', {height:450,width:500,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})"
							class=""
							title="Lista sklepów">
							<span>#store_type_name# - #shelfcategoryname# - #shelftypename#</span>		
						</a>
						<!---
						(<a href="javascript:void(0);" onclick="javascript:showCFWindow('planograms_planograms_list-#storetypeid#-#shelftypeid#-#shelfcategoryid#', 'Lista planogramów', 'index.cfm?controller=store_planograms&action=shelf-planograms&storetypeid=#storetypeid#&shelftypeid=#shelftypeid#&shelfcategoryid=#shelfcategoryid#', 500, 770);" class="" title="Lista planogramów"><span class="element_count">#p#</span> <span>planogram</span></a>)
						--->
						
					</li>
				</cfloop>
			</ul>
			
			<ul class="store_row_options">
				<li class="title">Planogramy</li>
				<cfloop query="myPlanograms">
					<li>
						<a href="javascript:void(0);" onclick="javascript:showCFWindow('planograms_list-#storetypeid#-#shelftypeid#-#shelfcategoryid#', 'Lista planogramów', 'index.cfm?controller=store_planograms&action=shelf-store-planograms&storetypeid=#storetypeid#&shelftypeid=#shelftypeid#&shelfcategoryid=#shelfcategoryid#', 300, 500);" title="Lista planogramów" class=""><span>#storetypename# - #shelfcategoryname# - #shelftypename#</span></a>
					</li>
				</cfloop>
			</ul>
			
			<ul class="store_row_options">
				<li class="title">Protokoły</li>
				<cfloop query="my_protocols" >
					<li>
						
						<span class="place_element_count">#c#</span>
						
						#linkTo(
							text=typename,
							controller="Store_stores",
							action="protocolPreview",
							key=userid,
							params="typeid=#typeid#")#
						
					</li>
				</cfloop>
			</ul>
			
			<div class="clear"></div>
			
			<!---<ul class="store_row_options">
				<li class="title">Obiekty</li>
				<cfloop query="my_objects">
					
					<li>
						
					<span class="place_element_count">#c#</span>
					
					#linkTo(
						text=objectname,
						controller="Store_objects",
						action="getObjects",
						params="objectid=#objectid#&storeid=#storeid#",
						class="get_store_objects")#
				 
				 	</li>
					
				</cfloop>
			</ul>--->
			
			<ul class="store_row_options">
				<li class="title">Raporty</li>
				<li>
					<a href="#URLFor(controller='Store_planograms',action='reportSingleStore',key=my_store.id)#" title="Raport z planogramów" target="_blank">Regały na sklepie</a>
				</li>
			</ul>
			
		</td>
		
	</tr>

</cfoutput>

<script>
$(function() {
	$('.get_store_objects').on('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('#flashMessages').hide();
			}
		});
	});
});
</script>