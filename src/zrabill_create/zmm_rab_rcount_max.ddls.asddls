@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maximum rcount for rabill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_RAB_RCOUNT_MAX  as select from ZMM_RABILL_RCOUNTN 
{
    key ebeln,
     del_flag,
    cast(rcount as abap.int2) as rcount
   
}
where del_flag <> 'X'
