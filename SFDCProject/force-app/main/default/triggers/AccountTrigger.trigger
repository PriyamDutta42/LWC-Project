trigger AccountTrigger on Account (before insert,before update) {
    Profile bu = [SELECT id FROM PROFILE where Name = 'Business User'];
        Profile su = [SELECT id FROM PROFILE where Name = 'Sales User'];
    
    switch on trigger.operationtype{
        when BEFORE_INSERT{
            for(Account acc : trigger.new){
                list<Account> x = [SELECT Id FROM Account where OwnerId =: acc.OwnerId];
                User u = [SELECT Id,ProfileId FROM User WHERE Id = : acc.OwnerId];
                if(x.size()>5 && u.ProfileId == su.Id)
                {
                    acc.addError('A single sales user can only have 5 accounts');
                }
            }
        }
        when BEFORE_UPDATE{
            for(Account acc : trigger.new){
                if(acc.OwnerId != trigger.oldMap.get(acc.Id).OwnerId){
                    list<Account> x2 = [SELECT Id FROM Account where OwnerId =: acc.OwnerId];
                User u2 = [SELECT Id,ProfileId FROM User WHERE Id = : acc.OwnerId];
                if(x2.size()>10 && u2.ProfileId == bu.Id)
                {
                    acc.addError('A single business user can only have 10 accounts');
                }
                }
            }
        }
    }
}