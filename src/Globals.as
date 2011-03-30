package{
	public class Globals{
		
		public static var endpoint:String;
		
		/**
		 * Ключ пользователя, используется для идентификации на сервере.
		 * Отправляется в каждом запросе.
		 */
		public static var userKey:String = "abefbbd2f0bbdd10767b3efb2b22b842";
		
		/**
		 * Идентификатор пользователя
		 */
		[Bindable]
		public static var id_staff:String = "";
		
		/**
		 * Набор прав пользователя
		 */
		[Bindable]
		public static var access:Object = {};
		
		/**
		 * 
		 */
		public static var vars:Object = {};
		
		/**
		 * Массив русских названий месяцев.
		 */
		[Bindable]
		public static var months:Array = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"];
		
		/**
		 * Массив русских названий дней.
		 */
		[Bindable]
		public static var days:Array = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];
		
		[Bindable]
		public static var onlineUsers:Array;
		
		/**
		 * Расшифровка методов-запросов для лога
		 */
		public static var methods:Object = {
			Tasks_getList				:	"Запрос списка невыполненных задач",
			Tasks_getConfirmList		:	"Запрос списка задач на подтверждение",
			Tasks_getRedirectList		:	"Запрос списка задач на перенаправление",
			Tasks_getMoveList			:	"Запрос списка задач на перемещение",
			Tasks_getDoneList			:	"Запрос списка выполненных задач",
			Tasks_getAcceptList			:	"Запрос списка подтвержденных задач",
			Tasks_redirectRealization	:	"Запрос на перенаправление задачи",
			Tasks_getOne				:	"Запрос задачи",
			Tasks_getEdit				:	"Запрос редатирования задачи",
			Tasks_addComment			:	"Добавление комментария к задаче",
			Tasks_complete				:	"Задача выполнена",
			Tasks_confirmComplete		:	"Задача завершена",
			Tasks_cancel				:	"Задачу невозможно выполнить",
			Tasks_confirmCancel			:	"Задача завершена",
			Tasks_incomplete			:	"Задача возвращена",
			Tasks_delete				:	"Задача удалена",
			Tasks_add					:	"Задача добавлена",
			Tasks_getEdit				:	"Редактирование задачи",
			Tasks_edit					:	"Задача отредактирована",
			Tasks_move					:	"Задача перемещена",
			
			Users_getList				:	"Запрос списка пользователей",
			Users_getLiteList			:	"Запрос списка пользователей",
			Users_getDepartments		:	"Запрос списка отделов",
			Users_getDv3				:	"Запрос списка видов занятости",
			Users_getOne				:	"Запрос пользователя",
			Users_add					:	"Пользователь добавлен",
			Users_getEdit				:	"Редактирование пользователя",
			Users_edit					:	"Пользователь отредактирован",
			Users_delete				:	"Пользователь удален",
			
			Projects_getList			:	"Запрос списка проектов",
			Projects_getLiteList		:	"Запрос списка проектов",
			Projects_add				:	"Проект добавлен",
			Projects_edit				:	"Проект отредактирован",
			Projects_delete				:	"Проект удален",
			
			PrivateList_getList			:	"Запрос списка приваток",
			PrivateList_add				:	"Приватка добавлена",
			PrivateList_edit			:	"Приватка отредактирована",
			PrivateList_delete			:	"Приватка удалена",
			
			Calendar_getList			:	"Календарь",
			Calendar_getStatusList		:	"Запрос списка статусов",
			Calendar_delete				:	"Удаление записи",
			Calendar_add				:	"Добавление записи",
			
			Holidays_getList			:	"Праздники",
			Holidays_delete				:	"Удаление записи",
			Holidays_add				:	"Добавление записи",
			
			Vars_getList				:	"Запрос списка переменных VARS",
			
			ServiceManager_refresh		:	"Запрос новых данных (refresh)"
			
			
		}
		
		/**
		 * Расшифровка кодов ошибок.
		 */
		public static var errors:Object = {
			err100: "Ничего не работает",
			err101: "SQL ошибка",
			err102: "Нет подключения к Базе Данных",
			err201: "Действие запрещено",
			err202: "Незарегестрированная сессия",
			err203: "Запись заблокирована для редактирования",
			err204: "Запись не заблокирована для Вас",
			err205: "Не заполнено обязательное поле",
			err206: "Не передан идентификатор сессии",
			err207: "Неверный идентификатор",
			err208: "XML файл не найден",
			err209: "Сессия закончена.",
			err210: "Логин уже используется",
			err301: "Сотрудник не найден",
			err302: "Не указаны права для сотрудника",
			err303: "Сотрудник добавлен",
			err304: "Не удалось добавить сотрудника",
			err305: "Сотрудник отредактирован",
			err306: "Не удалось отредактировать сотрудника",
			err307: "Сотрудник удален",
			err308: "Не удалось удалить сотрудника",
			err320: "Авторизация успешно",
			err321: "Неправильный логин или пароль",
			err322: "Неправильный логин или пароль",
			err330: "Проект не найден",
			err333: "Проект добавлен",
			err334: "Не удалось добавить проект",
			err335: "Проект отредактирован",
			err336: "Не удалось отредактировать проект",
			err337: "Проект удален",
			err338: "Не удалось удалить проект",
			err360: "Задача не найдена",
			err361: "Задача добавлена",
			err362: "Не удалось добавить задачу",
			err363: "Задача отредактирована",
			err364: "Не удалось отредактировать задачу",
			err365: "Задача удалена",
			err366: "Не удалось удалить задачу",
			err367: "Комментарий добавлен",
			err368: "Добавить комментарий не удалось",
			err369: "Задача выполнена",
			err370: "Не удалось изменить статус задачи",
			err371: "Задача завершена",
			err372: "Не удалось изменить статус задачи",
			err373: "Задача отменена",
			err374: "Не удалось изменить статус задачи",
			err375: "Задача удалена",
			err376: "Не удалось изменить статус задачи",
			err377: "Задача возвращена",
			err378: "Не удалось изменить статус задачи",
			err379: "Задачи передвинуты",
			err380: "Задачи переданы",
			err381: "Порядок задач изменен",
			err382: "Подвинуть задачи не удалось"
		}
			
		public static var dayColors:Object = {job_a: 0xE8F2FE, job_m:0xE8F2FE, day_off:0xFFC5EE, truancy:0xff0000, sick:0xff0000, sick_list:0xff0000, weekend:0x50AFE4, holiday:0xFF5AC3, none:0xffffff, del:0xffeeee };
		

		public static var taskStatusColors:Object = {task_incomplete: 0xFF9C00, task_complete: 0x64af72, task_finish: 0x64af72, task_impossible:0xEE6161};
		public static var taskPriorityColors:Object = {normal: 0xFF9C00, priority: 0xFF5400, urgency: 0xEE6161, all: 0xBD1717};
		
		
		public static var idleFactor:Boolean = false;
		
		
		public static var taskRepeatData:Object;
		public static var privateTaskRepeatData:Object;
		
		/**
		 * Получение значения ощибки по коду
		 * @param	code код ошибки
		 * @return	Значение ошибки
		 */
		public static function getVar(code:String):String{
			if(Globals.vars && Globals.vars["var"+code])
				return Globals.vars["var"+code];
			else
				return "неизвестный код справочника Vars: "+code;
		}
		

		
		
	}
}