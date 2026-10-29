@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Milestone CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAY_MLSTN_CDS1 
as select distinct from  zmm_pay_mlstn as a
     left outer join I_PurchaseOrderAPI01 as b on a.ebeln       = b.PurchaseOrder 
     left outer join I_CompanyCode        as c on b.CompanyCode = c.CompanyCode 
     left outer join I_Supplier           as d on a.zvend_code  = d.Supplier
     left outer join I_PlantStdVH         as e on a.zproject    = e.Plant 

{
  key a.ebeln                 as Ebeln,
  key a.ebelp                 as Ebelp, 
  key a.split_item_no         as SplitItemNo,
      @EndUserText.label: 'Vendor'
      a.zvend_code            as ZvendCode,
      @EndUserText.label: 'Plant'
      a.zproject              as Zproject,
      a.split_item            as SplitItem,
      a.percentage            as Percentage
      
}
