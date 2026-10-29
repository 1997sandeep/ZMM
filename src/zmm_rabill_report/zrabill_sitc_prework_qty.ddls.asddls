@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Previous Work Done QTY(SITC)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_SITC_PreWork_QTY as select from zmmt_rab_mbsheet as a 
                                         //  left outer join ZMM_RA_BILL_MLSTN as b on a.ebeln = b.Ebeln and a.ebelp = b.Ebelp and a.split_item_no = b.SplitItemNo
{

    key a.ebeln,
        a.ebelp,
        a.split_item_no,
        a.ra_bill_no,
       cast( substring(a.ra_bill_no,12,3) as abap.int4 ) as no12,
        cast(a.work_done_qty as abap.dec( 12, 2 ) ) as Work_done_Qty
        //cast(b.pre_wd_qty as abap.dec( 12, 2 ) ) as Previous_Work_Done
        
           
}  
// group by a.ebeln,
//        a.ebelp,
//        a.split_item_no,
//        b.pre_wd_qty
