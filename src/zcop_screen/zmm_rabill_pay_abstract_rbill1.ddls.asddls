@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max RabillNo and Ebeln Date wise'
define root view entity ZMM_RABILL_PAY_ABSTRACT_RBILL1
  as select from zmmt_scp_rabill1 as a
{
  key a.ebeln,
      max(a.ra_bill_from) as RaBillFrom,
      max(a.ra_bill_to)   as RaBillTo
}
group by
  a.ebeln
