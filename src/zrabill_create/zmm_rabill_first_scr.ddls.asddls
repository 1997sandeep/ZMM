@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RABILL DISPLAY CDS'
define root view entity ZMM_RABILL_FIRST_SCR
  as select from    zmmt_scp_rabill1         as a1 
    left outer join I_PurchaseOrderAPI01     as a2 on a1.ebeln = a2.PurchaseOrder
    left outer join I_PurchaseOrderItemAPI01 as a3 on a2.PurchaseOrder = a3.PurchaseOrder
    inner join      I_Supplier               as a4 on a2.Supplier = a4.Supplier
    inner join      I_PlantStdVH             as a5 on a3.Plant = a5.Plant
    left outer join I_ServiceEntrySheetAPI01 as a6 on a1.ra_bill_no = a6.ServiceEntrySheetName
    and a6.IsDeleted = ''
{

  key a1.ra_bill_no,
      a1.ebeln,
      a1.rcount,
      a1.ra_bill_from,
      a1.ra_bill_to,
      a1.erdat,
      a2.Supplier,
      a3.Plant,
      a4.SupplierFullName,
      a5.PlantName,
      a5.PlantName as ProjectDesc,
      a6.ServiceEntrySheet as sesno
} where a1.del_flag <> 'X' 
group by
  a1.ra_bill_no,
  a1.ebeln,
  a1.rcount,
  a1.ra_bill_from,
  a1.ra_bill_to,
  a1.erdat,
  a2.Supplier,
  a3.Plant,
  a4.SupplierFullName,
  a5.PlantName,
  a6.ServiceEntrySheet
