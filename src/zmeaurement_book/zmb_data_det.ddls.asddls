@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delete data mb sheet'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMB_DATA_DET as select from zmeas_book_h_tbl
{
 
 key ebeln,
 key mbno,
 delflag  
 
  
    }
