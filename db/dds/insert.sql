insert into dds.bon_trans_day 
select
row_number () over () as bond_id,
acmltd_coupon_inc,
duration,
date(now())	transaction_dttm
from ods.bonds ;



insert into dds.bonds_transactions 
select
row_number () over () as bond_id,
lst_deal_price ,
weighted_price ,
prc_change numeric NULL,
timestampadd()	transaction_dttm
from ods.bonds ;



insert into dds.bonds_valid 
select
row_number () over () as bond_id,
name,
type,
nominal,
coupon_amount,
coup_paym_date,
exp_date,
date(now()) as valid_from_dt,
date('5999-01-01') as valid_to_dt,
'I' as dml,
1 as act_flg
from ods.bonds ;



insert into dds.stocks_valid 
select
row_number () over () as stocks_id,
name,
tool_code,
lot,
class_code,
date(now()) as valid_from_dt,
date('5999-01-01') as valid_to_dt,
'I' as dml,
1 as act_flg
from ods.stocks ;



insert into dds.stocks_transactions
select
row_number () over () as stocks_id,
weighted_price,
last_price,
open_price,
prc_change,
flow,
timestampadd()	transaction_dttm
from ods.stocks ;
