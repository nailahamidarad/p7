trigger OrderTrigger on Order (before insert, before update) {
    if (Trigger.isInsert || Trigger.isUpdate) {
        OrderService.validateOrder(Trigger.new); 

}}