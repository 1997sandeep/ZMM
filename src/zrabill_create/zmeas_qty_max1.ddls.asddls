@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'max for Mb qty'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMEAS_QTY_MAX1 as select from ZMEAS_QTY_MAX as a
 left outer join zmeas_book_tbl as b on a.ebeln = b.ebeln 
 and a.ebelp = b.ebelp
 and a.mbno = b.mbno
{
    key a.ebeln,
    key a.ebelp,
        b.mbno,
//        b.zcurr,
//        @Semantics.amount.currencyCode : 'zcurr'
        cast( b.meas_qty as abap.dec( 10, 2 )  ) as meas_qty
        
}
