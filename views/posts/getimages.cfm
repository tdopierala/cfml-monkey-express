<cfoutput>
	
	<cfset dir = DirectoryList(ExpandPath("files/posts/thumb/"), false, "name", "", "datelastmodified DESC") />
	<cfloop array="#dir#" index="singlefile" >
		<cfset tmp_img = imageNew("#ExpandPath("files/posts/thumb/#singlefile#")#") />
		<cfset imageResize(tmp_img, "", "50", "highestperformance") />
		<div class="postimage c">
			<cfimage action="writeToBrowser" source="#tmp_img#" /> <br />
			<input type="radio" name="filename" value="#singlefile#" />
		</div>
	</cfloop>
	
</cfoutput>