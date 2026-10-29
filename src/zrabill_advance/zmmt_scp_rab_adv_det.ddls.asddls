@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabil Advance details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMMT_SCP_RAB_ADV_DET 
  as select from    zmmt_scp_rab_ad1         as a1
    left outer join I_PurchaseOrderAPI01     as a2 on a2.PurchaseOrder = a1.ebeln
    left outer join I_PurchaseOrderItemAPI01 as a3 on a3.PurchaseOrder = a2.PurchaseOrder
    left outer join I_Supplier               as a4 on a2.Supplier = a4.Supplier
    left outer join I_CompanyCode            as a5 on a2.CompanyCode = a5.CompanyCode and a5.Language = 'E'
    left outer join I_PlantStdVH             as a6 on a3.Plant = a6.Plant

{
  key a1.ra_bill_no,
      a2.PurchaseOrder,
      a2.PurchaseOrderType,
      a3.Plant,
      a6.PlantName,
      a4.Supplier,
      a4.SupplierName,
      a5.CompanyCode,
      a5.CompanyCodeName
      
}
where
  a3.Plant <> ''
group by
  a1.ra_bill_no,
  a2.PurchaseOrder,
  a2.PurchaseOrderType,
  a3.Plant,
  a6.PlantName,  
  a4.Supplier,
  a4.SupplierName,
  a5.CompanyCode,
  a5.CompanyCodeName
