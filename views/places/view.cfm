<cfoutput>

	<div class="wrapper">
	
		<h3>#place.cityname#, #place.address#</h3>
		
		<div class="wrapper">
		
			<div class="tabsHeader">
				<ul>
					<li>
						#linkTo(
							text="Historia zmian",
							controller="Places",
							action="preview",
							key=place.id,
							class="ajaxlink")#
					</li>
					
					<li>	
					
						<cfif NOT Len(workflow.step1status)>
						
							#linkTo(
								text="<span class=''>Partner</span>",
								controller="Places",
								action="partner",
								key=place.id,
								class="inactive")#
							
						<cfelseif Len(workflow.step1status) AND workflow.step1status eq 1>
						
							#linkTo(
								text="<span class=''>Partner</span>",
								controller="Places",
								action="partner",
								key=place.id,
								class="ajaxlink")#
							
						<cfelse>
						
						#linkTo(
							text="<span class='strakethrough'>Partner</span>",
							controller="Places",
							action="partner",
							key=place.id,
							class="ajaxlink inactive")#
						  
						</cfif>
											
					</li>
					<li>
						<cfif NOT Len(workflow.step2status)>
						
							#linkTo(
							text="<span class=''>Weryfikacja</span>",
							controller="Places",
							action="acceptation",
							key=place.id,
							class="inactive")#
							
						<cfelseif Len(workflow.step2status) AND workflow.step2status eq 1>
						
							#linkTo(
								text="<span>Weryfikacja</span>",
								controller="Places",
								action="acceptation",
								key=place.id,
								class="ajaxlink")#
							
						<cfelse>
						
						#linkTo(
							text="<span class='strakethrough'>Weryfikacja</span>",
							controller="Places",
							action="acceptation",
							key=place.id,
							class="ajaxlink inactive")#
						  
						</cfif>
					</li>
					<li>
						
						<cfif NOT Len(workflow.step3status)>
						
							#linkTo(
								text="<span class=''>Uzupełnienie danych</span>",
								controller="Places",
								action="supplement",
								key=place.id,
								class="inactive")#
							
						<cfelseif Len(workflow.step3status) AND workflow.step3status eq 1>
						
							#linkTo(
								text="<span>Uzupełnienie danych</span>",
								controller="Places",
								action="supplement",
								key=place.id,
								class="ajaxlink")#
							
						<cfelse>
						
							#linkTo(
								text="<span class='strakethrough'>Uzupełnienie danych</span>",
								controller="Places",
								action="supplement",
								key=place.id,
								class="ajaxlink inactive")#
						  
						</cfif>
						
					</li>
					<li>
					
						<cfif NOT Len(workflow.step4status)>
						
							#linkTo(
								text="<span class=''>Komitet</span>",
								controller="Places",
								action="committee",
								key=place.id,
								class="inactive ")#
							
						<cfelseif Len(workflow.step4status) AND workflow.step4status eq 1>
						
							#linkTo(
								text="<span>Komitet</span>",
								controller="Places",
								action="committee",
								key=place.id,
								class="ajaxlink")#
							
						<cfelse>
						
							#linkTo(
								text="<span class='strakethrough'>Komitet</span>",
								controller="Places",
								action="committee",
								key=place.id,
								class="ajaxlink inactive")#		
											  
						</cfif>
						
					</li>
					<li>
					
						<cfif NOT Len(workflow.step5status)>
						
							#linkTo(
								text="<span class=''>Umowa</span>",
								controller="Places",
								action="agreement",
								key=place.id,
								class="inactive")#
							
						<cfelseif Len(workflow.step5status) AND workflow.step5status eq 1>
						
							#linkTo(
							text="<span>Umowa</span>",
							controller="Places",
							action="agreement",
							key=place.id,
							class="ajaxlink")#
							
						<cfelse>
						
							#linkTo(
							text="<span class='strakethrough'>Umowa</span>",
							controller="Places",
							action="agreement",
							key=place.id,
							class="ajaxlink inactive")#	
											  
						</cfif>
					
					</li>
<!---
					<li>
						#linkTo(
							text="<span>Lokalizacja</span>",
							controller="Places",
							action="location",
							key=place.id,
							class="ajaxlink")#
					</li>
--->
					<li>
						#linkTo(
							text="<span>Załączone pliki</span>",
							controller="Places",
							action="files",
							key=place.id,
							class="ajaxlink")#
					</li>
					<li>
						#linkTo(
							text="<span>Galeria zdjęć</span>",
							controller="Places",
							action="photos",
							key=place.id,
							class="ajaxlink")#
					</li>
					
					<li class="fltr">
						#linkTo(
							text="<span>Mapy</span>",
							controller="Maps",
							action="placeMaps",
							key=place.id,
							class="ajaxlink maps")#
					</li>
				</ul>
			</div>
		
		</div>
		
		<div class="ajaxcontent"></div>
	
	</div>

</cfoutput>
<script>
$(function() {

	if ($.trim($('.ajaxcontent').text()) == '') 
	{
		$('#flashMessages').show();
		$.ajax({
			data		:		$(this).serialize(),
			type		:		"post",
			dataType	:		"html",
			url			:		<cfoutput>"#URLFor(controller='Places',action='preview',key=place.id)#"</cfoutput>,
			success		:		function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			}
		});

	}

	$('.filetoplaceform').live('submit', function(e) {
		e.preventDefault();
		var myform = $(this);
		$('#flashMessages').show();
		$.ajax({
			data		:		$(this).serialize(),
			type		:		"post",
			dataType	:		"html",
			url			:		$(this).attr("action"),
			success		:		function(data) {
				myform.parent().after(data);
				myform.parent().remove();
				$('#flashMessages').hide();
			}
		});
		return false;
	});
	
	$(".ajaxplacefilemore").live("click", function(e) {
		e.preventDefault();
		var row = $(this).parent().parent();
		$(this).removeClass($(this).attr("class"));
		$(this).addClass('ajaxplacefilehide');
		$('#flashMessages').show();	
		$.ajax({
			type:"post",
			dataType:"html",
			url:$(this).attr("href"),
			success:function(data) {
				var comments = "<tr><td colspan=\"6\">"+data+"</td></tr>";
				row.after(comments);
				$("#flashMessages").hide();
			}
		});
	});
	
	$(".ajaxplacefilehide").live("click", function(e) {
		e.preventDefault();
		$(this).removeClass($(this).attr("class"));
		$(this).addClass("ajaxplacefilemore");
		$(this).parent().parent().next().remove();
	});	
	
	$('.togglemapname').live('click', function(e) {
		e.preventDefault();
		$('.mapnameelement').toggle('fast');
	});
		
});
</script>