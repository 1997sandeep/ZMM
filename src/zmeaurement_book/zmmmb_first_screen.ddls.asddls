@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'First screen data'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMMMB_FIRST_SCREEN
  as select from    ZI_MEAS_BOOK_HEAD        as a1
    left outer join I_PurchaseOrderAPI01     as a2 on a1.Ebeln = a2.PurchaseOrder
    left outer join I_PurchaseOrderItemAPI01 as a3 on a2.PurchaseOrder = a3.PurchaseOrder
    left outer join I_Supplier               as a4 on a2.Supplier = a4.Supplier
    left outer join I_PlantStdVH             as a5 on a3.Plant = a5.Plant
{

  key a1.Mbno,
      a1.Ebeln,
      //      a1.rcount,
      a1.zdate     as LocalCreatedAt,
      a2.Supplier,
      a3.Plant,
      a4.SupplierFullName,
      a5.PlantName,
      a5.PlantName as ProjectDesc
}
where
  a1.DelFlag <> 'X'
group by
  a1.Mbno,
  a1.Ebeln,
  a2.Supplier,
  a3.Plant,
  a4.SupplierFullName,
  a5.PlantName,
  a1.zdate
