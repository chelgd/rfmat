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
		coalesce(to_date(coup_paym_date, 'dd.mm.yyyy'), '5999-01-01')   ||
		coalesce(to_date(exp_date, 'dd.mm.yyyy'), '5999-01-01') 
		) as hash,
		'quik' as system_name,
		'I' as dml_type,
		now() as update_dttm		
	from dds.bonds_v
	;
	
 
END;
$do$

