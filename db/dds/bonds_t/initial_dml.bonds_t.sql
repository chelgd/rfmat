DO $do$
BEGIN

	truncate dds.bonds_t
	;

	insert into dds.bonds_t 
	select
		b.bond_id,
		a.lst_deal_price, 
		a.weighted_price, 
		a.prc_change, 
		now() as transaction_dttm 	
	from ods.quik_bonds a
	
	left join tech.bonds_tech b
	on a.isin = b.src_id
	;
 
END;
$do$ 