@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance Union With MasterLine'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_ADVANCE_UNION
  as select from    ZMM_RABILL_PAY_ADVANCE_CV   as a
    left outer join ZMM_RABILL_PAY_ABSTRACT_MAX as b on  b.ItemCode = a.ItemCode
                                                     and b.Ebeln    = a.Ebeln
{
  key a.RaBillNo,
  key a.Ebeln,
  key a.SrNo,
      a.SrNumber,
      a.ItemCode,
      a.PaMasterDescription,
      a.Tax,
      a.GLAcc,
      a.zcurr,
      @Semantics.amount.currencyCode: 'zcurr'
      sum(b.UpToDate)     as UpToDate,
      @Semantics.amount.currencyCode: 'zcurr'
      //      b.UpToPrevious as UpToPreviousBill,
      sum(b.UpToDate)     as UpToPreviousBill,
      @Semantics.amount.currencyCode: 'zcurr'
      //      '0.00'              as ThisBill,
      max(a.ThisBill)     as ThisBill,
      a.Remarks,
      left(a.RaBillNo,10) as WorkOrder
      //      case
      //      when a.RaBillNo like '0%'
      //      then left(a.RaBillNo,10)
      //      when a.RaBillNo not like '0%'
      //      then right(a.RaBillNo,10)
      //      else ''
      //      end            as WorkOrder
}
group by
  a.RaBillNo,
  a.Ebeln,
  a.SrNo,
  a.SrNumber,
  a.ItemCode,
  a.PaMasterDescription,
  a.Tax,
  a.GLAcc,
  a.zcurr,
  //  b.UpToDate,
  //  b.UpToPrevious,
  //  a.ThisBill,
  a.Remarks
