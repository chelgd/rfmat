DO $do$
BEGIN

----------------------Обновлённые версионные данны---------------

	update test_tech.bonds_tech a
	
	set hash = b.ods_hash,
	dml_type = 'U',
	update_dttm = now()
	
	
	from (
	
		with base as (select 
			a.name,
			md5 (a.type         ||
			a.nominal          ||
			a.coupon_amount    ||
			a.coup_paym_date   ||
			a.exp_date) as ods_hash 
		from ods.bonds a )
		
		select 
			b.src_id,
			a.ods_hash
		from base a 
		
		inner join test_tech.bonds_tech b 
		on a.name = b.src_id 
		
		where a.ods_hash <> b.hash
	
	) b
	
	where a.src_id = b.src_id
	;
 
END;
$do$ 
 
 
 