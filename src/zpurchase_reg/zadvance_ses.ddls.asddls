@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance ses'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZADVANCE_SES
  as select from zmmt_scp_rab_ad1
{
  key  ebeln,
  key  ra_bill_no,
       prinvoice,
       prinvoice_date,
cast(
  substring(
    cast( last_changed_at as abap.char(30) ),
    1,
    8
  ) as abap.dats
) as last_changed_date
}
