@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Advance recovery change screen'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_ADV_REC_CHNG
  with parameters
    pwo     : ebeln,
//    prec    : zrec,
    prcount : zrcount
  as select from    zmmt_scp_rab_rec           as a1
    left outer join zmmt_scp_tnc1              as a2 on a1.ebeln = a2.ebeln
    left outer join ZMM_ADV_REC_CHNG_UPTP_PREV as a3 on  a1.ebeln    = a3.Ebeln
    //                                                    and a3.RaBillNo < a1.ra_bill_no
                                                     and a1.adv_type = a3.AdvType
{
  key a1.ra_bill_no    as RaBillNo,
  key a1.adv_type      as AdvType,
  key a1.adv_rec       as AdvRec,
      a1.ebeln         as Ebeln,
      a1.rcount        as Rcount,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.cum_wd_amt    as CumWdAmt,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.tis_wd_amt    as TisWdAmt,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.per_work_done as PerWorkDone,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.adv_paid      as AdvPaid,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.rec_th_bill_c as RecThBillC,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.rec_th_bill_m as RecThBillM,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.rec_this_bill as RecThisBill,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.rec_till      as RecTill,
      //  a3.rec_this_bill as RecTill,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.rec_up_date   as RecUpDate,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.bal_torec     as BalTorec,
      @Semantics.amount.currencyCode: 'Zcurr'
      a1.tot_wo_amt    as TotWoAmt,
      a1.final_proces  as FinalProces,
      a1.zcurr         as Zcurr,
      a2.zwo_desc      as ZwoDesc,
      a1.inv_no        as InvNo,
      a1.inv_date      as InvDate

}
where
      a1.ebeln   = $parameters.pwo
//  and a1.adv_rec = $parameters.prec
  and a1.rcount  = $parameters.prcount
  and a1.adv_type <> 'ROYL'
  
