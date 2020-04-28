CREATE TABLE dds.bonds_v (
	bond_id int8 NULL,
	isin text null,
	name text NULL,
	"type" text NULL,
	nominal int8 NULL,
	coupon_amount numeric NULL,
	coup_paym_date date NULL,
	exp_date date NULL,
	valid_from_dt date NULL,
	valid_to_dt date NULL,
	dml text NULL,
	act_flg int8 NULL
);