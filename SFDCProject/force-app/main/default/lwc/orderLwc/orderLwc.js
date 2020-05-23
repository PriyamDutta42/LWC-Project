import { LightningElement, track, api,wire } from 'lwc';
import getProducts from '@salesforce/apex/OrderController.getProducts';
import getRecordId from '@salesforce/apex/OrderController.getRecordId';
import createOrderProducts from '@salesforce/apex/OrderController.createOrderProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getItems from '@salesforce/apex/OrderController.getProdDetails';
import getOrd from '@salesforce/apex/OrderController.getOrdDetails';

const columns= [
    {label:'Order Id',fieldname:'Id',type:'text'},
    {label:'Order Amount',field:'TotalAmount',type:'currency'},
    {label:'Total Quantity',field:'TotalQty__c',type:'number'},
];

const columns2 = [
    {label:'Product Name',fieldname:'Product2.Name',type:'text'},
    {label:'Product Code',fieldname:'Product2.ProductCode',type:'text'},
    {label:'Brand',fieldname:'Product2.Brand__c',type:'text'},
    {label:'Stock Quantity',fieldname:'Product2.Stock_Quantity__c',type:'number'},
    {label:'Quantity',fieldname:'Product2.Quantity',type:'number'},
];

export default class OrderLwc extends LightningElement {

    recordId = '';
    orderCreated = false;
    displayList = false;
    selectedItems = true;
    summary = false;
    productList;
    desiredQuantity = 0;
    error;
    selectedProductsList = [];
    @track value='Name';
    @api showModal = false;
    @track data;
    @track columns = columns;
    @track columns2 = columns2;
    @track errorO;
    @track errorP;

    // @wire(getItems,{recordId:'$recordId'})
    // data;

    // @wire(getOrd,{recordId:'$recordId'})
    // data2;



    reset(event){
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach((field) => {
                field.reset();
            });
        }
    }

    get options() {
        return [
            { label: 'Product Name', value: 'Name' },
            { label: 'Product Brand', value: 'Brand__c' },
            { label: 'MRP', value: 'UnitPrice' }
        ];
    }

    handleSuccess(event) {
        this.orderCreated = true;
        if (this.orderCreated) {
            getRecordId()
                .then(result => {
                    this.recordId = result;
                    
                })
        }
         //toast
    
         event = new ShowToastEvent({
            title: 'Success!',
            message: 'Order Created',
        });
        this.dispatchEvent(event);
    }

    radioChange(event){
        this.value = event.detail.value;
    }


    searchProducts(event) {
      //  var opts = document.querySelector('input[name="searchOps"]:checked').value;
            var searchValue = event.target.value;
            console.log(this.value);
            if (searchValue.length > 0) {
            getProducts({ searchBy: this.value , searchText: searchValue, pbId: '01s2w000004xwQ5AAI' })
                .then(result => {
                    console.log(result);
                    console.log('inside get products success 1');
                    this.productList = JSON.parse(result);
                    console.log('inside get products success 2');
                    this.displayList = true;
                    console.log(this.productList);
                })
                .catch(error => {
                    console.log('inside get products error');
                    this.error = error;
                });
            
            }

        else {
            this.displayList = false;
        }
    }

    addProduct(event) {
        if (this.recordId == null || this.recordId == '') {
            alert('Please create a record first');
        } else if (this.desiredQuantity < 0) {
            alert('Please enter a valid value');
        } else {
            this.selectedItems = false;
            var pId = event.target.value;
            var index = -1;
            var selectedProduct = new Object();
            for (var product of this.productList) {
                index++;
                if (pId == product.Id) {
                    selectedProduct.Id = product.Id;
                    selectedProduct.Name = product.Name;
                    selectedProduct.ProductCode = product.ProductCode;
                    selectedProduct.Brand__c = product.Brand__c;
                    selectedProduct.Stock_Quantity__c = product.Stock_Quantity__c;
                    selectedProduct.Quantity = 0;
                    selectedProduct.UnitPrice = 0;
                    selectedProduct.ListPrice = product.ListPrice;
                    selectedProduct.Discount = 0;
                    selectedProduct.PriceBookEntryId = product.PriceBookEntryId;
                    break;
                }
            }
            if (!this.selectedProductsList.some(prod => prod.Id === selectedProduct.Id)) {
                this.selectedProductsList.push(selectedProduct);
            }
            this.selectedItems = true;
        }
    }

    removeProduct(event) {
        var id = event.target.value;
        for (var product of this.selectedProductsList) {
            if (id == product.Id) {
                const index = this.selectedProductsList.indexOf(product);
                this.selectedProductsList.splice(index, 1)
            }
        }
        this.selectedItems = false;
        this.selectedItems = true;
    }

    updateQuantity(event) {
        var index = -1;
        for (var product of this.selectedProductsList) {
            index++;
            if (event.target.name == product.Id) {
                break;
            }
        }
        this.selectedProductsList[index].Quantity = event.target.value;
    }

    updateDiscount(event) {
        var index = -1;
        for (var product of this.selectedProductsList) {
            index++;
            if (event.target.name == product.Id) {
                break;
            }
        }
        this.selectedProductsList[index].Discount = event.target.value;
    }

    saveOrderProducts(event) {
        this.selectedItems = false;
        for (var product of this.selectedProductsList) {
           
            product.UnitPrice = product.ListPrice - (product.ListPrice * product.Discount / 100);
        }

        createOrderProducts({ selectedProducts: JSON.stringify(this.selectedProductsList), priceBookId: '01s2w000004xwQ5AAI', orderId: this.recordId })
            .then(result => {
                console.log('Order Id : ' + result);
            })
            .catch(error => {
                console.log(error);
            });
        this.summary = true;
        //toast
            if(this.result){
        event = new ShowToastEvent({
            title: 'Success!',
            message: 'Product Created',
        });
        this.dispatchEvent(event);
    }
    }

        @api
    changeModal(event){
        
        if(this.recordId){

            console.log('inside get summary');

            getOrd({recordId : this.recordId})
                .then(result => {
                    console.log('data ke andar');
                    this.data = result;
                    this.errorO = undefined;
                    console.log(this.data);
            })
            .catch((error) => {
                this.errorO = error;
            });
    
            getItems({recordId :this.recordId})
                .then(result=>{
                        console.log('data2 ke andar');
                            this.data2 = result;
                            this.errorP = undefined;
                            console.log(this.data2);
                    })
                    .catch((error) => {
                        
                        this.errorP = error;
                    }); 
        
            this.showModal = true;

        }
        
        

    }
    @api
    closeModal(event){
        this.showModal = false;
    }

}
