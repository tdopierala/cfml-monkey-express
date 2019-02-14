<cfsilent>
	
</cfsilent>

<cfprocessingdirective pageEncoding="utf-8" />

<div class="wrapper">
	
	<div class="admin_wrapper">
		
		<h2 class="tree_groups">Rejonizacja sprzedażowa</h2>
		
		<div class="tree_group_admin">
			<div class="inner">
				
				<ul>
					<li>
						<a href="javascript:ColdFusion.Window.create('dodaj-rejon-okienko', 'Dodaj rejon', 'index.cfm?controller=rejonizacja&action=dodaj-rejon', {x:100,y:50,height:400,width:750,modal:false,closable:true,draggable:true,resizable:true,center:true,initshow:true})" class="new_struct_element" title="Dodaj rejon"><span>Dodaj rejon</span></a>
					</li>
					<li>
						<a href="javascript:ColdFusion.Window.create('dodaj-makroregion', 'Dodaj makroregion', 'index.cfm?controller=rejonizacja&action=dodaj-makroregion', {x:150,y:60,height:400,width:750,modal:false,closable:true,draggable:true,resizable:true,center:true,initshow:true})" class="new_struct_element" title="Dodaj makroregion"><span>Dodaj makroregion</span></a>
					</li>
					<li>
						<a href="javascript:ColdFusion.Window.create('uzytkownicy-rejonow', 'Przypisz użytkownika do rejonu', 'index.cfm?controller=rejonizacja&action=uzytkownicy-rejonow', {x:200,y:70,height:400,width:750,modal:false,closable:true,draggable:true,resizable:true,center:true,initshow:true})" class="workflow_adduser" title="Przypisz użytkownika do rejonu"><span>Przypisz użytkownika do rejonu</span></a>
					</li>
				</ul>
			</div>
		</div>
		
		<div class="tree_group_admin place_tree_privileges">
			<div class="inner uiContent">
				<table class="uiTable">
					<thead>
						<th class="leftBorder topBorder rightBorder bottomBorder expandCell">&nbsp;</th>
						<th class="topBorder rightBorder bottomBorder">Makroregion</th>
						<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
					</thead>
					<tbody>
						<cfoutput query="makroregiony">
							<tr>
								<td class="leftBorder rightBorder bottomBorder expandCell">
									<a href="javascript:void(0)" onclick="pobierzRejonyMakroregionu(#id#, $(this))" class="extend" title="Pobierz rejony makroregionu">
										<span>&nbsp;</span>
									</a>
								</td>
								<td class="rightBorder bottomBorder l">#nazwa#</td>
								<td class="rightBorder bottomBorder l buttonCell">
									<a href="javascript:void(0)" onclick="usunMakroregion(#id#,$(this))" class="aButton" title="Usuń makroregion">x</a>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</div>
		</div>
		
	</div>
	
</div>

<script>
$(function(){
	$(".place_tree_structure").sortable({
		items	:	"> li",
		stop	:	function(event, ui) {
			$('#flashMessages').show();
			$.ajax({
				dataType	:	'json',
				type		:	'post',
				data		:	{my_root:ui.item.metadata().id,new_parent:ui.item.prev().metadata().id},
				url			:	"index.cfm?controller=place_tree_privileges&action=move",
				success		:	function(data) {
					var myList = "";
					$.each(data.ROWS, function(i, item){
						myList += "<li class=\"level-" + item.LEVEL + " {id: " + item.ID + ", lft: " + item.LFT + ", rgt: " + item.RGT + ", parentid: " + item.PARENTID + "}\">" + item.GIVENNAME + ", " + item.SN + "(<a href=\"javascript:ColdFusion.Window.create('user-districts-" + item.USERID + "', 'Przypisz powiaty', 'index.cfm?controller=place_tree_privileges&action=user-districts&key=" + item.USERID + "', {x:100,y:100,height:400,width:750,modal:true,closable:true,draggable:true,resizable:false,center:true,initshow:true})\" class=\"tree_group_menu\">powiaty</a> | <a href=\"index.cfm?controller=place_tree_privileges&action=remove\">usuń użytkownika</a> ) </li>";
						
					});
					$('.place_tree_structure > li').remove();
					
					$('.place_tree_structure').append(myList);
					$('#flashMessages').hide();
				}
			});

		}
	});
});
</script>