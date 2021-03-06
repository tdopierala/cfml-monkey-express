<cfoutput>
	<div class="wrapper">
		<h3>Struktura organizacyjna</h3>
		
		<div class="wrapper companystructure">
			
			<ul class="maincompanystructure">
				<cfloop query="root">
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
		
		</div>
	</div>
</cfoutput>

<script>
$(function() {
	$('.ajaxtreestructure').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		var id = $(this).metadata().id;
		var lft = $(this).metadata().lft;
		var rgt = $(this).metadata().rgt;
		var depth = $(this).metadata().depth;
		var el = $('#'+id);
		var link = $(this);
		
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{id:id,lft:lft,rgt:rgt,depth:depth},
			url			:		$(this).attr('href'),
			success		:		function(data) {
			
				if (link.attr('class').indexOf('show') >= 0) {
					link.removeClass('show').addClass('hide');
					el.append(data);
				} else {
					link.removeClass('hide').addClass('show');
					el.find('ul').remove();
				}
				
				$('#flashMessages').hide();
			}
		});
	});
	
	<!---
	$('.userimg').live('mouseover', function() {
		$('#flashMessages').show();
		var userid = $(this).metadata().userid;
		var lft = $(this).metadata().lft;
		var rgt = $(this).metadata().rgt;
		var el = $(this).parent().parent();
		
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{userid:userid,lft:lft,rgt:rgt},
			url			:		"<cfoutput>#URLFor(controller="Users",action="getUserPreview")#</cfoutput>",
			success		:		function(data) {
				el.append(data);
				$('#flashMessages').hide();
			}
		});
	});
	
	
	$('.userimg').live('mouseout', function() {
		var el = $(this).parent().parent();
		el.find('.userpreview').remove();
	});
	--->
	
	<!---
	23.07.2012
	Jeśli jestem z personalnego lub jestem administratorem to daje możliwość modyfikacji struktury organizacyjnej.
	--->
	<cfif checkUserGroup(session.userid, "root") || checkUserGroup(session.userid, "Departament Personalny")>
	$('.maincompanystructure').sortable({
		update		:		function(event, ui) {
		
			var parentuserid = $(ui.item).prev().metadata().userid;
			var userid = $(ui.item).metadata().userid;
			
			$.ajax({
				type		:		'post',
				dataType	:		'html',
				data		:		{parentuserid:parentuserid,userid:userid},
				url			:		"<cfoutput>#URLFor(controller='Users',action='moveBranch')#</cfoutput>",
				success		:		function(data) {
					$('.companystructure').html(data);
				}
			});
		}
	});
	</cfif>
});
</script>