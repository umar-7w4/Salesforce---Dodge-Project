/*
----------------------------------------------------------------------------
|  Lightning Javascript: XMRealityFederatedLoginHelper.js
|
|  Filename: XMRealityFederatedLoginHelper.js.js
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
    myData: {
        intevalTimer: null
    },

    subscribeForEvent: function (component) {
        console.log('Subscribe for platform event');
        let self = this;

        // Get the empApi component
        const empApi = component.find('empApi');

        // Uncomment below line to enable debug logging (optional)
        // empApi.setDebugFlag(true);

        // Register error listener and pass in the error handler function
        empApi.onError($A.getCallback(error => {
            // Error can be any type of error (subscribe, unsubscribe...)
            console.error('EMP API error: ', JSON.stringify(error));
        }));

        // Get the channel from the input box
        const channel = '/event/XMRealityToken__e';
        // Replay option to get new events
        const replayId = -1;

        // Subscribe to an event
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            // Process event (this is called each time we receive an event)
            let userId = component.get('v.userId');
            let payload = eventReceived.data.payload;

            // console.log('USERINFO = ' + userId);
            // console.log('PAYLOAD = ' + JSON.stringify(payload));
            if (self.isCorrectUserForCallback(userId, payload)) {
                console.log('Received WEBHOOK event ', JSON.stringify(eventReceived));

                let usrDetails = component.get("v.usrDetails");
                usrDetails.XMR_Name__c = payload.Name__c;
                usrDetails.XMR_Username__c = payload.UserName__c;
                component.set("v.usrDetails", usrDetails);

                component.set("v.showIframe", false);
                $A.get("e.c:XMRSignInSignOut").setParams({"isSignedIn": true}).fire();
                window.setTimeout(
                    $A.getCallback(function () {
                        self.getUserDetails(component);
                    }), 250
                );
                window.setTimeout(
                    $A.getCallback(function () {
                        let utilityAPI = component.find("UtilityBar");
                        utilityAPI.minimizeUtility();
                        utilityAPI.setUtilityIcon({
                            icon: "user",
                            options: {
                                iconVariant: "success"
                            }
                        });
                    }), 1000
                );
            }
        })).then(subscription => {
            // Subscription response received.
            // We haven't received an event yet.
            console.log('Subscription request sent to: ', subscription.channel);
            // Save subscription to unsubscribe later
            component.set('v.subscription', subscription);
        });

        // Aura: controller //
        window.addEventListener('beforeunload', function () {
            console.log('UNLOADING...');
            // Get the empApi component
            // const empApi = component.find('empApi');
            // Get the subscription that we saved when subscribing
            const subscription = component.get('v.subscription');

            // Unsubscribe from event
            empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
                // Confirm that we have unsubscribed from the event channel
                console.log('Unsubscribed from channel ' + unsubscribed.subscription);
                component.set('v.subscription', null);
            }));

            // Stop interval timer
            console.log('Clearing interval timer...');
            window.clearInterval(self.myData.intevalTimer);
            console.log('DONE!');
        });
    },

    isCorrectUserForCallback: function (userId, payload) {
        return (userId === payload.UserId__c);
    },

    getUserDetails: function (component) {
        let action = component.get("c.getUserAuthenticationDetails");
        action.setCallback(this, function (response) {
            if (component.isValid() && response.getState() === "SUCCESS") {
                let result = response.getReturnValue();
                console.log('*** XMRealityFederatedLogin.getUserDetails() RESULT = ', result);
                component.set("v.usrDetails", result.userdetails);
            } else {
                console.error('*** ' + response);
            }
        });
        $A.enqueueAction(action);
    },

    createCallLogs: function (component, event, wrp) {
        wrp = JSON.stringify(wrp);
        let action = component.get("c.createCallLogDetails");
        action.setParams({callLogwrp: wrp});
        action.setCallback(this, function (response) {
            //alert('success');
            //$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },

    handleGetCallLog: function (component, event, helper) {
        console.log('Callout 1........');
        let recordList = component.get("v.recordLists");
        console.log(recordList);

        for (let i = 0; i < recordList.length; i++) {
            (function (i) {
                let tokenWithRecId = recordList[i];
                let recId = tokenWithRecId.split('@@@@')[1];
                let tokenForCallLink = tokenWithRecId.split('@@@@')[0];
                let urltocall = 'https://server-v6.xmreality.com/api/v11/call-link/' + tokenForCallLink + '/calls';

                fetch(urltocall, {
                    method: 'GET',
                    headers: {
                        'accept': 'application/json',
                    },
                }).then((response => response.json()))
                    .then((responseData) => {
                        let responseWrapper = JSON.parse(JSON.stringify(responseData));

                        let logCallWrp = [];
                        for (let i = 0; i < responseWrapper.length; i++) {
                            if (responseWrapper[i].status !== undefined && responseWrapper[i].status === 'concluded') {
                                logCallWrp.push({
                                    recordId: recId,
                                    acceptedAt: responseWrapper[i].acceptedAt,
                                    endedAt: responseWrapper[i].endedAt,
                                    token: responseWrapper[i].callLink.token
                                });
                                
                                recordList.splice(recordList.indexOf(tokenWithRecId), 1);
                            }
                        }


                        component.set("v.recordLists", recordList);
                        
                        if (logCallWrp.length > 0) {
                            
                            let wrp = JSON.stringify(logCallWrp);
                            let action = component.get("c.createCallLogDetails");
                            action.setParams({callLogwrp: wrp});
                            action.setCallback(this, function (responsefromcls) {
                                $A.get('e.force:refreshView').fire();
                                console.log('created task');
                            });
                            $A.enqueueAction(action);
                        }
                    });
            })(i);
        }
        // window.setTimeout(
        //     $A.getCallback(function () {
        //         helper.handleGetCallLog(component, event, helper);
        //     }), 4000
        // );
    },

    handleCalloutInterval: function (component, event, helper) {
        console.log('Starting interval timer...');
        helper.myData.intevalTimer = window.setInterval(helper.handleGetCallLog, 4000, component, event, helper);
    },

});