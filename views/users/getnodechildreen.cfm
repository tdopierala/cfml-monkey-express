<cfoutput>
	<ul>
		<cfloop query="users">
			<div class="sort">
			<li id="#id#" class="show level#depth#">
				<div class="singleperson">
					<div class="photo">
						<cfif FileExists(ExpandPath("images/avatars/thumbnailsmall")&"/#photo#")>
						
							#imageTag(source="avatars/thumbnailsmall/#photo#",class="userimg {userid:#id#,lft:#lft#,rgt:#rgt#}")#
						
						<cfelse>
							
							#imageTag(source="avatars/monkeyavatar.png",alt="#givenname# #sn#",title="#givenname# #sn#",class="userimg {userid:#id#,lft:#lft#,rgt:#rgt#}")#
							
						</cfif>
					
					</div>
							
					<h5>#givenname# #sn#</h5>
					<h6>
					
						#mailTo(
							emailAddress=mail,
							name=mail)#
					
					</h6>
	
					#linkTo(
						text="<span>rozwiń</span>",
						controller="Users",
						action="getNodeChildreen",
						class="ajaxtreestructure show {id:#id#,lft:#lft#,rgt:#rgt#,depth:#depth#}")#
				</div>
			</li>
			</div>
		</cfloop>
	</ul>
</cfoutput>

<script>
$(function() {
	$('.sort').sortable({
		}).disableSelection();
});
</script>