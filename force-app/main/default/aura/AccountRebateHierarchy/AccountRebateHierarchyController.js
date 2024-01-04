({
    doInit: function (component, event, helper) { 
        
        var action = component.get("c.getName");
        var accId = component.get("v.recordId");
        action.setParams({recId : accId} );
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.accountName', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        console.log('doInit of component called');
        var columns = [
            {
                type: 'url',
                fieldName: 'AccountURL',
                label: 'Account Name',
                typeAttributes: {
                    label: { fieldName: 'accountName' }
                }
            },
            {
                type: 'Text',
                fieldName : 'Account_ID__c',
                label : 'Account ID'
            },
                        {
                type: 'Text',
                fieldName : 'Branch_ID__c',
                label : 'Branch ID'
            },
                        {
                type: 'Text',
                fieldName : 'Sales_Organization__c',
                label : 'Sales Organization'
            },
                        {
                type: 'Text',
                fieldName : 'BillingCity',
                label : 'Billing City'
            },
                        {
                type: 'Text',
                fieldName : 'Owner_Name__c',
                label : 'Account Owner'
            }
            
        ];
        component.set('v.gridColumns', columns);
        
        
        var trecid = component.get("v.recordId");
        
        if(trecid){
            helper.callToServer(
                component,
                "c.findRebateHierarchyData",
                function(response) {
                    var expandedRows = [];
                    var apexResponse = response;
                    var roles = {};
                    console.log('*******apexResponse:'+JSON.stringify(apexResponse));
                    var results = apexResponse;
                    roles[undefined] = { Name: "Root", _children: [] };
                    apexResponse.forEach(function(v) {
                        expandedRows.push(v.Rebate_Account__c);
                        console.log(expandedRows);
                        roles[v.Rebate_Account__c] = { 
                            accountName: v.Rebate_Account__r.Name ,
                            name: v.Rebate_Account__c, 
                            AccountURL:'/'+v.Rebate_Account__c,
                            Account_ID__c : v.Rebate_Account__r.Account_ID__c,
                            Branch_ID__c : v.Rebate_Account__r.Branch_ID__c,
                            Sales_Organization__c : v.Rebate_Account__r.Sales_Organization__c,
                            BillingCity : v.Rebate_Account__r.BillingCity,
                            Owner_Name__c  : v.Rebate_Account__r.Owner_Name__c ,
                            _children: [] };
                    });
                    console.log(roles);
                    apexResponse.forEach(function(v) {
                        console.log(roles[v.Account__c]);
                        roles[v.Account__c]._children.push(roles[v.Rebate_Account__c]);   
                    });                
                    component.set("v.gridData", roles[undefined]._children);
                    console.log('*******treegrid data:'+JSON.stringify(roles[undefined]._children));
                    
                    component.set('v.gridExpandedRows', expandedRows);
                }, 
                {
                    recId: component.get("v.recordId")
                }
            );    
        }
        
        
        
        
    }
})