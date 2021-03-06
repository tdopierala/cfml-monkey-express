<cfoutput>

	<div class="wrapper">

		<h3>Moje komunikaty</h3>

		<div class="wrapper">
			<cfoutput>#includePartial(partial="/users/subnav")#</cfoutput>
		</div>

		<div class="messages">
			<table class="tables">
				<thead>

				</thead
				<tbody>
					<tr class="">
						<td colspan="6" class="bottomBorder singlemessageoptions">
							#linkTo(
								text="<span>Usuń komunikat</span>",
								controller="Messages",
								action="delete",
								class="deletemessage",
								title="Usuń zaznaczone komunikaty")#

							#linkTo(
								text="<span>Dodaj komunikat</span>",
								controller="Messages",
								action="add",
								class="addmessage",
								title="Dodaj nowy komunikat")#
						</td>
					</tr>
					<cfset lp = 1 />
					<cfloop query="messages">
						<tr class="<cfif messagevisible eq 1> visiblemessage <cfelse> deletedmessage </cfif> <cfif usermessagereaded eq 0>unread</cfif>" >
							<td class="c bottomBorder cbk">

								#checkBoxTag(name="messaged",value=id,label=false)#

							</td>
							<td class="c bottomBorder newsimg">

								<cfif DateFormat(messagestartdate, "dd-mm-yyyy") eq DateFormat(Now(), "dd-mm-yyyy")>

									<span class="newmessage">&nbsp;</span>

								<cfelse>

									&nbsp;

								</cfif>

							</td>
							<td class="bottomBorder">


								#linkTo(
									text=messagetitle,
									controller="Messages",
									action="view",
									class="ajaxlink",
									key=messageid,
									title=messagetitle)#

							</td>
							<td class="bottomBorder">


								#linkTo(
									text=Left(messagebody, 64)&"…",
									controller="Messages",
									action="view",
									key=messageid,
									class="ajaxlink",
									title=messagetitle)#

							</td>
							<td class="bottomBorder messageauthor">#givenname# #sn#</td>
							<td class="bottomBorder datetime">
								#DateFormat(messagecreated, "dd-mm-yyyy")#
							</td>
						</tr>
					<cfset lp++ />
					</cfloop>
				</tbody>

			</table>
		</div>

	</div>

</cfoutput>

<script type="text/javascript">

$(function() {
	$('.deletemessage').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();

		var string = "";

		$('input[type=checkbox]').each(function(e) {
			string += (this.checked) ? $(this).attr('value') + ":" : "";
		});

		$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		{messageid:string},
    		url			:		<cfoutput>"#URLFor(controller='Messages',action='delete',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();

    		}
    	});

	});
});

</script>