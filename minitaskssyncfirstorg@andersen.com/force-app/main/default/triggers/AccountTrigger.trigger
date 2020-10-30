trigger AccountTrigger on Account (After update) {
    if (trigger.isUpdate && trigger.isAfter) {
        AccountTriggerHandler.afterUpdate(trigger.newmap);
    }
}