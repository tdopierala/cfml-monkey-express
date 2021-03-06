<cfoutput>
<h4>Aktualności <span class="postscount">(#myposts.RecordCount#)</span> <span class="showhideposts">pokaż/ukryj</span></h4>

<div class="usersposts">

	<cfloop query="myposts">
	
		<div class="singlepost">
		
			<cfif Len(filename)>
				<a href="files/posts/tmp/#filename#" >
					<cfimage 
						action="writeToBrowser" 
						source="#expandPath('files/posts/thumb/#filename#')#" />
				</a>
			</cfif>
		
			<h5>Użytkownik 
					#linkTo(
						text="#givenname# #sn#",
						controller="Users",
						action="view",
						key=userid)# 
					napisał 
					#linkTo(
						text=posttitle,
						controller="Posts",
						action="view",
						key=postid)#</h5>
			<div class="posttext">	
				#postcontent#
			</div>

			<div class="postfooter">
				Dodane przez 
					#linkTo(
						text="#givenname# #sn#",
						controller="Users",
						action="view",
						key=userid)# 
				dnia #DateFormat(postcreated, "dd.mm.yyyy")# o godzinie #TimeFormat(postcreated, "HH:mm")#
			</div>
		
		</div>
	
	</cfloop>

</div>

</cfoutput>