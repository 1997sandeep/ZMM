@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max RabillNo Date wise'
define root view entity ZMM_RABILL_PAY_ABSTRACT_MAXDAT
  as select from ZMM_RABILL_PAYABSTRACT_MAXDAT1 as a
  left outer join zmmt_scp_pa_h1 as b on a.ebeln = b.ebeln and b.post_date = a.DateCreated  and a.created_at = b.created_at
{
  key a.ebeln          as Ebeln,
      b.ra_bill_no        as RaBillNo,
      b.created_at
//      max(a.post_date) as DateCreated
      //            max(left(a.local_created_at,8))  as Time
}
group by
  a.ebeln,
  b.ra_bill_no,
  b.created_at

//   as select from zmmt_scp_ra_payi as a
//{
//  key a.ebeln                          as Ebeln,
//      max(right(a.local_created_at,8)) as DateCreated
//      //            max(left(a.local_created_at,8))  as Time
//}
//group by
//  a.ebeln
