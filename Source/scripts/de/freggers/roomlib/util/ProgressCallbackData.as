package de.freggers.roomlib.util
{
   public class ProgressCallbackData
   {
       
      
      private var _target:Object;
      
      private var _callback:Function;
      
      public function ProgressCallbackData(param1:Object, param2:Function)
      {
         super();
         this._target = param1;
         this._callback = param2;
      }
      
      public function execute(param1:uint, param2:uint) : void
      {
         if(this._callback != null)
         {
            this._callback(this._target,param1,param2);
         }
      }
   }
}
