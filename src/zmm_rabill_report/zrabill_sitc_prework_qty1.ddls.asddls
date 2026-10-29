@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PRE WORKQTY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_SITC_PREWORK_QTY1 as select from ZRABILL_SITC_PreWork_QTY
{
    key ebeln,
    ebelp,
    split_item_no,
    ra_bill_no,
    no12,
    no12 - 1 as gvhy,
    Work_done_Qty
}
