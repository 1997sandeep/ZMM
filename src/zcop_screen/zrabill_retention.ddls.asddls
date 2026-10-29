@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for rabill Retention amt calcultion'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_Retention as select from zmmt_scp_rabill1 as a
{
   key ebeln,
   max( ra_bill_no ) as bill
//   ThisBill
} 
group by ebeln
