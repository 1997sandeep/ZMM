@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill advance Recoveryheader'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_ADV_REC_H
  with parameters
    pwo     : ebeln,
    prcount : zrcount
  as select from    I_PurchaseOrderAPI01     as a1
    left outer join I_PurchaseOrderItemAPI01 as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_Supplier               as a3 on a1.Supplier = a3.Supplier
    left outer join I_PlantStdVH             as a4 on a2.Plant = a4.Plant
    inner join      ZMM_ADV_REC_RAB_AMT_SUM  as a6 on a1.PurchaseOrder = a6.Ebeln
    left outer join zmmt_scp_pa_h1           as a5 on  a5.ebeln  = $parameters.pwo
                                                   and a5.rcount = $parameters.prcount
    left outer join zmmt_scp_tnc1            as a7 on a1.PurchaseOrder = a7.ebeln

{
  key a1.PurchaseOrder,
      a1.PurchaseOrderType,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a1.PurgReleaseTimeTotalAmount as TotWoAmt,
      a1.DocumentCurrency,
      a2.Plant,
      a3.Supplier,
      a3.SupplierName,
      a4.PlantName,
      //    a5.PurchasingDocumentTypeName,
      //      sum(a2.NetAmount)     as TotWoAmt,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a6.UptoDateAmt                as CumWdAmt,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a6.ThisBillAmt                as TisWdAmt,
      a6.RaBillFrom                 as RaBillFrom,
      a6.RaBillTo                   as RaBillTo,
      ''                            as AdvPaid,
      a6.Zcurr,
      a5.fidocument,
      a7.zwo_desc                   as ZwoDesc


}
where
      a1.PurchaseOrder = $parameters.pwo
    and a1.PurchaseOrderType =  'ZP05'
  and a2.Plant         <> ''
  // and a5.Language          =  'E'
  and a6.Rcount        = $parameters.prcount
group by
  a1.PurchaseOrder,
  a1.PurchaseOrderType,
  a1.PurgReleaseTimeTotalAmount,
  a1.DocumentCurrency,
  a2.Plant,
  a3.Supplier,
  a4.PlantName,
  a6.UptoDateAmt,
  a6.ThisBillAmt,
  //  a5.PurchasingDocumentTypeName,
  a3.SupplierName,
  a6.RaBillFrom,
  a6.RaBillTo,
  a6.Zcurr,
  a5.fidocument,
  a7.zwo_desc
