<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privUsuniecieRegalu" >
		<cfinvokeargument name="groupname" value="Usunięcie regału" />
	</cfinvoke>
</cfsilent>

<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">

			<div class="tree_group_admin">
				<div class="inner">
					<ul>
						<li>
							<a
								href="javascript:ColdFusion.Window.create('shelf_new_category', 'Nowa kategoria regału', '#URLFor(controller='Store_shelfs',action='newCategory')#', {height:135,width:500,modal:true,closable:true, draggable:true,resizable:false,center:true,initshow:true})"
								class="new_shelf_category"
								title="Dodaj kategorię regału">

								<span>Dodaj kategorię regału</span>

							</a>
						</li>

						<li>
							<a href="javascript:ColdFusion.Window.create('shelf_new_type', 'Nowy typ regału', '#URLFor(controller='Store_shelfs',action='newType')#', {height:228,width:500,modal:true,closable:true, draggable:true,resizable:false,center:true,initshow:true})"
								class="new_shelf_type"
								title="Dodaj typ regału">

								<span>Dodaj typ regału</span>

							</a>
						</li>

						<li>
							<a href="javascript:ColdFusion.Window.create('new_shelf', 'Nowy regał', '#URLFor(controller='Store_shelfs',action='newShelf')#', {minheight:250,minwidth:500,modal:true,closable:true, draggable:true,resizable:true,center:true,initshow:true})"
								class="new_shelf"
								title="Dodaj nowy regał">

								<span>Dodaj nowy regał</span>

							</a>
						</li>
					</ul>
				</div>
			</div>

			<div class="clear"></div>

			<h2 class="admin_shelfs">Zdefiniowane regały</h2>

			<cfdiv id="shelf_table" >

			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Typ sklepu</th>
						<th>Kategoria regału</th>
						<th>Typ regału</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="shelfs">
						<tr>
							<td class="first">&nbsp;</td>
							<td class="storetypename">
								<cfif Len(storetypename)>
									#storetypename#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td class="shelfcategoryname">#shelfcategoryname#</td>
							<td class="shelftypename">#shelftypename#</td>
							<td>
								<cfif privUsuniecieRegalu is true>
									<a href="javascript:void(0)" title="Usuń regał" class="remove_shelf" onclick="javascript:removeShelf(#id#, $(this))">
										<span>Usuń regał</span>
									</a>
								</cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Zdefiniowanych: #shelfsCount.c#</th>
						<th colspan="3">

							<cfset paginator = 1 />
							<cfset numberOfPages = Ceiling(shelfsCount.c/session.shelfs.elements) />
							<cfloop condition="paginator LESS THAN OR EQUAL TO numberOfPages" >

								<a href="javascript:ColdFusion.navigate('#URLFor(controller="Store_shelfs",action="getShelfs",params="page=#paginator#&elements=#session.shelfs.elements#")#', 'shelf_table');"
									class="<cfif paginator EQ session.shelfs.page>active</cfif>"
									title="#paginator#">

									<span>#paginator#</span>

								</a>

								<cfset paginator++ />

							</cfloop>

						</th>
					</tr>
				</tfoot>
			</table>

			</cfdiv>

			<h2 class="admin_connect">Przypisz regał do sklepu</h2>

			<!---
				Tabelka z regałami
				Kategoria - typ
			--->

			<cfform
				action="#URLFor(controller='Store_shelfs',action='assignToStores')#"
				name="storeshelfsform" >

			<table class="half_admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th colspan="3">Typ sklepu - Kategoria regału - Typ regału</th>
					</tr>
					<tr>
						<th>
							<cfinput type="checkbox" name="check_all_shelfs" value="1" />
						</th>
						<th>
							<cfselect name="storetypeid" query="myStoreTypes" value="id" display="store_type_name" class="select_box_small" queryPosition="below" >
								<option value="0">[Typ sklepu]</option>
							</cfselect>
						</th>
						<th>
							<cfselect name="shelfcategoryid" query="shelf_categories" value="id" display="shelfcategoryname" class="select_box_small" queryPosition="below">
								<option value="0">[Kategoria regału]</option>
							</cfselect>
						</th>
						<th>
							<cfselect name="shelftypeid" query="shelf_types" value="id" display="shelftypename" class="select_box_small" queryPosition="below">
								<option value="0">[Typ regału]</option>
							</cfselect>
						</th>
					</tr>
				</thead>
				<tbody class="shelfs">
					<cfloop query="shelfs">
						<tr>
							<td>
								<cfinput type="checkbox" name="shelfid[#id#]" value="1" />
							</td>
							<td colspan="3">#storetypename# - #shelfcategoryname# - #shelftypename#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>

			<!---
				Tabelka ze sklepami
			--->
			<table class="half_admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th colspan="2">Typ sklepu - Sklep - Adres</th>
						<th>
							<cfinput type="text" class="input_small" name="storesearch" />
						</th>
					</tr>
					<tr>
						<th>
							<cfinput type="checkbox" name="check_all_stores" value="1" />
						</th>
						<th colspan="2">
							<cfselect name="storetype_id" query="myStoreTypes" value="id" display="store_type_name" class="select_box_small" queryPosition="below" >
								<option value="0">[Typ sklepu]</option>
							</cfselect>

						</th>
						<th>
							<cfinput type="submit" name="storeshelfsubmit" value="Zapisz" class="admin_button green_admin_button" />
						</th>
					</tr>
				</thead>
				<tbody class="stores">
					<cfset iloscSklepow = 1 />
					<cfloop query="stores">
						<tr>
							<td>
								<cfinput name="storeid[#id#]" type="checkbox" value="1" />
							</td>
							<td colspan="3">(#iloscSklepow#) #storetypename# - #projekt# - #adressklepu#</td>
						</tr>
						<cfset iloscSklepow++ />
					</cfloop>
				</tbody>
			</table>

			<div class="clear"></div>

			<table class="admin_table">
				<tbody>
					<tr>
						<td class="r">&nbsp;</td>
					</tr>
				</tbody>
			</table>

			</cfform>


		</div>
	</div>

</cfoutput>

<script>
$(function() {
	
	$('#check_all_stores').live('click', function(){
		$("table tbody.stores input[type=checkbox]").attr('checked', $('#check_all_stores').is(':checked'));
	});

	$('#check_all_shelfs').live('click', function(){
		$("table tbody.shelfs input[type=checkbox]").attr('checked', $('#check_all_shelfs').is(':checked'));
	});

	var timeout = null;

	$('#storetypeid, #shelfcategoryid, #shelftypeid').live('change', function(e){
		var _storeTypeId = $('#storetypeid').val(),
			_shelfCategoryId = $('#shelfcategoryid').val(),
			_shelfTypeId = $('#shelftypeid').val();

		if (timeout){
			clearTimeout(timeout);
			timeout = null;
		}

		timeout = setTimeout(function(){
			$('#flashMessages').show();
			$.ajax({
				type:	'post',
				dataType:	'json',
				data:	{storetypeid:_storeTypeId,shelftypeid:_shelfTypeId,shelfcategoryid:_shelfCategoryId},
				url:	"index.cfm?controller=store_shelfs&action=filter-shelfs",
				success:	function(response){
					$('.shelfs').find('tr').remove();

					$.each(response.ROWS, function(i, item) {
						var _newrow = "<tr class=\"" + i + "\">"
						+ "<td class=\"first\"><input id=\"shelfid[" + item.ID + "]\" type=\"checkbox\" name=\"shelfid[" + item.ID + "]\" value=\"1\" ></td>"
						+ "<td colspan=\"3\">" + item.STORETYPENAME + " - " + item.SHELFCATEGORYNAME + " - " + item.SHELFTYPENAME + "</td>"
						+ "</tr>";

						$('.shelfs').append(_newrow);
					});
					$('#flashMessages').hide();
				}
			});
		}, 500);
	});
	
	$('#storetype_id').live('change',function(e){
		var _storeSearch = $('#storesearch').val(),
			_storeType_Id = $(this).val();
			
		if (timeout){
			clearTimeout(timeout);
			timeout = null;
		}
		
		timeout = setTimeout(function(){
			$('#flashMessages').show();
			$.ajax({
				type:	'post',
				dataType:	'json',
				data:	{search:_storeSearch,storetype_id:_storeType_Id},
				url:	'index.cfm?controller=Store_stores&action=search',
				success:	function(result){
					$('.stores').find('tr').remove();
					var licznik = 1;
					$.each(result.ROWS, function(i, item) {
						var _newrow = "<tr class=\"" + i + "\">"
						+ "<td class=\"first\"><input id=\"storeid[" + item.ID + "]\" type=\"checkbox\" name=\"storeid[" + item.ID + "]\" value=\"1\" ></td>"
						+ "<td colspan=\"3\">("+ licznik++ +") "+ item.STORETYPENAME + " - " + item.PROJEKT + " - " + item.ADRESSKLEPU + "</td>"
						+ "</tr>";

						$('.stores').append(_newrow);
					});
					$('#flashMessages').hide();
				}
			});
		});
		
	});

	$('#storesearch').live('keypress', function () {
		var _storeSearch = $('#storesearch').val(),
			_storeType_Id = $('#storetype_id').val();
			
		if (timeout){
	        clearTimeout(timeout);
	        timeout = null;
		}

		timeout = setTimeout(function(){
			$.ajax({
				type		:	'get',
				dataType	:	'json',
				data		:	{search:_storeSearch,storetype_id:_storeType_Id},
				url			:	"index.cfm?controller=Store_stores&action=search",
				success		:	function(data) {
					$('.stores').find('tr').remove();

					$.each(data.ROWS, function(i, item) {
						var _newrow = "<tr class=\"" + i + "\">"
						+ "<td class=\"first\"><input id=\"storeid[" + item.ID + "]\" type=\"checkbox\" name=\"storeid[" + item.ID + "]\" value=\"1\" ></td>"
						+ "<td colspan=\"3\">" + item.STORETYPENAME + " - " + item.PROJEKT + " - " + item.ADRESSKLEPU + "</td>"
						+ "</tr>";

						$('.stores').append(_newrow);
					});
					$('#flashMessages').hide();
				}
			});
		}, 500);
		$('#flashMessages').show();

	});

});

function validateNewShelfType()
{
	var ret = false;
	$.ajax({
		type		:"post",
		dataType	:"json",
		async		:false,
		data		:{
			h :$("form#shelf_type_form #h").val(),
			w :$("form#shelf_type_form #w").val()
		},
		url			:"index.cfm?controller=store_shelfs&action=validate-new-shelf-type",
		success		:function(res){
			$("span.new_shelf_validation_message").removeClass("darkRed").addClass(res.CLS).text(res.MESSAGE);
			ret = res.STATUS;
		},
		error		:function(xhr, error){
			console.debug(xhr);
			console.debug(error);
			ret = false;
		}
	});
	console.debug(ret);
	
	return ret;
}

function validateNewShelfCategory()
{
	var ret = false;
	$.ajax({
		type		:"post",
		dataType	:"json",
		async		:false,
		data		:{
			categoryname :$("form#shelf_category_form #shelfcategoryname").val()
		},
		url			:"index.cfm?controller=store_shelfs&action=validate-new-shelf-category",
		success		:function(res){
			$("span.new_shelf_validation_message").removeClass("darkRed").addClass(res.CLS).text(res.MESSAGE);
			ret = res.STATUS;
		},
		error		:function(xhr, error){
			console.debug(xhr);
			console.debug(error);
			ret = false;
		}
	});
	console.debug(ret);
	
	return ret;
}

function validateNewShelf()
{
	var ret = false;
	$.ajax({
		type		:"post",
		dataType	:"json",
		async		:false,
		data		:{
			storetypeid :$("form#new_shelf_form #storetypeid").val(),
			shelftypeid :$("form#new_shelf_form #shelftypeid").val(),
			shelfcategoryid :$("form#new_shelf_form #shelfcategoryid").val()
		},
		url			:"index.cfm?controller=store_shelfs&action=validate-new-shelf",
		success		:function(res){
			$("span.new_shelf_validation_message").removeClass("darkRed").addClass(res.CLS).text(res.MESSAGE);
			ret = res.STATUS;
		},
		error		:function(xhr, error){
			console.debug(xhr);
			console.debug(error);
			ret = false;
		}
	});
	console.debug(ret);
	
	return ret;
}

function removeShelf(Id, el)
{
	$('#flashMessages').show();
	$.ajax({
		type	:	'post',
		dataType:	'json',
		data:		{key:Id},
		url:		'index.cfm?controller=store_shelfs&action=remove-shelf',
		async:		false,
		success: 	function(response){
			el.parent().parent().remove();
			$('#flashMessages').hide();
		}
	});		
}
</script>