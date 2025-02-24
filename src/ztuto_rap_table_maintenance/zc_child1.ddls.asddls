@EndUserText.label: 'child1 - Maintain'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_Child1
  as projection on ZI_Child1
{
  key Id2,
  key Id,
  Description,
  @Consumption.hidden: true
  LastChangedAt,
  @Consumption.hidden: true
  LocalLastChangedAt,
  @Consumption.hidden: true
  SingletonID,
  _Main : redirected to parent ZC_Main,
  _MainAll : redirected to ZC_Main_S
  
}
