package components.utils.validators
{
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class timeInputValidator extends Validator{
		public function timeInputValidator(){
			super();
		}
		
		
		
		override protected function doValidation(value:Object):Array {		
			
			
			var inputValue:String = StringUtil.trim(String(value));
		
			
			
			// create an array to return.
			var ValidatorResults:Array = new Array();
			// Call base class doValidation().
			ValidatorResults = super.doValidation(value);       
			// Return if there are errors.
			if (ValidatorResults.length > 0)
				return ValidatorResults;
			
			if (String(value).length == 0)
				return ValidatorResults;
			
			if (inputValue.length < 5){
				ValidatorResults.push(new ValidationResult(true, null, "Время не заполнено"));
				return ValidatorResults;
			}
			
		/*	var a:Array = RegPattern.exec(String(value));
			if (a == null)
			{
				ValidatorResults.push(new ValidationResult(true, null, "IPAddress Error","You must enter an IP Address"));
				return ValidatorResults;
			}*/
			return ValidatorResults;
		}


		
		
	}
}