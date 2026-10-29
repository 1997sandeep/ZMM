@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header data for rabill advance'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMMT_SCP_RAB_ADV_HEADER_CDS1 
 as select from    I_PurchaseOrderAPI01         as a1
    left outer join I_PurchaseOrderItemAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_Supplier                   as a3 on a1.Supplier = a3.Supplier
    left outer join I_PlantStdVH                 as a4 on a2.Plant = a4.Plant
    left outer join I_PurchasingDocumentTypeText as a5 on a1.PurchaseOrderType = a5.PurchasingDocumentType
                                                       and a5.PurchasingDocumentCategory <> 'B'
    left outer join zmmt_scp_tnc1                as a6 on a1.PurchaseOrder = a6.ebeln
                                                       
                                                       

{
  key a1.PurchaseOrder,
      a1.PurchaseOrderType,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a1.PurgReleaseTimeTotalAmount as NetAmt,
      a1.DocumentCurrency,
      a2.Plant,
      a3.Supplier,
      a3.SupplierName,
      a4.PlantName,
      a5.PurchasingDocumentTypeName,
      a6.zwo_desc as ZwoDesc
}
where
  a2.Plant             <> ''
  and a5.Language          =  'E'
group by
  a1.PurchaseOrder,
  a1.PurchaseOrderType,
  a1.PurgReleaseTimeTotalAmount,
  a1.DocumentCurrency,
  a2.Plant,
  a3.Supplier,
  a4.PlantName,
  a5.PurchasingDocumentTypeName,
  a3.SupplierName,
  a6.zwo_desc
