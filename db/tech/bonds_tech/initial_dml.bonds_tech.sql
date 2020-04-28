DO $do$
BEGIN

	truncate tech.bonds_tech
	;
	
	insert into tech.bonds_tech 
	select 
		bond_id,
		isin as src_id,
		md5(name		 ||
		type             ||
		nominal          ||
		coupon_amount    ||
		coup_paym_date   ||
		exp_date) as hash,
		'quik' as system_name,
		'I' as dml_type,
		now() as update_dttm		
	from dds.bonds_v
	;
	
 
END;
$do$

