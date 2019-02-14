<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle"><cfoutput>#post.posttitle#</cfoutput></h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">

		<div class="usersposts">
			<div class="singlepost">
				<cfif Len(post.filename)>
					<cfimage
						action="writeToBrowser"
						source="#expandPath('files/posts/thumb/#post.filename#')#" />
				</cfif>

				<div class="posttext clearfix">
					<cfoutput>#post.postcontent#</cfoutput>
				</div>

				<div class="postattachments">
					<cfif myAttachments.recordCount>
						Załączniki 
						<cfloop query="myAttachments">
							<a href="files/posts/<cfoutput>#attachment_src#</cfoutput>" title="<cfoutput>#attachment_name#</cfoutput>" target="blank"><cfoutput>#attachment_name#</cfoutput></a>,
						</cfloop>
					</cfif>
				</div>

				<div class="postfooter">
				Dodane przez
					<cfoutput>#linkTo(
						text="#post.user.givenname# #post.user.sn#",
						controller="Users",
						action="view",
						key=post.userid)#
				dnia #DateFormat(post.postcreated, "dd.mm.yyyy")# o godzinie #TimeFormat(post.postcreated, "HH:mm")#</cfoutput>
				</div>
				<div class="clear"></div>
			</div>
		</div>

		<div class="uiFooter">

		</div>
	</div>
</div>

<div class="footerArea">

</div>
