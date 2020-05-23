trigger OrderTrigger on Order (before update) {
	OrderTriggerSequenceHandler.handleSeq(trigger.new, trigger.operationtype, trigger.oldmap, trigger.newMap);
}