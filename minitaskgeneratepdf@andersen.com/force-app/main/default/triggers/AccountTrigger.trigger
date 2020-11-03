trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.afterUpdate(trigger.newMap);
    }
}