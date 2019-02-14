CREATE DEFINER=`intranet`@`%` PROCEDURE `p_updatecron_invoicereports`()
begin

 declare l_contractorid int(11);
 declare l_nip text character set utf8;
 declare no_more_cron_invoice_reports int default false;
 declare croninvoicereportscursor cursor for select contractorid from cron_invoicereports;
 declare continue handler for not found set no_more_cron_invoice_reports = true;

 open croninvoicereportscursor;
   LOOP2: loop
     fetch croninvoicereportscursor into l_contractorid;
       if no_more_cron_invoice_reports then
         close croninvoicereportscursor;
         leave LOOP2;
       end if;
     set l_nip = (select nip from contractors where id = l_contractorid);
     update cron_invoicereports set nip = l_nip where contractorid = l_contractorid;

   end loop LOOP2;

end
