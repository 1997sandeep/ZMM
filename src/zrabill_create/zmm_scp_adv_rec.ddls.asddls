@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance recovery'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SCP_ADV_REC
  as select from zmmt_scp_rab_rec as RABILL_REC
{
  key ra_bill_no            as RaBillNo,
  key adv_type              as AdvType,
  key adv_rec               as AdvRec,
      ebeln                 as Ebeln,
      rcount                as Rcount,
      inv_no                as InvNo,
      inv_date              as InvDate,
      @Semantics.amount.currencyCode : 'zcurr'
      cum_wd_amt            as CumWdAmt,
      @Semantics.amount.currencyCode : 'zcurr'
      tis_wd_amt            as TisWdAmt,
      @Semantics.amount.currencyCode : 'zcurr'
      per_work_done         as PerWorkDone,
      @Semantics.amount.currencyCode : 'zcurr'
      adv_paid              as AdvPaiD,
      @Semantics.amount.currencyCode : 'zcurr'
      rec_th_bill_c         as RecThBillC,
      @Semantics.amount.currencyCode : 'zcurr'
      rec_th_bill_m         as RecThBillM,
      @Semantics.amount.currencyCode : 'zcurr'
      rec_till              as RecTill,
      @Semantics.amount.currencyCode : 'zcurr'
      rec_this_bill         as RecThisBill,
      @Semantics.amount.currencyCode : 'zcurr'
      rec_up_date           as RecUpDate,
      @Semantics.amount.currencyCode : 'zcurr'
      bal_torec             as BalTorec,
      final_proces          as FinalProces,
      @Semantics.amount.currencyCode : 'zcurr'
      tot_wo_amt            as TotWoAmt,
      zcurr                 as Zcurr,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

} where adv_type <> 'ROYL'

