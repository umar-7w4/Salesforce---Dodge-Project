({
    ConvertIt : function(component, event, helper) {
        
        //Calling convert visit report method from apex which triggers whole process
        var action = component.get("c.convertVisitReport");
        action.setParams({"visitId": component.get("v.recordId")});
        action.setCallback(this, function(res) {
            var response = res.getReturnValue();
            var state = action.getState();
            if(component.isValid() && state == "SUCCESS"){    
                console.log(response);
                console.log('==');
                
                //Showing sucess message upon successful conversion
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message:'Visit Report converted successfully!',
                    type: 'success',
                });
                toastEvent.fire();
                
                //Navigating to newly created opportunity after converting visit report to opportunity
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": response,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
            else if (state == "ERROR") {
                //Showing error message when conversion fails
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Visit Report conversion failed!',
                    type: 'error',
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})