({
    handleOpenSignIn: function(component, event) {
        $A.get("e.c:XMRSignIn").fire();
    },
    
    handleSignInSignOut: function(component, event) {
        console.log('event.getParams().isSignedIn = ' + event.getParams().isSignedIn);
        component.set("v.displayXMR", true);
        component.find("xMRAppId").handleCallFromAuraComp(event.getParams().isSignedIn);
	 },
    
    handleinitiatecalllog: function(component, event) {
        debugger;
        //get data from here and send it to utility component
        console.log('TST');
        console.log(event.getParam('calllogdetail'));
        let callLogResp = event.getParam('calllogdetail');
        $A.get("e.c:XMRInitiateCallLogs").setParams({"dataVal" : callLogResp}).fire();
    },

    recordUpdated: function(component, event, helper) {
        let changeType = event.getParams().changeType;
        console.info('event change type ' + changeType);
        if (changeType === 'CHANGED') {
            // component.find("xMRAppId").updateChildComponent();
        }
    }
})