<div class="wrapper">

	<div class="assigned files">
		<h5>Przypisane pliki</h5>
		
		<table class="newtables">
			<thead>
				<tr class="top">
					<th colspan="6" class="bottomBorder"></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="placefiles">
					<tr>
						<td class="bottomBorder">
						
							<cfoutput>
							
								#checkBoxTag(
									name="placefile",
									class="placefilecheckbox")#
							
							</cfoutput>
						
						</td>
						<td class="bottomBorder"><cfoutput>#placefilecategoryname#</cfoutput></td>
						<td class="bottomBorder">
						
							<cfoutput>
								#DateFormat(filecreated, "dd-mm-yyyy")# #TimeFormat(filecreated, "HH:mm")#
							</cfoutput>
						
						</td>
						<td class="bottomBorder">
						
							<cfoutput>
								#linkTo(
									text="#givenname# #sn#",
									controller="Users",
									action="view",
									key=userid,
									title="Idź do profilu #givenname# #sn#")#
								
							</cfoutput>
						
						</td>
						<td class="bottomBorder"></td>
						<td class="bottomBorder">
							
							<cfoutput>
							
								#linkTo(
									text='<span class="">link</span>',
									href='files/uploaded/#filename#',
									target='_blank',
									class='placefilepreview')#
							
								#linkTo(
									text='<span class="placefilemore unselected" id="#fileid#"></span>',
									controller="Files",
									action="getComments",
									key=fileid,
									class="ajaxplacefilemore",
									title="więcej...")#

							</cfoutput>						
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

	</div>
</div>

<div class="wrapper">

	<div class="addfiletoplace">
	
		<h5>Dodaj nowy plik</h5>
	
		<div id="file-uploader">		
			<noscript>			
				<p>Strona wymaga włączonej obsługi JavaScript.</p>
			</noscript>         
		</div>
	    
	    <script src="<cfoutput>http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/fileuploader.js</cfoutput>" type="text/javascript"></script>
	    <script>        
	        $(function() {
	        	var uploader = new qq.FileUploader({
	        		element		:	document.getElementById('file-uploader'),
	        		action		:	"<cfoutput>#URLFor(controller='Uploader',action='upload',params='&format=json')#</cfoutput>",
	        		onComplete	:	function(id, fileName, responseJSON){
	        			
	        			<!---
	        			Po zapisaniu pliku na dysku i w bazie generuje listę z kategoriami plików.
	        			Po wybraniu kategorii mogę przyporządkować plik i zapisać ustawienia w bazie.
	        			--->
	        			
	        			var liid = id;
	        			<!--- Pobieram AJAXowo typy plików do nieruchomości --->
	        			$('#flashMessages').show();
	        			$.ajax({
							type		:		'post',
							dataType	:		'html',
							data		:		{fileid:responseJSON.fileid,placeid:<cfoutput>#placeid#</cfoutput>},
							url			:		<cfoutput>"#URLFor(controller='Places',action='getFileCategories',params='cfdebug')#"</cfoutput>,
							success		:		function(data) {
								$('.qq-upload-list li.qq-upload-success:eq('+liid+')').append(data);
								$('#flashMessages').hide();
							}
						});
	        			
	        		}
	        	});
	        	
	        });    
	    </script>
	
	</div> <!--- Koniec addfiletoplace --->
</div>