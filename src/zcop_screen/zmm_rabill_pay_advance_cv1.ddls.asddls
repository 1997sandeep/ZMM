@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance Data'
define root view entity ZMM_RABILL_PAY_ADVANCE_CV1
  as select from ZMM_RABILL_PAY_ABSTRACT_FINAL2 as a
    inner join   zmmt_scp_pa_mas1               as b on a.SrNo = b.sr_no_n
{
  key a.RaBillNo,
      a.Ebeln,
      @ObjectModel.sort.enabled: true
      a.SrNo,
      a.SrNumber,
      a.ItemCode,
      a.PaMasterDescription,
      a.Tax,
      a.GlAcc,
      a.zcurr,
      @Semantics.amount.currencyCode: 'zcurr'
//      a.UpToDate as UpToDate,
      sum(a.UpToDate)          as UpToDate,
      @Semantics.amount.currencyCode: 'zcurr'
//      a.UpToPreviousBill       as UpToPreviousBill,
      sum(a.UpToDate)          as UpToPreviousBill,
      @Semantics.amount.currencyCode: 'zcurr'
//      a.ThisBill               as ThisBill,
      sum(a.ThisBill)               as ThisBill,
      a.Remarks,
      b.umskz                  as Calc,
      case b.manual
              when 'M'
              then 'false'
              when ''
              then 'false'
              else 'false' end as Edit

}
group by
  a.RaBillNo,
  a.Ebeln,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  a.PaMasterDescription,
  a.Tax,
  a.GlAcc,
  a.zcurr,
//  a.UpToDate,
////  a.UpToPreviousBill,
//  a.ThisBill,
  a.Remarks,
  b.umskz,
  b.manual
