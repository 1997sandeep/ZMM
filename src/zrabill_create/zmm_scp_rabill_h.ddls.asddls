@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RA Bill header'
@Metadata.allowExtensions: true
define root view entity ZMM_SCP_RABILL_H
  as select from I_PurchaseOrderAPI01         as a1
    inner join   I_PurchaseOrderItemAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    inner join   I_Supplier                   as a3 on a1.Supplier = a3.Supplier
    inner join   I_PlantStdVH                 as a4 on a2.Plant = a4.Plant
    inner join   I_PurchasingDocumentTypeText as a5 on  a1.PurchaseOrderType          =  a5.PurchasingDocumentType
                                                    and a5.PurchasingDocumentCategory <> 'B'
    left outer join   zmmt_scp_tnc1           as a6 on a1.PurchaseOrder = a6.ebeln
    left outer join   ZMM_SCP_RABILL_WO_AMT   as a7 on a1.PurchaseOrder = a7.PurchaseOrder
    left outer join   ZMB_NO   as a8 on a1.PurchaseOrder = a8.ebeln
    left outer join   zmmt_scp_rabill1   as a9 on a1.PurchaseOrder = a9.ebeln
//                                              and a.
    
{

  key a1.PurchaseOrder,
      a1.Supplier,
      a1.PurchaseOrderType,
      a2.Plant,
      a3.SupplierName as SupplierFullName,
      a4.PlantName,
      a5.PurchasingDocumentTypeName,
      a6.zwo_desc,
      a2.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a7.NetAmount,
      a8.mbno
//      a9.deduction1 as Deduction1,
//      a9.deduction2 as Deduction2,
//      a9.remark1 as Remark1,
//      a9.remark2 as Remark2
}
where
//        a1.PurchaseOrderType =  'ZP05'and
      a2.Plant    <> ''
  and a5.Language =  'E'
group by
  a1.PurchaseOrder,
  a1.Supplier,
  a1.PurchaseOrderType,
  a2.Plant,
  a3.SupplierName,
  a4.PlantName,
  a5.PurchasingDocumentTypeName,
  a6.zwo_desc,
  a2.DocumentCurrency,
  a7.NetAmount,
    a8.mbno
//    a9.deduction1,
//    a9.deduction2,
//    a9.remark1,
//    a9.remark2
