package classes{
	import components.utils.Func;
	
	import mx.utils.ObjectProxy;
	
	public class CalendarOperator{
		
		private var taskArr:Array = [];
		private var sortArr:Array = [];
		
		private var details:Boolean;
		
		public function CalendarOperator(result:Array, details:Boolean = true){
			this.details = details;
			taskArr = result;
			sortTasks();
		}
		
		private function sortTasks():void{
			
			var tempDate:String;
			var o:Object;
			
			var total:Number = 0;
			var time_start:Number = 0;
			var time_finish:Number = 0;
			
			var testObj:Object = {};
			var arr:Array = [];
			
			for(var i:int = 0; i < taskArr.length; i++){
				var cd:String = taskArr[i].date;
				
				if(tempDate == null || tempDate != cd){					
					if(o != null){						
						
						o.date = new ObjectProxy({
							name:tempDate, 
							num:o.children.length, 
							status:status, 
							color:Globals.dayColors[status], 							
							total: Func.convertNumberToStringTime(total),
							time_start: Func.convertNumberToStringTime(time_start),
							time_finish: Func.convertNumberToStringTime(time_finish)
						});
						trace("status:",status)
										
						if(tempDate)
							testObj[tempDate] = o;
						else
							testObj[cd] = o;
					}
					total = 0;
					time_start = 0;
					time_finish = 0;
					tempDate = cd;
					var status:String = (taskArr[i].status) ? taskArr[i].status : "none";
					o = {};
					o.children = [];
					o.day = taskArr[i].date;
				}								
				
				var child:Object = taskArr[i] as Object;
				if(!child.time_start){
					continue;
				}
				if(details)
					o.children.push({id_calendar:child.id_calendar, time_start:child.time_start, time_finish:child.time_finish, total:child.total, status_text:child.status_text});
				
				total += Func.convertStringTimeToNumber(child.total);
				if(time_start==0)
					time_start = Func.convertStringTimeToNumber(child.time_start);
				time_finish = (Func.convertStringTimeToNumber(child.time_finish) > time_finish) ? Func.convertStringTimeToNumber(child.time_finish) : time_finish;
				
			}	
			
			
			if(o != null){						
				o.date = new ObjectProxy({
					name:tempDate, 
					num:o.children.length, 
					status:status, 
					color:Globals.dayColors[status], 
					total: Func.convertNumberToStringTime(total),
					time_start: Func.convertNumberToStringTime(time_start),
					time_finish: Func.convertNumberToStringTime(time_finish)
				});
				
				if(tempDate)
					testObj[tempDate] = o;
				else
					testObj[cd] = o;
			}
			
			for each(var obj:Object in testObj){
				sortArr.push(obj)
			}
			sortArr.sortOn("day");
		}
				
		public function getDays():Array{
			return sortArr;
		}
		

		
	}
}