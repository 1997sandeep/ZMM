@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance recovery display'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_ADV_REC_DISP 
  as select from    zmmt_scp_rab_rec         as a1
    inner join      I_PurchaseOrderAPI01     as a2 on a1.ebeln = a2.PurchaseOrder
    left outer join I_PurchaseOrderItemAPI01 as a3 on a2.PurchaseOrder = a3.PurchaseOrder
    left outer join I_Supplier               as a4 on a2.Supplier = a4.Supplier
    left outer join I_PlantStdVH             as a5 on a3.Plant = a5.Plant
    left outer join zmmt_scp_pa_h1           as a6 on a1.ra_bill_no = a6.ra_bill_no
{

  key a1.ra_bill_no   as RaBillNo,
  key a1.adv_rec      as AdvRec,
      a1.ebeln        as Ebeln,
      a1.rcount       as Rcount,
      a2.Supplier     as Supplier,
      a3.Plant        as Plant,
      a4.SupplierName as SupplierFullName,
      a5.PlantName,
      a6.fidocument
}
where
  a3.Plant <> ''
group by
  a1.ra_bill_no,
  a1.adv_rec,
  a1.ebeln,
  a1.rcount,
  a2.Supplier,
  a3.Plant,
  a4.SupplierName,
  a5.PlantName,
  a6.fidocument
