trigger SymphonyRatingReturn on Symphony_Rating_Return__e (after insert) {
    SymphonyTriggerHandler.SymphonyRatingReturn(trigger.new);
}