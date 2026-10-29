@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'rabill lastest'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//define view entity ZMM_RABILL_PAYABSTRACT_MAXDAT1 as select from zmmt_scp_pa_h1
//{
//    key ebeln,
////    key ra_bill_no
//        max( post_date  ) as DateCreated,

//} group by ebeln,

define view entity ZMM_RABILL_PAYABSTRACT_MAXDAT1 as select from ZRABILL_MAXTIME as a
 left outer join zmmt_scp_pa_h1 as b on a.ebeln = b.ebeln and a.post_date = b.post_date
{
    key a.ebeln,
//    key ra_bill_no,
        a.post_date  as DateCreated,
        max( b.created_at ) as created_at
} group by a.ebeln,
a.post_date
