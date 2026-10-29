@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approver Display Screen'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMEASUREMENT_APPROVER as select from zmb_approval_t as A
left outer join ZMEA_BOOL_HEADER  as b on A.mbno = b.mbno
                                         and A.appr_status = 'INPROCESS'
                                         and A.user_name   = $session.user
left outer join I_Supplier as c on c.Supplier = b.Supplier
{
    key A.mbno as Mbno,
        A.app_level as AppLevel,
        b.PurchaseOrder,
        b.Supplier,
        c.SupplierName,
        b.Plant,
        b.PlantName

 
 
} where b.PurchaseOrder is not initial
