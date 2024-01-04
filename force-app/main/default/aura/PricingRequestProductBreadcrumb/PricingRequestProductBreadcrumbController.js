({
    doInit : function(component, event, helper) {
        var action = component.get("c.getParentRecordInfo");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var parentRecordInfo = response.getReturnValue();
                console.log('----');
                console.log(parentRecordInfo);
                console.log(parentRecordInfo.Id);
                component.set("v.parentRecordId", parentRecordInfo.Id);
                component.set("v.parentRecordName", parentRecordInfo.Name);
                component.set("v.childRecordId", component.get("v.recordId"));
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.getChildRecordInfo");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var childRecordInfo = response.getReturnValue();
                console.log(childRecordInfo.Name)
                component.set("v.childRecordName", childRecordInfo.Name);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    navigateToOppty:function(component){
      // it returns only first value of Id
      var Opprec  = component.get("v.parentRecordId");
      console.log('****');
      console.log(Opprec);
      var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
        "recordId": Opprec,
        "slideDevName": "detail"
      });
      sObectEvent.fire(); 

    },
    gotoList : function (component, event, helper) {
        var action = component.get("c.getListViews");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews.Id,
                    "listViewName": null,
                    "scope": "Pricing_Request__c"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleEditClick : function(component, event, helper) {
        // Retrieve the record ID from the component's attributes
        var recordId = component.get("v.recordId");
        
        // Use the workspace API to open the record in edit mode
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.openTab({
                recordId: recordId,
                focus: true,
                tabLabel: "Edit",
                tabIcon: "utility:edit",
                openMode: "edit"
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : response});
            });
        });
    },
    
    handleFollowClick : function(component, event, helper) {
        // Retrieve the record ID from the component's attributes
        var recordId = component.get("v.recordId");
        
        // Use the Apex controller to toggle the user's follow status for the record
        var action = component.get("c.toggleFollowStatus");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                // Update the follow button label and variant based on the new status
                var isFollowing = response.getReturnValue();
                component.set("v.isFollowing", isFollowing);
                var buttonLabel = isFollowing ? "Following" : "Follow";
                var buttonVariant = isFollowing ? "brand" : "neutral";
                component.set("v.buttonLabel", buttonLabel);
                component.set("v.buttonVariant", buttonVariant);
            }
        });
        $A.enqueueAction(action);
    }
})