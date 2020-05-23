public class UserHandler {
     public static void checkManagerProfile(list<User> userList,map<Id,User> userOldMap,map<Id,User> userNewMap){
        Profile bu = [SELECT id FROM PROFILE where Name = 'Business User'];
        Profile su = [SELECT id FROM PROFILE where Name = 'Sales User'];
         
         for(User u : userList){
             Id up = u.ProfileId;
             if(up == su.Id)
             {
                 User x = [select Id, ProfileId from User where ManagerID =: u.ManagerId];
                 if(x.ProfileId != bu.Id)
                 {
                     u.addError('Manager must be a Business User');
                 }
             }
         }
    }
    public static void checkManagedCount(list<User> userList,map<Id,User> userOldMap,map<Id,User> userNewMap){
        for(User u : userList){
            if(u.ManagerId != userOldMap.get(u.Id).ManagerId && u.ManagerId != NULL)
            {
                List<User> managed = [SELECT Id FROM User where ManagerId =: u.ManagerId];
                if(managed.size()>2)
                {
                    u.ManagerId.addError('The selected Manager has no vacancies');
                }
            }
        }
    }
}