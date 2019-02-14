delimiter $$

CREATE DEFINER=`intranet`@`%` PROCEDURE `sp_intranet_invoice_get_user_invoice_templates`(
	in user_id int(11)
)
begin

	select
		id as id
		,invoice_template_name as invoicetemplatename
		,invoice_template_description as invoicetemplatedescription
	from invoice_templates
	where userid = user_id;

end$$

