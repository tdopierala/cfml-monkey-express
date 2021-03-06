<cfoutput>

	<div class="wrapper">
	
		#linkTo(
			text="<span>w dół…</span>",
			href="##changestatus",
			class="placebutton fltr")#
		
		#linkTo(
			text="<span>PDF</span>",
			controller="Places",
			action="ExportToPdf",
			key=place.id,
			params="format=pdf",
			target="_blank",
			class="placebutton fltl")#
		
			
			<cfloop collection="#r#" item="i">

				<cfset q = r[i] />
				<cfloop collection="#q#" item="p">
				
					<cfset s = q[p] />
					<cfif s.recordCount>
					<dl class="places">
						<dt class="title">#p#</dt>
						<cfloop query="s">
							<dt>#attributename#</dt>
							<dd>#placeattributevaluetext#</dd>
						</cfloop>
						
					</dl>
				</cfif>
				
				</cfloop>
	
			</cfloop>
				
		<div class="clear"></div>
		
		#includePartial(partial="changestatus")#
	
	</div>

</cfoutput>

<script>
$(function() {
	$(".placetable tbody tr:even").css("backgroundColor", "#f7f7f7");
});	
</script>