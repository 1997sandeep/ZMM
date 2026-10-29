@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for TMG MAS1'
define root view entity ZMM_RABILL_PAY_MAS1
  as select from zmmt_scp_pa_mas1
{
  key sr_no_n                     as SrNoN,
      sr_no_c                     as SrNoC,
      itm_code                    as ItmCode,
      description                 as Description,
      gl_code                     as GlCode,
      shkzg                       as Shkzg,
      umskz                       as Umskz,
      deduction                   as Deduction,
      manual                      as Manual,
      addition                    as Addition,
      local_created_by            as LocalCreatedBy,
      local_created_at            as LocalCreatedAt,
      local_last_changed_by       as LocalLastChangedBy,
      local_last_changed_at       as LocalLastChangedAt,
      last_changed_at             as LastChangedAt,
      cast('' as abap.char( 14 )) as Blank //added 25.09.2023
}
//where
//  manual <> ''
