<cfoutput>
	<ul class="maincompanystructure">
		<cfloop query="users">
			<li id="#id#" class="sort expand level#depth# {userid:#id#,lft:#lft#,rgt:#rgt#}">
			
				<div class="singleperson">
					<div class="photo">
					
						<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
				
							#imageTag(source="avatars/thumbnailsmall/#photo#",class="userimg {userid:#id#,lft:#lft#,rgt:#rgt#}")#
						
						<cfelse>
							
							#imageTag(source="avatars/monkeyavatar.png",alt="#givenname# #sn#",title="#givenname# #sn#",class="userimg {userid:#id#,lft:#lft#,rgt:#rgt#}")#
							
						</cfif>
					
					</div>
					<h5>#givenname# #sn# <span>(#position#)</span></h5>
					<h6>
			
						#mailTo(
							emailAddress=mail,
							name=mail)#
					
					</h6>
					
					<!---
					#linkTo(
						text="<span>rozwiń</span>",
						controller="Users",
						action="getNodeChildreen",
						class="ajaxtreestructure show {id:#id#,lft:#lft#,rgt:#rgt#,depth:#depth#}")#
					--->
				</div>
			
			</li>
		</cfloop>
	</ul>
</cfoutput>

<script>
$(function() {
	$('.maincompanystructure').sortable({
		update		:		function(event, ui) {
			var parentuserid = $(ui.item).prev().metadata().userid;
			var parentlft = $(ui.item).prev().metadata().lft;
			var parentrgt = $(ui.item).prev().metadata().rgt;
			
			var userid = $(ui.item).metadata().userid;
			var lft = $(ui.item).metadata().lft;
			var rgt = $(ui.item).metadata().rgt;
			
			$.ajax({
				type		:		'post',
				dataType	:		'html',
				data		:		{parentuserid:parentuserid,parentlft:parentlft,parentrgt:parentrgt,userid:userid,lft:lft,rgt:rgt},
				url			:		"<cfoutput>#URLFor(controller='Users',action='moveBranch')#</cfoutput>",
				success		:		function(data) {
					$('.companystructure').html(data);
				}
			});
<!--- 			alert($(ui.item).attr('class')); --->
<!--- 			alert($(ui.item).next().attr('class')); --->
		}
	});
});
</script>