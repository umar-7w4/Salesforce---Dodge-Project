trigger CaseBeforeUpdateTrigger on Case (before update) {
    CaseTriggerHelper.updateCases(trigger.new);
}