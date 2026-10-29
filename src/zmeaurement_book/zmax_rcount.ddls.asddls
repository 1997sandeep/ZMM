@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Max r count'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMAX_RCOUNT as select from zmeas_book_h_tbl
{
    key ebeln as Ebeln,
    max(zrcount )  as Rcount
    
}  //where delflag <> 'X'
group by ebeln
//    rcount
