<cfheader name="Content-Disposition" value="inline; filename=#Replace( pdfInstruction.instruction_number, '/', '_', 'All' )#_#DateFormat(Now(), 'dd_mm_yyyy')#.pdf" /> 
<cfcontent type="application/pdf" variable="#ToBinary( ToBase64( mergedInstruction ) )#" />