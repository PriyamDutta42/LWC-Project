public class UserTriggerSequenceHandler {
    public static void handleSeq(list <User> userList, system.TriggerOperation eventtype, map <id,User> userOldMap, map <id,User> userNewMap){
        switch on eventtype{
            when BEFORE_INSERT{
         		   UserHandler.checkManagerProfile(userList,userOldMap, userNewMap);    
            }
            when BEFORE_UPDATE{
                UserHandler.checkManagerProfile(userList,userOldMap, userNewMap);
                UserHandler.checkManagedCount(userList,userOldMap, userNewMap);
            }
        }   
    }
}