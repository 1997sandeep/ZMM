@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'rabill and rcount fetch'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_RABILL_RCOUNT as select from zmmt_scp_rabill1
{
    key ebeln,
//    key ra_bill_no,
   cast(rcount as abap.numc(5))   as rcount,
    del_flag 
}
where rcount is not initial
