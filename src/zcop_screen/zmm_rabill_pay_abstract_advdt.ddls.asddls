@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - Payment Abstract Advance Date'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RABILL_PAY_ABSTRACT_ADVDT 
as select from zmmt_scp_rab_ad1
{

    key ra_bill_no,
 //   cast( 
      concat(
        concat(
          concat(substring(work_from, 3, 2), '/' ),
          concat(substring(work_from, 1, 2), '/' )
        ), 
        substring(work_from, 5, 4)        
      )
 //   as abap.char( 10 ) )
     as work_from,

 //   cast( 
      concat(
        concat(
          concat(substring(work_to, 3, 2), '/' ),
          concat(substring(work_to, 1, 2), '/' )
        ),
        substring(work_from, 5, 4)        
      )
  //  as abap.char( 10 ) )
     as work_to



}
