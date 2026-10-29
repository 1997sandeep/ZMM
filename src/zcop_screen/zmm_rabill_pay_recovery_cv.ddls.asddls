@AbapCatalog.sqlViewName: 'ZMMWOREC'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C.Consume Root View Deduction Recovery'
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZMM_RABILL_PAY_RECOVERY_CV
  as select from ZMM_RABILL_PAY_RECOVERY_ITEMC
{
  key RaBillNo,
  key Ebeln,
  key SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
       @Semantics.amount.currencyCode: 'zcurr'
      UpToDate,
       @Semantics.amount.currencyCode: 'zcurr'
      UpToPreviousBill,
       @Semantics.amount.currencyCode: 'zcurr'
      ThisBill,
      Remarks
}
