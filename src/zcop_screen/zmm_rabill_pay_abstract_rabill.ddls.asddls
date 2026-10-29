@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch Rabill No for Advance&Recovery'
define root view entity ZMM_RABILL_PAY_ABSTRACT_RABILL
  as select from zmmt_scp_rabill1 as a
{
  key a.ra_bill_no as RabillNo,
      a.ebeln      as Ebeln,
      a.ra_bill_from as RaBillFrom,
      a.ra_bill_to as RaBillTo
}
where
  a.ra_bill_no <> '' 
group by
  a.ra_bill_no,
  a.ebeln,
    a.ra_bill_from,
    a.ra_bill_to
