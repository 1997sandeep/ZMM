@AbapCatalog.sqlViewName: 'ZMMWODEDU'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'D.Comsume Root View TDS Deduction'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZMM_RABILL_PAY_DEDUCTION_CV
  as select from ZMM_RABILL_PAY_DEDUCTION_ITEMC as a
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
      ////      a.UpToDate,
      cast(cast(a.ThisBill as abap.dec( 15, 2 )) as abap.curr( 15, 2 )) as UpToDate,
      @Semantics.amount.currencyCode: 'zcurr'
      a.UpToPreviousBill,
      @Semantics.amount.currencyCode: 'zcurr'
      //      cast(a.ThisBill as abap.curr( 15, 2 )) as ThisBill,
      cast(a.ThisBill as abap.dec( 15, 2 ))  as ThisBill,
      //      a.ThisBill,
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
  a.UpToDate,
  a.UpToPreviousBill,
  a.ThisBill,
  a.Remarks
