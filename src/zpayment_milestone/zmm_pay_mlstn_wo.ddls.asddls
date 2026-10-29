@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Milestone WO Table'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_PAY_MLSTN_WO 
as select distinct from zmm_pay_mlstn as a
     left outer join I_PurchaseOrderAPI01 as b on a.ebeln       = b.PurchaseOrder 
     left outer join I_CompanyCode        as c on b.CompanyCode = c.CompanyCode 
     left outer join I_Supplier           as d on a.zvend_code  = d.Supplier
     left outer join I_PlantStdVH         as e on a.zproject    = e.Plant 
     left outer join zmmt_scp_tnc1        as f on a.ebeln       = f.ebeln 

{
      @EndUserText.label: 'Work Order'
  key a.ebeln                 as Ebeln,
      b.CompanyCode,
      c.CompanyCodeName,
      @EndUserText.label: 'Vendor'
      a.zvend_code            as ZvendCode,
      @EndUserText.label: 'Vendor Name'
      d.SupplierFullName,
      @EndUserText.label: 'Plant'
      a.zproject              as Zproject,
      @EndUserText.label: 'Plant Name'
      e.PlantName,
      a.zdoctype              as Zdoctype,
      f.pay_chk               as PayChk
   
}
