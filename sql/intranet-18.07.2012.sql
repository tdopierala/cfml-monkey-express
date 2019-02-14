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
drop procedure if exists sp_intranet_users_get_root_branch$$create definer = 'intranet' procedure sp_intranet_users_get_root_branch (  in t_lft int(4),  in t_rgt int(4))begin  select     id,
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
    size  from view_users as node  where node.lft between t_lft and t_rgt  order by node.lft;end$$