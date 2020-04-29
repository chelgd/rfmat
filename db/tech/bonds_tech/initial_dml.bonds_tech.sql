DO $do$
BEGIN

	truncate tech.bonds_tech
	;
	
	insert into tech.bonds_tech 
	select 
		bond_id,
		isin as src_id,
		md5 (
		coalesce(name, 'none')        								  ||
		coalesce(type, 'none')        	  							  ||
		coalesce(nominal, 0)          								  ||
		coalesce(coupon_amount, 0)   									  ||
		coalesce(coup_paym_date, '5999-01-01')   ||
		coalesce(exp_date, '5999-01-01') 
		) as hash,
		'quik' as system_name,
		'I' as dml,
		now() as update_dttm		
	from dds.bonds_v
	;
	
 
END;
$do$

