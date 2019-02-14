<cfsilent>
	<cfinclude template="../include/place_privileges.cfm" />
</cfsilent>

<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">
			<h2 class="admin_placefiles">#filetype.filetypename#</h2>

			<cfif flashKeyExists("success")>
				<div class="success">
					#flash("success")#
				</div>
			</cfif>

			<cfif flashKeyExists("error")>
				<div class="error">
					#flash("error")#
				</div>
			</cfif>

			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Miniaturka</th>
						<th>Użytkownik</th>
						<th>Data dodania</th>
						<th>Nazwa pliku</th>
						<th>Komentarze</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="files">
						<tr>
							<td class="first">&nbsp;</td>
							<td class="c">

								<cfif Len(filetypethumb) AND fileExists("files.places/#filetypethumb#")>

									<cfimage
										source="#ExpandPath('files/places/#filetypethumb#')#"
										action="writeToBrowser" />

								<cfelse>
									
									<cfimage source="#expandPath('images/missing.png')#"
											 action="writeToBrowser" /> 
									
								</cfif>

							</td>
							<td>#givenname# #sn#<br/><span class="i">#position#</span></td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(filecreated, "yyyy-mm-dd")# #TimeFormat(filecreated, "HH:mm")#</td>
							<td>
								#linkTo(
									text=filename,
									href="files/places/#filesrc#",
									target="_blank")#
							</td>
							<td>
								#linkTo(
									text="<span>Pobierz komentarze</span>",
									controller="Place_files",
									action="getInstanceFileComments",
									key=id,
									class="place_comments show_comments")#
									(#commentscount#)
							</td>
							<td>
								<cfif checkAccess(privileges=myPrivilege.placefiletypeprivileges.rows,itemname="filetypeid",itemvalue=filetype.id,accessname="deleteprivilege") >
								<a
									href="#URLFor(controller='Place_files',action='delete',key=id)#"
									class="delete_photo">

									<span>Usuń plik</span>

								</a>

								<cfelse>
									&nbsp;
								</cfif>

							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>

			<h2 class="admin_newfile">Dodaj nowy plik</h2>

			<cfform
				action="#URLFor(controller='Place_files',action='actionAddInstanceFile',params='instanceid=#myinstance.instanceid#')#"
				enctype="multipart/form-data" >

				<cfinput
					name="instanceid"
					value="#myinstance.instanceid#"
					type="hidden" />

				<cfinput
					name="filetypeid"
					value="#filetype.id#"
					type="hidden" />

			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>&nbsp;</td>
						<td>Plik</td>
						<td>
							<cfinput
								type="file"
								name="filebincontent"
								label="false" />

							<span class="info">Maksymalna wielkość przesłanego pliku to 750KB</span>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Opis</td>
						<td>

							<cftextarea
								name="filetypedescription"
								richText="false"
								class="textarea ckeditor" />

						</td>
					</tr>
					<tr>
						<td class="r" colspan="3">
							<cfinput
								type="submit"
								name="submitInstanceFile"
								value="Zapisz"
								class="admin_button green_admin_button" >
						</td>
					</tr>
				</tbody>
			</table>

			</cfform>

		</div>
	</div>

</cfoutput>

<script>
$(function(){
	$(".show_comments").live("click", function(e) {
		$("#flashMessages").show();
		e.preventDefault();
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();

		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('show_comments').addClass('hide_comments');
				_point.after(data);
				$("#flashMessages").hide();
			}
		});
	});

	$(".hide_comments").live("click", function(e) {
		e.preventDefault();

		var _link		=	$(this);
		var _point		=	$(this).parent().parent();

		_point.next().remove();
		_link.removeClass('hide_comments').addClass('show_comments');
	});

	$(".submit_comment_form").live("click", function(e) {

		$("#flashMessages").show();
		e.preventDefault();

		var _form = $(this).closest("form");
		var _anchor = _form.closest("tr");

		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		_form.serialize(),
			url			:		_form.attr('action'),
			success		:		function(data) {
				_anchor.after(data);
				_form.find("textarea").val("");
				$("#flashMessages").hide();
			}
		});

	});

});
</script>