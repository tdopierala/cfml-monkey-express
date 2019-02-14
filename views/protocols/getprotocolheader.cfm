<cfoutput>
	<h4>Nagłówek protokołu</h4>
	<ol>
		<cfloop query="protocolattributes">
		
			<cfif attributerequired is 1>
							
				<cfset requiredclass = " required" />
			
			<cfelse>
			
				<cfset requiredclass = "" />
			
			</cfif>
			
			<li>
			<cfif attributetypeid eq 1>
			
				#textFieldTag(
					name="protocolheader[#attributeid#]",
					label=attributename,
					class="input #requiredclass#",
					labelPlacement="before")#
			
			<cfelseif attributetypeid eq 2>
				
				#textAreaTag(
					name="protocolheader[#attributeid#]",
					label=attributename,
					class="textarea",
					labelPlacement="before")#
				
			</cfif>
			</li>
		
		</cfloop>
		
		<li>
			<div class="formfieldinformations">Pola oznaczone <span class="requiredfield">*</span> są wymagane.</div>
		</li>
			
	</ol>

</cfoutput>

<script type="text/javascript">
$(function () {
	/*
	 * Dodaje gwiazdki przy wymaganych polach formularza.
	 */
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
});
</script>