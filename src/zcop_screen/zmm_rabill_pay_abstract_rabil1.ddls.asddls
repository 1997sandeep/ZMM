@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch Rabill No for Advance&Recovery'
define root view entity ZMM_RABILL_PAY_ABSTRACT_RABIL1
  as select from zmmt_scp_rab_ad1 as a
{
  key a.ra_bill_no as RaBillNo,
      a.ebeln      as Ebeln,
      a.work_from  as RaBillFrom,
      a.work_to    as RaBillTo
} where a.ra_bill_no <> ''
group by 
  a.ra_bill_no,
  a.ebeln,
    a.work_from,
    a.work_to
