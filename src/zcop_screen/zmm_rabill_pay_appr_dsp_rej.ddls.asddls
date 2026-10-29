@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reject RabillNo for Editable'
define root view entity ZMM_RABILL_PAY_APPR_DSP_REJ 
as select from  zmmt_scp_pa_aprl           as a
    inner join   ZMM_RABILL_PAYABST_DISPLAY as b on  a.ra_bill_no  = b.Rabillno
                                                 and a.appr_status = 'REJECT'
//                                                 and a.user_name   = $session.user
    inner join   ZMM_SCP_RABILL_I           as c on a.ra_bill_no = c.RaBillNo
{
  key a.ra_bill_no    as RaBillNo,
      c.Ebeln         as Ebeln,
      c.ZplantName    as ZplantName,
      c.ZsupplierName as ZsupplierName,
      c.Pan           as Pan,
      c.Gstin         as Gstin
}
group by
  a.ra_bill_no,
  c.Ebeln,
  c.ZplantName,
  c.ZsupplierName,
  c.Pan,
  c.Gstin
