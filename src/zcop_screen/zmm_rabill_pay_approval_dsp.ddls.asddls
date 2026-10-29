@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval level Display'
define root view entity ZMM_RABILL_PAY_APPROVAL_DSP
  as select from    zmmt_scp_pa_aprl as a
    left outer join zmmt_scp_pa_user as b on a.user_name = b.user_id
{
  key a.ra_bill_no  as RaBillNo,
      a.app_level   as Levell,
      a.appr_status as Status,
      b.user_name   as UserName,
      a.remark      as Remark,
      a.zdate,
      a.ztime
}
group by
  a.ra_bill_no,
  a.app_level,
  a.appr_status,
  b.user_name,
  a.remark,
    a.zdate,
    a.ztime
// 
