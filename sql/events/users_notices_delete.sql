CREATE EVENT `users_notices_delete` ON SCHEDULE EVERY 1 DAY STARTS '2014-01-14 23:59:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

DELETE FROM intranet.users_notices WHERE status = 4 OR date <  DATE_SUB(CURDATE(),INTERVAL 30 DAY);

INSERT INTO users_notices (`userid`, `message`, `date`)
VALUES (345, concat('Powiadomienia usuniete'), NOW());

END