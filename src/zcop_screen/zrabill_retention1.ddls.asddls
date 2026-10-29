@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'for rabill Retention amt calcultion'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_Retention1 as select from ZRABILL_Retention as a
left outer join zmmt_scp_rabill1 as b on a.ebeln = b.ebeln and a.bill = b.ra_bill_no
//left outer join ZMM_SCP_TNC_CDS1 as c on a.Ebeln = c.Ebeln
{
    key a.ebeln,
    a.bill,
//    b.PaMasterDescription,
    cast(sum( b.this_bill_amt ) as abap.dec(13,2))  as ret   //* cast( c.Zret as abap.dec(13,2)) ) as abap.dec( 13, 2) ) / 100  as ret
} //where b.ItemCode = 'GTBQ'
group by a.ebeln,
    a.bill
