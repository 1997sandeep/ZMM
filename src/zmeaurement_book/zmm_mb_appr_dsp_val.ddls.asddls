@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill Approval Display'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_MB_APPR_DSP_Val as select from zmb_approval_t as A
left outer join ZMEA_BOOL_HEADER  as b on A.mbno = b.mbno
                                         and A.appr_status = 'INPROCESS'
                                         and A.user_name   = $session.user
 left outer join I_Supplier as c on b.Supplier = c.Supplier                                        
{
    key A.mbno as Mbno,
        b.PurchaseOrder,
        b.Supplier,
        c.SupplierName,
        b.CompanyCode,
        b.Plant,
        b.PlantName
 
} where b.PurchaseOrder is not initial
