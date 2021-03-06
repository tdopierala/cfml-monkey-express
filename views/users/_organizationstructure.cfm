<cfoutput>

	<h5>Struktura organizacyjna</h5>
	<ul class="level0">
		<cfloop query="organizationstructure">
			<li>
				#linkTo(
					text="<span></span>#givenname# #sn#",
					controller="Users",
					action="view",
					key=id,
					title="Profil użytkownika #givenname# #sn#")#
					
				<span class="position">#position#</span>
				
				<cfif size>
				
					#linkTo(
						text="rozwiń/zwiń",
						controller="Users",
						action="getBranch",
						key=id,
						title="Pobierz strukturę organizacyjną dla #givenname# #sn#",
						class="ajaxexpand {id:#id#,lft:#lft#,rgt:#rgt#}")#
				
				</cfif>
				
				<span class="bottom"></span>
				
			</li>
		</cfloop>
	</ul>

</cfoutput>

<script>
$(function() {

	$('.ajaxexpand').live('click', function(e) {
		
		e.preventDefault();
		$('#flashMessages').show();
		
		var lft = $(this).metadata().lft;
		var rgt = $(this).metadata().rgt;
		var id = $(this).metadata().id;
		var thisa = $(this);
		var thisli = $(this).parent();
		
		$.ajax({
			type			:		'post',
			dataType		:		'html',
			data			:		{id:id,lft:lft,rgt:rgt},
			url				:		$(this).attr('href'),
			success			:		function(data) {
				if (thisli.has('ul').length)
					thisli.find('ul').remove();
				else
					thisli.append(data);
					
				$('#flashMessages').hide();
			}
		});
	});
	
	$('.ajaxgetdepartmentusers').live('click', function(e) {
		
		e.preventDefault();
		var thisli = $(this).parent();
		
		if ($(this).is('.expanddepartment')) {

			$('#flashMessages').show();
			$(this).removeClass('expanddepartment');
			$(this).addClass('contractdepartment');
			
			$.ajax({
				type		:		'post',
	    		dataType	:		'html',
	    		data		:		{departmentname:$(this).html()},
	    		url			:		$(this).attr('href'),
	    		success		:		function(data) {
	    			thisli.append(data);
	    			$('#flashMessages').hide();
	    			
	    		}
			});
		
		} else {
		
			$(this).removeClass('contractdepartment');
			$(this).addClass('expanddepartment')
			
			thisli.find('ul').animate({'height' : 0}, 400, function() {
				$(this).remove();
			});
		
		}
		
	});
});
</script>