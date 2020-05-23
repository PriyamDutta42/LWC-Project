public class OrderApexPageController {
	public OrderItem currentRecord{get; set;}
    public String message{get;set;}    
    
	    public OrderApexPageController(ApexPages.StandardController controller) {
            try{
	        currentRecord = [SELECT Id, Quantity FROM OrderItem WHERE OrderId = :ApexPages.currentPage().getParameters().get('id')];
            if(currentRecord.Id != NULL){
            if(currentRecord.Quantity >=10){
                message = 'You get a free product!';
            }}
    else{
        message = '';
    }}catch(Exception e){
        
    }
      
	    }

	 
}