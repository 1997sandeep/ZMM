@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Join With Header F4 for Pa Screen'
define root view entity ZMM_RABILL_PAY_ABSTRACT_RBILL2
  as select from    ZMM_RABILL_PAY_ABSTRACT_RBILL1 as a
    left outer join zmmt_scp_rabill1               as b on  a.ebeln      = b.ebeln
                                                        and a.RaBillFrom = b.ra_bill_from
                                                        and a.RaBillTo   = b.ra_bill_to

{
  key a.ebeln      as Ebeln,
      a.RaBillFrom as RaBillFrom,
      a.RaBillTo   as RaBillTo,
      b.inv_date   as InvDate,
      b.inv_num    as InvNum
}
group by
  a.ebeln,
  a.RaBillFrom,
  a.RaBillTo,
  b.inv_date,
  b.inv_num
