trigger OrderItemTrigger on OrderItem (before insert, before update) {
    for(OrderItem obj : trigger.new){
        if(obj.Quantity>=10){
            obj.Quantity = obj.Quantity + 1;
            
        }
    }
}