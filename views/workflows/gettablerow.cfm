<cfoutput>
<tr class="#rand#">
	<td class="leftBorder bottomBorder">
		#textFieldTag(
			name="workflow[table[#rand#][mpk]]",
			class="input searchmpk")#
		#hiddenFieldTag(
			name="workflow[table[#rand#][mpkid]]",
			class="input")#
	</td>
	<td class="leftBorder bottomBorder">
		#textFieldTag(
			name="workflow[table[#rand#][project]]",
			class="input searchproject")#
		#hiddenFieldTag(
			name="workflow[table[#rand#][projectid]]",
			class="input")#
	</td>
	<td class="leftBorder rightBorder bottomBorder"><input type="text" class="smallInput c priceelement"  name="workflow[table[#rand#][price]]" /></td>
	<td class="rightBorder bottomBorder">
		#linkTo(
			text=imageTag("delete.png"),
			controller="Workflows",
			action="ajaxDeleteDescriptionById",
			key=rand,
			class="deleteRow visible permanentlyDeleteRow")#
		
		#hiddenFieldTag(
			name="workflowstepdecriptionid-#rand#",
			value=rand,
			class="workflowstepdecriptionid")#
	</td>
</tr>
</cfoutput>