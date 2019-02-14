<div class="navArea">
	<div class="uiNavArea">

		<div class="navHeaderArea">
			<div class="navHeaderArea uiHeader">
				<h3 class="uiHeaderTitle">Nawigacja</h3>
			</div>
		</div>

		<div class="navAreaContent">
			<div class="navAreaContent uiNav">
				<cfif structKeyExists(session, "user") and structKeyExists(session.user, "id")>
					
				<cfinvoke
					component="models.Tree_groupuser"
					method="getUserTreeMenu"
					returnvariable="qMenu" >

					<cfinvokeargument
						name="userid"
						value="#session.user.id#" />

				</cfinvoke>

				<cfloop query="qMenu">

						<a
							href="#"
							class="menu_group_name uiNavLink clearfix {groupid: <cfoutput>#groupid#</cfoutput>}"
							title="<cfoutput>#groupname#</cfoutput>" >

							<h4 class="uiNavItemLabel"><cfoutput>#groupname#</cfoutput></h4>

						</a>

						<ul class="uiNavList" style="display: none;"></ul>

				</cfloop>
				
				</cfif>

			</div>
		</div>

	</div>
</div>





<script>
$(function() {
	$(".uiNavLink").click(function() {
		var myDIV = $(this).next();
		if (false == myDIV.is(':visible')) {

			$('#flashMessages').show();
			$.ajax({
				dataType	:	'json',
				type		:	'post',
				async		:	false,
				data		:	{groupid:$(this).metadata().groupid},
				url			:	"<cfoutput>#URLFor(controller='Tree_groupmenus',action='getGroupMenu')#</cfoutput>",
				success		:	function (data) {
					var mySUBMENU = "";
					$.each(data.ROWS, function (i, item) {
						var myLink = "<li>"
							+ "<a href=\"index.cfm?controller=" + item.CONTROLLER
							+ "&action=" + item.ACTION + "\">" + item.DISPLAYNAME + "</a></li>";
						mySUBMENU += myLink;
					});
					myDIV.find('li').remove();
					myDIV.append(mySUBMENU);
					$('#flashMessages').hide();
				}
			});

		} else {

		}

		$(this).next().slideToggle(300);

	});

	$('.selected').parent().show();

});
</script>
