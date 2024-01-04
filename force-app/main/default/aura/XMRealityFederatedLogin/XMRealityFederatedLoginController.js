/*
----------------------------------------------------------------------------
|  Lightning Javascript: XMRealityFederatedLoginController.js
|
|  Filename: XMRealityFederatedLoginController.js.js
|
|  Author: Peter Friberg, Fluido Sweden AB
|
|  Description:
|     XXXXX
|
| Change Log:
| 2021-11-02  Peter Friberg  Initial Development.
----------------------------------------------------------------------------
*/

({
    // Sets an empApi error handler on component initialization
    onInit: function (component, event, helper) {

        let action = component.get("c.getUserAuthenticationDetails");
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('RESULT = ', result);
                component.set("v.userId", result.userdetails.Id);
                component.set("v.usrDetails", result.userdetails);
                component.set("v.federatedLogin", result.federatedLogin);
                component.set("v.teamsLoginPage", result.teamsLoginPage);
                component.set("v.salesforceUrl", result.salesforceUrl);
                component.set("v.siteUrl", result.siteUrl);

                let utilityAPI = component.find("UtilityBar");
                if (result.federatedLogin) {
                    utilityAPI.setPanelHeight({"heightPX": 180});
                } else {
                    utilityAPI.setPanelHeight({"heightPX": 470});
                }

                if (result.isValidToken) {
                    component.set("v.showIframe", false);
                    //$A.get("e.c:XMRSignInSignOut").setParams({"isSignedIn": true}).fire();
                    helper.subscribeForEvent(component);
                    utilityAPI.setUtilityIcon({
                        icon: "user",
                        options: {
                            iconVariant: "success"
                        }
                    });
                } else {
                    helper.subscribeForEvent(component); //need to check yet whether this is required or not
                    utilityAPI.setUtilityIcon({
                        icon: "user",
                        options: {
                            iconVariant: "error"
                        }
                    });
                }

                helper.handleCalloutInterval(component, event, helper);
            } else {
                console.error(response);
            }
        });
        $A.enqueueAction(action);
    },

    handleUserLogOut: function (component, event, helper) {
        let action = component.get("c.logOutUserFromXMReality");
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                console.log('Logout!');
                $A.get("e.c:XMRSignInSignOut").setParams({"isSignedIn": false}).fire();
                component.set("v.showIframe", true);

                let usrDetails = component.get("v.usrDetails");
                usrDetails.XMR_Name__c = '';
                usrDetails.XMR_Username__c = '';
                component.set("v.usrDetails", usrDetails);

                let utilityAPI = component.find("UtilityBar");
                utilityAPI.setUtilityIcon({
                    icon: "user",
                    options: {
                        iconVariant: "error"
                    }
                });

                window.setTimeout(
                    $A.getCallback(function () {
                        helper.getUserDetails(component);
                    }), 250
                );
            } else {
                console.error(response);
            }
        });
        $A.enqueueAction(action);
    },

    handleSignIn: function (component, event, helper) {
        let utilityAPI = component.find("UtilityBar");
        utilityAPI.getAllUtilityInfo().then(function (response) {
            utilityAPI.openUtility({
                utilityId: ''
            });
        }).catch(function (error) {
            console.log(error);
        });
    },

    popupLoginWindow: function (component, event, helper) {
        let vfPage = "/apex/XMRealityPopupLogin?uri=";
        let uri = component.get("v.siteUrl") + "&state=";
        let userId = component.get("v.userId");
        let link = vfPage + uri + userId;
        console.log("link = ", link);

        const dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
        const dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;

        const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
        const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

        const left = (width - 480) / 2 + dualScreenLeft
        const top = (height - 480) / 2 + dualScreenTop

        let pg = window.open(
            link,
            'XMRFederatedLoginName',
            `
            status=no,
            menubar=no,
            toolbar=no,
            resizable=yes,
            scrollbars=yes,
            width=480,
            height=480,
            top=${top},
            left=${left}
            `,
            true);
    },

    handleInitiateCallLog: function (component, event, helper) {
        console.log('Federated login');
        console.log(event.getParam('dataVal'));
        let linkdata = JSON.parse(event.getParam('dataVal'));

        if (linkdata !== undefined && linkdata.xmrToken !== undefined && linkdata.recordId !== undefined) {
            let existingRecordLst = component.get("v.recordLists");
            existingRecordLst.push(linkdata.xmrToken + '@@@@' + linkdata.recordId);
            component.set("v.recordLists", existingRecordLst);
            console.log('datasent');
            console.log(component.get("v.recordLists"));
            //initiate interval callout
            // helper.handleCalloutInterval(component, event, helper);
        }
        else {
            console.log('ERRROR! linkdata, token or recordid undefined');

        }
    }
});