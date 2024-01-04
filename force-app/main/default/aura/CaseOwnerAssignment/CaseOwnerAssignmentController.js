({
    AssignOwner : function(component, event, helper) {
        
        var action = component.get("c.ContactOwnerAssignment");
        action.setParams({"contId": component.get("v.recordId")});
        action.setCallback(this, function(res) {
            var response = res.getReturnValue();
            var state = action.getState();
            if(component.isValid() && state == "SUCCESS" && response!= null ){    
                console.log(response);
                console.log('==');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message:'Owner assigned successfully!',
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
                    message:'Owner assignment failed!',
                    type: 'error',
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})