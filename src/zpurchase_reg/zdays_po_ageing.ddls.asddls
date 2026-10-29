@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Days'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZDAYS_PO_AGEING as select from I_CalendarDate
{
    key CalendarDate,
        CalendarYear,
        CalendarMonth,
        CalendarWeek,
        CalendarDay,
       case WeekDay
    when '1' then 'Monday'
    when '2' then 'Tuesday'
    when '3' then 'Wednesday'
    when '4' then 'Thursday'
    when '5' then 'Friday'
    when '6' then 'Saturday'
    when '7' then 'Sunday'
    else          'Unknown'
  end                                      as DayName
      
}
