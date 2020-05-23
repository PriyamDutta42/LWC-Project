trigger UserTrigger on User (before insert,before update, after insert, after update) {
	UserTriggerSequenceHandler.handleSeq(trigger.new, trigger.operationtype, trigger.oldmap, trigger.newMap);
}