package classes{
	
	import components.utils.Func;
	import components.utils.TitleGroup;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.VGroup;
	import spark.layouts.VerticalLayout;
	
	/**
	 * 	Менеджер настроек
	 */	
	public class SettingManager	{
		
		
		private static var initiated:Boolean = false;
		private static var pool:Vector.<UIComponent> =new Vector.<UIComponent>();
		
		/**
		 * Настройки поумолчанию
		 * 
		 */ 
		private static var settingsArray:Array = [
			{	component: "components.LoginForm", 
				sub: "endpoint",
				title: "Выбор хоста",
				options: [
					{	title	:	"Отображать",
						type	:	"boolean",
						name	:	"visible",
						value	:	false
					}
					
				]},
			
			{	component: "widgets.NDS", 
				title: "НДС форма",
				options: [
							{	title	:	"Отображать форму",
								type	:	"boolean",
								name	:	"visible",
								value	:	false
								}
					
				]},
			
			{	component: "widgets.PrivateTasks", 
				title: "Личные задачи",
				options: [
							{	title	:	"Отображать личные задачи",
								type	:	"boolean",
								name	:	"visible",
								value	:	false
							},
							{	title	:	"Ширина",
								type	:	"number",
								name	:	"width",
								value	:	250
							}
				]}
		]; 
		
		private static var componentsArr:Dictionary = new Dictionary(true);
		
		
		private static var instance:SettingManager;
		
		public static var controller:VGroup = new VGroup();
		
		public function SettingManager(){
			instance = this;
			instance.initSettings();
			readAllSettings();
		}
		
		/**
		 * 	Берет настройки из SharedObject.
		 * 	Если есть компоненты инициированые ранее, отправляет их на настройку
		 * 
		 */ 
		private function initSettings():void{
			if(initiated)
				return;
			
			if(SharedManager.getObj("settings")!=null){	
				trace("readSettings")
				settingsArray = Func.arrConcatUnique(settingsArray, SharedManager.getObj("settings") as Array)
				//			settingsArray = SharedManager.getObj("settings") as Array
			}
			initiated = true;
			
			for each(var component:UIComponent in pool){
				setOptions(component);
			}
		}
		
		private function readAllSettings():void{			
			createController();
		}
		
		/**
		 * 	Создает контроллер настроек.
		 * 	В зависимости от типа добавляются инпуты.
		 * 
		 */ 
		private function createController():void{
			for(var i:int=0; i < settingsArray.length; ++i){
				var o:Object = settingsArray[i];
				var group:TitleGroup = new TitleGroup();
				group.title = o.title;
				group.percentWidth = 100;
				group.layout = new VerticalLayout();
				
				for(var j:int=0; j<o.options.length; ++j){
					var op:Object = o.options[j];
					
					switch(op.type){
						
						case "boolean" :	
							group.addElement(getCheck(o.component, op));
							break;
						case "number" :	
							group.addElement(getNum(o.component, op));
							break;
						default : return;
					}					
				}
				controller.addElement(group);				
			}
			
			function getCheck(componentClass:String, op:Object):CheckBox{
				var check:CheckBox = new CheckBox();
				check.label = op.title;
				check.selected = op.value;
				check.addEventListener(Event.CHANGE, function():void{updateProperty(componentClass, op, check.selected)});
				return check;
			}
			function getNum(componentClass:String, op:Object):HGroup{
				var hg:HGroup = new HGroup();
				hg.verticalAlign = "middle";
				var l:Label = new Label();
				l.text = op.title;
				var num:NumericStepper = new NumericStepper();
				num.value = op.value;
				num.maximum = 700;
				num.minimum = 100;
				num.addEventListener(Event.CHANGE, function():void{updateProperty(componentClass, op, num.value)});
				hg.addElement(l);
				hg.addElement(num);
				return hg;
			}
		}
		
		/**
		 *	Обновляет компонент в реальном времени 
		 * 
		 */ 
		private function updateProperty(componentClass:String, op:Object, value:*):void{
			for(var s:Object in componentsArr){
				if(getQualifiedClassName(s).replace("::", ".") == componentClass){
					DisplayObject(s)[op.name] = value;
					op.value = value;
				}
			}	
		}		
		
		/**
		 *	Регистрация настраеваемых компонентов.
		 * 	Ссылка в коде компонента 
		 * 
		 */ 
		public static function initComponent(component:*):void{	
			componentsArr[component] = component.name;
			if(UIComponent(component).initialized){	
				setOptions(component as UIComponent);
			}else{
				UIComponent(component).addEventListener(FlexEvent.INITIALIZE, getComponent);
			}	
		}
		
		/**
		 * 	Если компонент зарегестрирован раньше конструктора, он помещается в пул, ждет конструктора,
		 * 	в другом случае компонент передается на настройку
		 * 	
		 */ 
		private static function getComponent(e:FlexEvent):void{
			var component:UIComponent = e.target as UIComponent;
			component.removeEventListener(FlexEvent.INITIALIZE, getComponent);
			
			if(!initiated){
				pool.push(component);
				return;
			}
			setOptions(component);
		}
		
		
		private static function setOptions(component:UIComponent):void{	
						
			for(var i:int=0; i < settingsArray.length; i++){
				var o:Object = settingsArray[i];				
				
				if(getQualifiedClassName(component).replace("::", ".") == o.component){					
					
					for(var j:int=0; j < o.options.length; ++j){
						var op:Object = o.options[j];
						
						switch(op.type){							
							case "boolean" : case "number" :
								if(o.sub != undefined){
									DisplayObject(component)[o.sub][op.name] = op.value;
								}else{
									DisplayObject(component)[op.name] = op.value;
								}
								break;
							default : return;
						}
					}				
				}				
			}
		}
		
		public static function update():void{			
			SharedManager.setObj("settings", settingsArray);
		}
		
	}
}