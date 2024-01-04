trigger PricingRequestProductTrigger on Pricing_Request_Product__c (before update) {
    PricingRequestProductTriggerHelper.checkDeviation(Trigger.new);
}