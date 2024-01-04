({
    invoke : function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var navEvt = $A.get("e.force:navigateToSObject");
           navEvt.setParams({
             "recordId": oppId,
             "slideDevName": "detail"
           });
        navEvt.fire();
   }
})