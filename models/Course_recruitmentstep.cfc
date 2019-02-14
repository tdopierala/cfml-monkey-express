component
	extends="Model" {
		
		function init(){
			
			belongsTo(name="user", modelName="User");
		}
	}