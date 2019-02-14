<div class="edit_invoice_div">
	<cfform 
		action="#URLFor(controller='Documents',action='actionEdit',key=documentid)#" >
	
	<table class="admin_table">
		<thead>
			<tr>
				<th class="first">&nbsp;</th>
				<th>Nazwa pola</th>
				<th>Wartość</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="document_attributes">
				<tr>
					<td class="first">&nbsp;</td>
					<td><cfoutput>#attributename#</cfoutput></td>
					<td>
						<cfinput
							name="documentattributevalue[#documentattributevalueid#]"
							type="text"
							value="#documentattributetextvalue#" />
					</td>
				</tr>
			</cfloop>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="3" class="r">
					<cfinput
						type="submit"
						value="Zapisz"
						name="submit_document_edit"
						class="admin_button green_admin_button" />
				</td>
			</tr>
		</tfoot>
	</table>
	
	</cfform>
	
</div>