component 
	extends="Model"  {
	
	function init(){
	
	}
	
	public any function findAllPayment(){
		
		paymentList = application.cfc.winapp.paymentList();
		
		return paymentList;
	}
}