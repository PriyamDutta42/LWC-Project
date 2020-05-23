public class OrderTriggerSequenceHandler {
    public static void handleSeq(list <Order> orderList, system.TriggerOperation eventtype, map <id,order> orderOldMap, map <id,order> orderNewMap){
        switch on eventtype{
            when BEFORE_INSERT{
                OrderHandler.restrictStage(orderList, orderOldMap);
            }
            when BEFORE_UPDATE{
                OrderHandler.restrictStage(orderList, orderOldMap);
            }
        }
    }
}