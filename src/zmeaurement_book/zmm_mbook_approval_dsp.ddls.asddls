  @AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Approval level Display'
define root view entity ZMM_MBOOK_APPROVAL_DSP as select from 
        zmb_approval_t as a
    left outer join ZUSER as b on a.user_name = b.UserID
{
  key a.mbno  as mbno,
    a.app_level   as Levell,
      a.appr_status as Status,
      b.UserDescription   as UserName,
      a.remark      as Remark,
      a.zdate,
      a.ztime
}  //where a.appr_status = 'INPROCESS'
group by
  a.mbno,
  a.app_level,
  a.appr_status,
  b.UserDescription,
  a.remark,
  a.zdate,
  a.ztime
  

