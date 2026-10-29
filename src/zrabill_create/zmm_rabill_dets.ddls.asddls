@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rabill detials'
define root view entity ZMM_RABILL_DETS
  as select from zmmt_scp_rabill1
{

  key ra_bill_no                ,
  key ebeln                     as Ebeln,
  key ebelp                     as Ebelp,
      cast(rcount as abap.int2) as Rcount,
      this_bill                 as ThisBill,
      this_bill_d               as ThisBillD,
      hold_qty                  as HoldQty,
      this_act                  as ThisAct,
      uom                       as Uom,
      ra_bill_from             ,
      ra_bill_to                ,
      sheet_no                  as SheetNo,
      final_proces              as FinalProces,
      post_date                 as PostDate,
      without_dpr               as WithoutDpr,
      remarks                   as Remarks,
      wo_qty_new                as WoQtyNew,
      qty_deduct                as QtyDeduct,
      qty_deduct_utd            as QtyDeductUtd,
      amt_deduct                as AmtDeduct,
      cutover                   as Cutover,
      rel_hold_qty              as RelHoldQty,
      total_hold                as TotalHold,
      qty_reduced_reco          as QtyReducedReco,
      prev_hold                 as PrevHold,
      final_bill                as FinalBill,
      reversal_no               as ReversalNo,
      reversal_date             as ReversalDate,
      erdat                     as Erdat,
      final_process             as FinalProcess,
      sesno                     as Sesno,
      rate                      as Rate,
      this_bill_amt             as ThisBillAmt,
      upto_prev_amt             as UptoPrevAmt,
      upto_date_amt             as UptoDateAmt,
      zcurr                     as Zcurr,
      zdate                     as Zdate,
      mbs_qty                   as MbsQty,
      from_date                 as FromDate,
      to_date                   as ToDate,
      del_flag    

}
