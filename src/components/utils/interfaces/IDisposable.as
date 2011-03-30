package components.utils.interfaces
{
	public interface IDisposable{
		
		/**
		 * Free references in this method
		 */
		function dispose():void;
		
		/**
		 * Check return value to prevent Object be disposed twice
		 * @return true if Object was disposed, false in other case
		 */
		function isDisposed():Boolean;
		
	}
}