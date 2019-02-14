<cfsilent>
	<cfinclude template="../include/place_privileges.cfm" />
</cfsilent>

<cfoutput >

	<div class="wrapper">
		<div class="admin_wrapper">

			<h2 class="place_formedit">#myform.formname#</h2>

			<cfform
				action="#URLFor(controller='Place_instances',action='submitForm',params='instanceid=#myinstance#&formid=#myform.id#')#" >

			<cfinput
				type="hidden"
				name="AUTO_SAVE_URL"
				value="#URLFor(controller='Place_instances',action='autosave')#" />

			<table class="admin_table">

				<thead>

					<tr>

						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość</th>
						<th>Komentarze</th>

					</tr>

				</thead>

				<tbody>

					<cfloop query="myfields" >

						<cfset cls = "" />

						<cfif required eq 1>
							<cfset cls = "required" />
						</cfif>

						<tr>
							<td>&nbsp;</td>
							<td>#fieldname#</td>
							<td>

								<cfif fieldtypeid eq 4>
									<select name="field[#id#]" id="field-#id#" class="select_box selectbox #cls#" <cfif accepted neq 0>disabled="disabled"</cfif>>
										<cfset tmp = myoptions[fieldid] />
										<cfset tmp2 = formfieldvalue />
										<cfloop query=tmp>
											<cfset val2 = Replace(val, '"', "", "All") />
											<option value="#Replace(id, '"', "", "All")#" <cfif val2 eq tmp2> selected="selected"</cfif>>#Replace(val, '"', "", "All")#</option>
										</cfloop>
									</select>
								<cfelseif fieldtypeid eq 1>

									<cfif accepted neq 0>

										<cfinput
											type="text"
											name="field[#id#]"
											value="#formfieldvalue#"
											label="false"
											class="input #cls# #class#"
											disabled="disabled" />

									<cfelse>

										<cfinput
											type="text"
											name="field[#id#]"
											value="#formfieldvalue#"
											label="false"
											class="input #cls# #class#" />

									</cfif>

								<cfelseif fieldtypeid eq 3>

									<cfif accepted neq 0>

										#textAreaTag(
										name="field[#id#]",
										content=formfieldvalue,
										disabled="disabled",
										class="textarea ckeditor #cls# {id:#id#}")#

									<cfelse>

										#textAreaTag(
										name="field[#id#]",
										content=formfieldvalue,
										class="textarea ckeditor #cls# {id:#id#}")#

									</cfif>

								<cfelseif fieldtypeid eq 2>

									<cfif accepted neq 0>

										#checkBoxTag(
										name="field[#id#]",
										value="1",
										disabled="disabled",
										selected=YesNoFormat(formfieldvalue),
										class="#cls#")#

									<cfelse>

										#checkBoxTag(
										name="field[#id#]",
										value="1",
										selected=YesNoFormat(formfieldvalue),
										class="#cls#")#

									</cfif>


								<cfelseif fieldtypeid eq 7>

									<cfif accepted neq 0>

										<cfinput
											type="file"
											name="file[#id#]"
											disabled="disabled"
											label="false"
											class="#cls#" />

									<cfelse>

										<cfinput
											type="file"
											name="file[#id#]"
											label="false"
											class="#cls#" />

									</cfif>

								</cfif>
							</td>
							<td>
								#linkTo(
									text="<span>Pobierz komentarze</span>",
									controller="Place_instanceformcomments",
									action="getInstanceFormComments",
									key=id,
									class="place_comments show_comments")#
								(#commentscount#)
							</td>
						</tr>
					</cfloop>

				</tbody>

				<tfoot>

					<tr>

						<td colspan="4" class="r">

							<cfif checkAccess(privileges=myPrivilege.placeformprivileges.rows,itemname="formid",itemvalue=myform.id,accessname="acceptprivilege") >

								#linkTo(
									text="Akceptuje formularz",
									controller="Place_forms",
									action="acceptForm",
									params="instanceid=#myinstance#&formid=#myform.id#",
									class="small_admin_button green_admin_button")#

							</cfif>

								#submitTag(value="Zapisz",class="submit_form admin_button green_admin_button")#

						</td>

					</tr>

				</tfoot>

			</table>

			</cfform>

		</div>
	</div>

</cfoutput>

<script>
$(function(){

	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});

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

	$(".submit_form").live("click", function(e) {

		var errors = false;

		$('.required').removeClass('redborder');
		$('.required').each(function (index) {
    		if(!$(this).attr('value') != '') {
				errors = true;
    			$(this).addClass('redborder');
    		}
    	});
		if (errors) return false;
	});

	<!---
		Autouzupełnianie miast
	--->
	$(".dictionary_city").autocomplete({
		source: function(request, response) {
			$.ajax({
				url: "<cfoutput>#URLFor(controller='teryt',action='miasta')#</cfoutput>",
				dataType: "json",
				data: {
					featureClass: "P",
					style: "full",
					maxRows: 12,
					name_startsWith: request.term
				},
				success: function(data) {
					response($.map(data.ROWS, function(item) {
						return {
							label: item.NAZWA,
							value: item.NAZWA
						}
					}));
				}
			});
		},
		minLength: 3
	});

	<!---
		Autouzupełnianie ulic
	--->
	$(".dictionary_street").autocomplete({
		source: function(request, response) {
			$.ajax({
				url: "<cfoutput>#URLFor(controller='teryt',action='ulice')#</cfoutput>",
				dataType: "json",
				data: {
					featureClass: "P",
					style: "full",
					maxRows: 12,
					name_startsWith: request.term
				},
				success: function(data) {
					response($.map(data.ROWS, function(item) {
						return {
							label: item.CECHA + " " + item.NAZWA_1,
							value: item.CECHA + " " + item.NAZWA_1
						}
					}));
				}
			});
		},
		minLength: 3
	});

});
</script>