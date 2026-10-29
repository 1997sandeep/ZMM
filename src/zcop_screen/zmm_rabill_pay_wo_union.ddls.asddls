@AbapCatalog.sqlViewName: 'ZMMRABILLWOUNION'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Union for Wo agasint WorkDone'
define view ZMM_RABILL_PAY_WO_UNION
  as select from ZMM_RABILL_PAY_WO_LINK_MAS1  //ZMM_RABILL_PAY_WORKDONE
{
  key RaBillNo,
  key Ebeln,    
  key SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
} group by
      RaBillNo,
      Ebeln,    
      SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks

union select from ZMM_RABILL_PAY_WO_TAXC //ZMM_RABILL_PAY_WO_ITEMC
{
  key RaBillNo,
  key Ebeln,
  key SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
} group by
      RaBillNo,
      Ebeln,    
      SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
      
union select from ZMM_RABILL_PAY_WO_LINK_MAS2
{
  key RaBillNo,
  key Ebeln,
  key SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
} group by
      RaBillNo,
      Ebeln,    
      SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
 
union select from ZMM_RABILL_PAY_WORKDONE_MTRE2 //added on 13.08.2023
{
  key RaBillNo,
  key Ebeln,
  key SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks
} group by
      RaBillNo,
      Ebeln,    
      SrNo,
      SrNumber,
      ItemCode,
      PaMasterDescription,
      Tax,
      GLAcc,
      zcurr,
      UpToDate,
      UpToPreviousBill,
      ThisBill,
      Remarks      
