@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lineitem wise tax calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_RABILL_PAY_WO_TAX2
  as select from ZMM_RABILL_PAY_WO_TAX1
{

  key RaBillNo,
  key Ebeln,
      SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      TaxCode,
      GLAcc,
      zcurr,
      Rate,
      @Semantics.amount.currencyCode : 'zcurr'
      UpToDate,
      @Semantics.amount.currencyCode : 'zcurr'
      UpToPreviousBill,
      @Semantics.amount.currencyCode : 'zcurr'
      sum(ThisBill) as ThisBill,
      Remarks
}
group by
  RaBillNo,
  Ebeln,
  SrNo,
  SrNumber,
  ItemCode,
  PaMasterDescription,
  GLAcc,
  zcurr,
  UpToDate,
  UpToPreviousBill,
  Remarks,
  TaxCode,
  Rate
