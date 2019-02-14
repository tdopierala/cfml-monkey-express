<!---
<!---<cfimage action="writeToBrowser" source="#zdjecie.wartoscbinaria#">--->

<cfheader name="content-length" value="#ArrayLen(zdjecie.wartoscbinaria)#" />
 
<!---
Set the file name of the inline graphic to be the name
of the hottie record.
--->
<cfheader name="content-disposition" value="inline; filename=#zdjecie.wartosctekst#" />
 
<!--- Stream the binary image data to the user. --->
<cfcontent type="image/*" variable="#zdjecie.wartoscbinaria#" reset="true" />
--->

<cfdump var="#zdjecie#" />