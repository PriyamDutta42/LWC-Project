public class OrderHandler {
        public static void restrictStage(list<Order> ordlist, map<Id,Order> oldmap){
            for(Order o : ordlist){
                if(o.Stage__c != oldmap.get(o.Id).Stage__c){
                    if(oldmap.get(o.Id).Stage__c == 'Cancelled' || oldmap.get(o.Id).Stage__c == 'Delivered')
                    {o.addError('Stage cannot be changed after delivery or cancellation');}
                    if(oldmap.get(o.Id).Stage__c == 'Delivery in Plan'){
                        if(o.Stage__c != 'Cancelled' || o.Stage__c != 'Delivered'){
                            o.addError('Cannot revert Stage');
                        }
                    }
                    else if (oldmap.get(o.Id).Stage__c == 'Payment Received'){
                        if(o.Stage__c != 'Cancelled' || o.Stage__c !='Delivered' || o.Stage__c != 'Delivery in Plan'){
                            o.addError('Cannot revert Stage');
                        }
                    }
                    else if (oldmap.get(o.Id).Stage__c == 'Invoice Generated'){
                        if(o.Stage__c == 'Created' || o.Stage__c == 'In process'){
                            o.addError('Cannot revert Stage');
                        }
                    }
                    else if(oldmap.get(o.Id).Stage__c == 'In process'){
                        if(o.Stage__c == 'Created'){
                            o.addError('Cannot revert Stage');
                        }
                    }
                }
            }
    }
}