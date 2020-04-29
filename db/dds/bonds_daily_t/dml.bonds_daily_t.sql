DO $do$
BEGIN

	insert into dds.bonds_daily_t 
	select	
		b.bond_id,
		a.acmltd_coupon_inc,
		a.duration,
		now() as transaction_dttm 	
	from ods.quik_bonds a
	
	left join tech.bonds_tech b
	on a.isin = b.src_id
	;
 
END;
$do$ 