<cfprocessingdirective pageencoding="utf-8" />
	
<div class="wrapper">
	<div class="admin_wrapper">
		<h2 class="tree_groups">Struktura pytań</h2>
		
		<div class="tree_group_admin">
			<div class="inner">
				<ul>
					<li>
						<cfoutput>#linkTo(
							text="<span>Dodaj pytanie</span>",
							controller="Insurance_questions",
							action="add",
							class="new_insurance_question")#</cfoutput>
					</li>
				</ul>
			</div>
		</div>
		
		<div class="tree_group_users_search">
			<div class="inner">
				<h5>Wybierz kategorię aby edytować pytania</h5>
				
				<cfform action="javascript:void(0)" name="insurance_question_select_category_form">
					<ol class="vertical">
						<li>
							<select name="categoryid" id="categoryid" class="select_box">
								<cfoutput query="categories">
									<option value="#id#">#categoryname#</option>
								</cfoutput>
							</select>
						</li>
					</ol>
				</cfform>
				
			</div>
		</div>
		
		<div class="tree_group_structure_container">
			
		</div>
		
	</div>
</div>

<script type="text/javascript">
$(function() {
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/insurance\.admin\.questions.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/insurance.admin.questions.js");
	}
});
</script>