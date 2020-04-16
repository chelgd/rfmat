insert into tech.bonds_tech 
select 
bond_id,
name as src_id,
md5(type         ||
nominal          ||
coupon_amount    ||
coup_paym_date   ||
exp_date) as hash,
'quik' as system_name,
'I' as dml_type,
now() as update_dttm

from dds.bonds_v


