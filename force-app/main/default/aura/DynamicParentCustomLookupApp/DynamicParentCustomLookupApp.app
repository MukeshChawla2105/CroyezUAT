<aura:application extends="force:slds">
	 <!-- Create attribute to store lookup value as a sObject--> 
  <aura:attribute name="selectedLookUpRecord" type="sObject" default="{}"/>

  <c:DynamicParentCustomLookup objectAPIName="User" IconName="Standard:User" selectedRecord="{!v.selectedLookUpRecord}" label="User Name"/>
 
</aura:application>