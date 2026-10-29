@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PRE WORK QTY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_SITC_PREWORK_QTY2 as select distinct from ZRABILL_SITC_PREWORK_QTY1 as a
                                               left outer join ZRABILL_SITC_PreWork_QTY as b on a.ebeln = b.ebeln and a.ebelp = b.ebelp and a.split_item_no = b.split_item_no
                                               and a.gvhy = b.no12
{
    key a.ebeln,
    a.ebelp,
    a.split_item_no,
    a.ra_bill_no,
    a.no12 as no1222,
    b.no12,
   a.gvhy ,
    b.Work_done_Qty
} where a.gvhy <> 0   
