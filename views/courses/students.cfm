<div class="wrapper courses">
	
	<h3>Lista studentów</h3>
	
	<cfoutput>#includePartial("tabmenu")#</cfoutput>
	
	<cfoutput>
		
		<div class="intranet-backlink">
			<a href="#URLFor(controller='Courses', action='new')#">Nowy kandydat</a>
		</div>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div class="wrapper formbox">
			#textFieldTag(name="student-search", label="Szukaj", labelPlacement="before")#
		</div>
		
		<table class="tables courses-table">
			<thead>
				<tr>
					<th>L.p.</th>
					<th></th>
					<!---<th>Id</th>--->
					<th>
						<a href="##" class="student-sort" data-orderby="name" data-order="desc">Imię i nazwisko</a>
					</th>
					<th>
						<a href="##" class="student-sort" data-orderby="studentid" data-order="desc" title="Identyfikator">Ident.</a>
					</th>
					<th>Rodzaj</th>
					<th style="width:120px;">Status</th>
					<th>E-mail</th>
					<th>Telefon</th>
					<th style="width:80px;">
						<a href="##" class="student-sort" data-orderby="createddate" data-order="desc">Data dodania</a>
					</th>
					<!---<th>Szkolenia</th>--->
					
					<th style="width:65px;"></th>
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td>
						#selectTag(name="student-type", options=studenttypes, includeBlank="wszystkie", class="table-select table-student-type")#
					</td>
					<td>
						#selectTag(name="student-status", options=studentstatuses, includeBlank="wszystkie", class="table-select table-student-status")#
					</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</thead>
			<tbody id="courses-table-tbody">
				
				 #includePartial("students")#
				
			</tbody>
		</table>
		
		<div class="paginator"></div>
	
	</cfoutput>
	
</div>
<!---<cfdump var="#students#" />--->
<script>
	$(function(){
		
		$(".course-btn").on("click",function(){
			window.location = <cfoutput>"#URLFor(action='view')#"</cfoutput> + "&key=" + $(this).data("id");
		});
		
		$("#student-search").on("keyup", function(){
			
			var qSearch = $(this).val();
			
			if(qSearch.length==0 || qSearch.length > 2){
				reloadData(qSearch,$("#student-type").val(),$("#student-status").val());
			}
			
		});
		
		$("#student-type").on("change",function(){
			
			reloadData('',$(this).val(),$("#student-status").val());
		});
		
		$("#student-status").on("change",function(){
			
			reloadData('',$("#student-type").val(),$(this).val());
		});
		
		$(".student-sort").on("click",function(){
			
			reloadData('',$("#student-type").val(),$(this).val(),$(this).data("orderby"),$(this).data("order"));
			
			if($(this).data("order") == 'desc')
				$(this).data("order","asc");
			else
				$(this).data("order","desc");
			
			return false;
		});
		
		$(".paginator").on("click",".paginlink",function(){
			
			var qSearch = $("#student-search").val();
			if (qSearch.length == 0 || qSearch.length > 2) {
				qSearch = '';
			}
			
			reloadData(qSearch,$("#student-type").val(),$("#student-status").val(),null,null,$(this).data("page"));
			
			return false;
		});
		
		$("#courses-table-tbody").on("click", ".student_remove", function(){
			
			if(!confirm("Czy na pewno usunąć tego kandydata?")){
				return false;
			}
		});
	});
	
	function reloadData(search,type,status,orderby,order,page) {
		
		orderby = typeof orderby !== 'undefined' && orderby !== null ? orderby : 'id';
		order = typeof order !== 'undefined' && order !== null ? order : 'desc';
		page = typeof page !== 'undefined' ? page : 1;
		
		$("#flashMessages").show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	<cfoutput>"#URLFor(action='students')#"</cfoutput> + '&search=' + search + '&type=' + type + '&status=' + status + '&order=' + order + '&orderby=' + orderby + '&page=' + page,
			success		:	function(data) {
					
				$("#courses-table-tbody").html(data);
				$("#flashMessages").hide();
			},
			error : function(){
				alert("Błąd pobierania danych. Spróbuj później.");
				$("#flashMessages").hide();
			}
		});
	}
</script>
<!---<cfdump var="#courses#" />--->
<!---<cfdump var="#students#"/>--->