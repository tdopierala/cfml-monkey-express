<cfoutput>
	<cfloop query="concessions">
		
		<tr>
			<td>#id#</td>
			<td>#statuses['name'][status]#</td>
			<td>#projekt#</td>
			<td>#DateFormat(createdate, "yyyy-mm-dd")#</td>
			<!---<td>#DateFormat(datefrom, "yyyy-mm-dd")#</td>--->
			<td>#username#</td>
			<td>
				#linkTo(
					text="Podgląd",
					controller="Concessions",
					action="view",
					key=id)#
			</td>
		</tr>
					
	</cfloop> 
</cfoutput>
<!---<cfdump var="#concessions#"/>--->
<cfoutput>
	<script>
		$(function(){
			$(".concession-paginator").html('');
			for(i=1; i<=#pages#; i++){
				var selected = ''; 
				if((#params.page#) == i) selected = 'selected';
				$(".concession-paginator").append(
					$("<a>").attr("href", "##").addClass("paginlink").addClass(selected).text(i).data("page", i)
				);
			}
		});
	</script>
</cfoutput>