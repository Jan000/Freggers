package de.freggers.roomdisplay
{
   import flash.display.Sprite;
   
   public class AMenuItem extends Sprite
   {
       
      
      private var _slot:int = -1;
      
      private var _enabled:Boolean;
      
      private var _callback:Function;
      
      private var _callbackParams:Array;
      
      public function AMenuItem(param1:Function = null, param2:Array = null)
      {
         super();
         this._callback = param1;
         this._callbackParams = param2;
      }
      
      public function set slot(param1:int) : void
      {
         this._slot = param1;
      }
      
      public function get slot() : int
      {
         return this._slot;
      }
      
      public function cleanup() : void
      {
      }
      
      override public function toString() : String
      {
         return "AMenuItem[" + this._slot + "]";
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function execute() : void
      {
         if(this._callback == null)
         {
            return;
         }
         try
         {
            this._callback.apply(this,this._callbackParams);
            return;
         }
         catch(e:ArgumentError)
         {
            return;
         }
      }
   }
}
