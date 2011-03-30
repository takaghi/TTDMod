package classes{
	import components.utils.Func;
	
	import mx.utils.ObjectProxy;
	
	public class TaskOperator{
		
		private var taskArr:Array = [];
		private var sortArr:Array = [];
		
		private var future:Boolean;
		
		public function TaskOperator(result:Array, future:Boolean = true){
			this.future = future;
			taskArr = result;
			sortTasks();
		}
		
		private function sortTasks():void{
			var today:Date = new Date();
			var d:Date;
			var o:Object;
			var num:int = 1;
			var diff:int;
			
			
			var testObj:Object = {};
			var arr:Array = [];
			
			var taskArrLength:int = taskArr.length; 				
			for(var i:int = 0; i < taskArrLength; i++){
				var taskObj:Object = taskArr[i];				
				
				var cd:Date = Func.convertMySQLDateToActionscript(taskObj.date_plan_start);
				
				if(d == null || d.getDate() != cd.getDate()){

					if(o != null){
						if(d)
							testObj[Func.getMySQLDate(d)] = o;
						else
							testObj[Func.getMySQLDate(cd)] = o;
					}
					d = cd;
					num = 1;
					o = {};
					o.children = [];
					o.day = taskObj.date_plan_start;
				}
				
				diff = Func.getDateDifference(cd);
				
				var nm:String = ((cd.getDate()<10)?("0"+cd.getDate()):(cd.getDate()))+"."+ (((cd.getMonth()+1)<10)?("0"+(cd.getMonth()+1)):(cd.getMonth()+1))+ ", " + Func.getDayNameFromDate(cd, true);
				
				var child:Object = taskObj;
				child.num = num;
				child.status = Globals.getVar(child.status);
				o.children.push(child);
			//	o.date = new ObjectProxy({name:nm, num:o.children.length, diff:((diff!=0)?diff:"Сегодня"), color:"0xff0000"});
				if(diff<0){
					o.date = new ObjectProxy({name:nm, num:o.children.length, diff:diff, color:"0xff0000"});
				}else if(diff==0){
					o.date = new ObjectProxy({name:nm, num:o.children.length, diff:"Сегодня", color:"0x17bd17"});
					o.future = true;
				}else{
					o.date = new ObjectProxy({name:nm, num:o.children.length, diff:"+"+diff, color:"0x17bd17"});
					o.future = true;
				}
				num++;
			}
			testObj[Func.getMySQLDate(cd)] = o;			
			
			if(future)
				testFuture();
			
			function testFuture():void{
				if(!testObj.hasOwnProperty(Func.getMySQLDate(new Date()))){
					o = {};
					nm = ((today.getDate()<10)?("0"+today.getDate()):(today.getDate()))+"."+ (((today.getMonth()+1)<10)?("0"+(today.getMonth()+1)):(today.getMonth()+1))+ ", " + Func.getDayNameFromDate(today, true);
					o.date = new ObjectProxy({name:nm, num:0, diff:"Сегодня", color:"0x17bd17"});
					o.children = [];
					o.day = Func.getMySQLDate(new Date());
					o.future = true;
					testObj[Func.getMySQLDate(new Date())] = o;
				}
				addFuture(testObj);
			}
			
			for each(var obj:Object in testObj){
				sortArr.push(obj)
			}
			sortArr.sortOn("day");
		}
		
		private function addFuture(obj:Object):void{
			var today:Date = new Date();
			var d:Date;
			var o:Object;
			var num:int = 1;
			var diff:int;
			for(var i:int = 1; i <= 7; i++){
				today.date++;
				if(obj.hasOwnProperty(Func.getMySQLDate(today)))	
					continue;
				o = {};
				var nm:String = ((today.getDate()<10)?("0"+today.getDate()):(today.getDate()))+"."+ (((today.getMonth()+1)<10)?("0"+(today.getMonth()+1)):(today.getMonth()+1))+ ", " + Func.getDayNameFromDate(today, true);
				o.date = new ObjectProxy({name:nm, num:0, diff:"+"+i, color:"0x17bd17"});
				o.children = [];
				o.day = Func.getMySQLDate(today);;
				o.future = true;
				obj[today.getTime()] = o;
			}
		}
		
		public function getTasks():Array{
			return sortArr;
		}
		

		
	}
}