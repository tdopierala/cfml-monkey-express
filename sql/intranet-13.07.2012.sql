SELECT 
  Year(data_wplywu) as year, 
  Month(data_wplywu) as month, 
  Day(data_wplywu) as day,
  count(*) as count, 
  sum(netto) as sumnetto, 
  avg(netto) as avgnetto, 
  sum(brutto) as sumbrutto, 
  avg(brutto) as avgbrutto, 
  sum(brutto)-sum(netto) as tax
from cron_invoicereports
GROUP BY Year(data_wplywu), Month(data_wplywu), Day(data_wplywu);

SELECT 
  Year(data_platnosci) as year, 
  Month(data_platnosci) as month, 
  count(*) as count, 
  sum(netto) as sumnetto, 
  avg(netto) as avgnetto, 
  sum(brutto) as sumbrutto, 
  avg(brutto) as avgbrutto, 
  sum(brutto)-sum(netto) as tax
from cron_invoicereports
GROUP BY Year(data_platnosci), Month(data_platnosci)

