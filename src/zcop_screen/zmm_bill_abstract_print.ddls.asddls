@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bill Abstract Print'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_BILL_ABSTRACT_PRINT
  as select from zmm_bill_abs_h
{
  key ra_bill_no    as Rabillno,
  key ebeln         as Ebeln,
      wekrs         as Plant,
      file_contents as AdobeString,
      bill_date     as BillDate,
      post_date     as PostingDate
}
