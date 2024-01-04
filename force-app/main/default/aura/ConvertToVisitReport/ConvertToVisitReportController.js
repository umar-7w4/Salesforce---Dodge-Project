({
    ConvertIt : function(component, event, helper) {
        
        var action = component.get("c.convertToVisitReport");
        action.setParams({"eventId": component.get("v.recordId")});
        action.setCallback(this, function(res) {
            var response = res.getReturnValue();
            var state = action.getState();
            if(component.isValid() && state == "SUCCESS" && response!= null ){    
                console.log(response);
                console.log('==');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message:'Event converted to visit report successfully!',
                    type: 'success',
                });
                toastEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
            else if (state == "ERROR" || response == null ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Event conversion to visit report failed!',
                    type: 'error',
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})