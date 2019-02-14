--
-- Procedura pobierająca korzeń drzewa urzytkowników
--
drop procedure if exists sp_intranet_users_get_root$$
create definer = 'intranet' procedure sp_intranet_users_get_root()
begin

  select
    id,
    active,
    login,
    photo,
    departmentid,
    givenname,
    sn,
    mail,
    samaccountname,
    departmentname,
    lft,
    rgt,
    parent_id,
    level,
    position,
    size
  from view_users
  where lft = 1;

end$$

--
-- Pobranie dzieci rodzica w drzewie
--
drop procedure if exists sp_intranet_users_get_root_branch$$
    active,
    login,
    photo,
    departmentid,
    givenname,
    sn,
    mail,
    samaccountname,
    departmentname,
    lft,
    rgt,
    parent_id,
    level,
    position,
    size