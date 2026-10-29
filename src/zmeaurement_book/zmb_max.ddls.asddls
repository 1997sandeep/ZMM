@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'mb no max'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMB_MAX as select from zmeas_book_h_tbl as a
inner join ZMAX_RCOUNT as b on b.Ebeln = a.ebeln
{
    key a.ebeln as Ebeln,
    max(a. mbno ) as mbno,
    b.Rcount  as Rcount
    
} where a.delflag <> 'X'
group by a.ebeln,
    b.Rcount
