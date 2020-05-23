public with sharing class OrderController {

    public OrderController() {

    }

    class Product{
        public String Id;
        public String Name;
        public String ProductCode;
        public String Brand;
        public String Stock_Quantity;
        public String Quantity;
        public String ListPrice;
        public String UnitPrice;
        public String Discount;
        public String PriceBookEntryId;
    }

    @AuraEnabled
    public static list<OrderItem> getProdDetails(String recordId){
        if(recordId!=null)
        {return [select id,product2.name,product2.productcode,product2.brand__c,product2.stock_quantity__c,quantity from orderitem where orderid =: recordId];
         //   return [select id,quantity from orderitem where orderid =: recordId];
        }
    else {
        return new list<OrderItem>();
    }
}

    @AuraEnabled
    public static list<Order> getOrdDetails(String recordId){
        if(recordId!=null){
        return [select id,totalamount,totalqty__c from order where id=:recordid];
    }
    else{
        return new list<Order> ();
    }
}

    // @AuraEnabled
    // public static Integer getTotalQty (String recordId){
    //     AggregateResult[] agResults = [select sum(quantity) from orderitem where orderid=:recordId];
    //     Integer qty = (Integer)agResults[0].get('qty');
    //     return qty;
    // }
    @AuraEnabled
    public static string getRecordId(){
        list<Order> recId = [SELECT Id FROM Order ORDER BY CreatedDate DESC LIMIT 1];
        String rId = '' + recId[0].Id;
        return rId;
    }

    @AuraEnabled
    public static string getProducts(String searchBy, String searchText, String pbId){
        map<Id,Product2> prodList;
        Map<Id,PriceBookEntry> priceMap;
        if(searchBy.equals('Name')){
        prodList= new map<Id,Product2>([select Id,ProductCode,Name,Brand__c,Stock_Quantity__c from Product2 where Name LIKE :'%'+searchText+'%']);
        }
        if(searchBy.equals('Brand__c')){
        prodList= new map<Id,Product2>([select Id,ProductCode,Name,Brand__c,Stock_Quantity__c from Product2 where Brand__c LIKE :'%'+searchText+'%']);
        }
        if(searchBy.equals('UnitPrice')){
                if(searchText.isNumeric()){
                    Decimal dec = Decimal.valueOf(searchText);
              priceMap = new Map<Id,PriceBookEntry>([select Product2Id,name,unitprice from pricebookentry where unitprice =: dec]);
              prodList= new map<Id,Product2>([select Id,ProductCode,Name,Brand__c,Stock_Quantity__c from Product2 where Id in : priceMap.keySet()]);
                }
         }
        list<PricebookEntry> pbeList=[select Id,Product2Id,UnitPrice from PricebookEntry where Product2Id IN :prodList.keySet() AND Pricebook2Id=:pbId];
        map<Id,String> priceBookList=new map<Id,String>();
        map<Id,Decimal> unitPriceList=new map<Id,Decimal>();
        for(PricebookEntry item:pbeList){
            priceBookList.put(item.Product2Id,item.Id);
            unitPriceList.put(item.Product2Id,item.UnitPrice);
        }
        String str='[';
        for(Id key:prodList.keySet()){
            str+='{"Id":"'+key+'","'+'Name":"'+prodList.get(key).Name+'","'+'ProductCode":"'+prodList.get(key).ProductCode+'","'+'ListPrice":"'+unitPriceList.get(key)+'","'+'Quantity":"","Brand__c":"'+prodList.get(key).Brand__c+'","'+'Stock_Quantity__c":"'+prodList.get(key).Stock_Quantity__c+'","'+'PriceBookEntryId":"'+priceBookList.get(key)+'"}'+',';
        }
        str = str.substring(0, str.length()-1);
        str+=']';
        System.debug(str);
        if(str.equals(']')){
            str='';
        }
        return str;
    }

    @AuraEnabled
    public static string createOrderProducts(String selectedProducts,String priceBookId, String orderId){
                
        List<Product> productList = (List<Product>)JSON.deserialize(selectedProducts, List<Product>.class);

        Order order=[Select Stage__c,Pricebook2Id from Order where Id=:orderId];
        order.Pricebook2Id = priceBookId;
        order.Stage__c = 'In process';
        update order;

        list<OrderItem> orderItemList = new list<OrderItem>();
        try{
            for(Product product:productList){
            orderItemList.add(new OrderItem(OrderId=orderId,Product2Id=product.Id,Quantity=Decimal.valueOf(product.Quantity),UnitPrice=Decimal.valueOf(product.UnitPrice),PricebookEntryId=product.PriceBookEntryId));
        }
        insert orderItemList;
        return 'Your order is ready';}
        catch(Exception e){
            return 'Error';
        }
    }

}