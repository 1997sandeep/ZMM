@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_MMT_SCP_PA_MAS1
  as select from zmmt_scp_pa_mas1
{
  key sr_no_n as SrNoN,
  sr_no_c as SrNoC,
  itm_code as ItmCode,
  description as Description,
  gl_code as GlCode,
  shkzg as Shkzg,
  umskz as Umskz,
  deduction as Deduction,
  manual as Manual,
  addition as Addition,
  cuky_field as CukyField,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
  
}
