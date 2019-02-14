<cfprocessingdirective pageEncoding="utf-8" />

<div class="wrapper">
	
	<div class="admin_wrapper">
		
		<h2 class="tree_groups">Rejonizacja ekspansyjna</h2>
		
		<div class="tree_group_admin">
			<div class="inner">
				<ul>
					<li>
						<cfscript>
							writeOutput("
								<a href=""javascript:ColdFusion.Window.create('place_tree_privileges', 'Dodaj użytkownika do struktury', 'index.cfm?controller=place_tree_privileges&action=add-user', {x:100,y:100,height:400,width:750,modal:true,closable:true,draggable:true,resizable:false,center:true,initshow:true})""
								class=""new_user"">
								<span>
									Dodaj użytkownika
								</span>
								</a>
							");
						</cfscript>
					</li>
				</ul>
			</div>
		</div>
		
		<div class="tree_group_admin place_tree_privileges">
			<div class="inner">
				
				<ul class="tree_group_structure ui-sortable place_tree_structure">
				
					<cfscript>
						for(
							i = 1;
							i LTE tree.RecordCount;
							i = i + 1) {
							
							writeOutput("
								<li class=""level-#tree['level'][i]# {id:#tree['id'][i]#, lft:#tree['lft'][i]#, rgt:#tree['rgt'][i]#, parentid:#tree['parentid'][i]#}"">
									#tree['givenname'][i]#, #tree['sn'][i]#
									(
									<a href=""javascript:ColdFusion.Window.create('user-districts-#tree['userid'][i]#', 'Przypisz powiaty', '#URLFor(controller='Place_tree_privileges',action='user-districts',key=tree['userid'][i])#', {x:100,y:100,height:400,width:750,modal:true,closable:true,draggable:true,resizable:false,center:true,initshow:true})"" class=""tree_group_menu"">powiaty</a>
									|
									<a href=""#URLFor(controller='Place_tree_privileges',action='remove',key=tree['id'][i])#"">usuń użytkownika</a>
									)
								</li>
							");
							
						}
					</cfscript>
				
				</ul>
				
				<!---
				<cfform
					name="place_tree_privilege_form"
					action="">
						
					<cftree 
						name="placePrivilegesTree" 
						format="html" 
						height="400" 
						width="865" 
						completepath="no" 
						required="yes">
							 
						<!--- cfoutput tag with a group attribute loops over the departments. --->
						<cfoutput query="tree">

							<cftreeitem 
								value="#givenname#, #sn#"
								parent="#parentid#" 
								expand="true" 
								img="folder" >

						</cfoutput>
    				</cftree>
						
				</cfform>
				--->
				
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