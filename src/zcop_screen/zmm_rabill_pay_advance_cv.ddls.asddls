@AbapCatalog.sqlViewName: 'ZMMWOADV'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'B.Consume Root View Advance Pay'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZMM_RABILL_PAY_ADVANCE_CV
  as select from    ZMM_RABILL_PAY_ADVANCE_ITEMC as a
    left outer join ZMM_RABILL_PAY_ABSTRACT_MAX  as b on  b.ItemCode = a.ItemCode
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
      sum(b.UpToDate) as UpToDate,
      b.UpToPrevious as UpToPreviousBill,
//      b.UpToDate as UpToPreviousBill,
 @Semantics.amount.currencyCode: 'zcurr'
     max(a.ThisBill) as ThisBill,       
      a.Remarks
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
  b.UpToPrevious,
//  a.ThisBill,
  a.Remarks
