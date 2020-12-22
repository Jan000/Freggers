package de.freggers
{
   import flash.display.Sprite;
   import flash.utils.getTimer;
   
   public class AComponent extends Sprite
   {
       
      
      private var _onCallback:Function;
      
      private var _inited:Boolean;
      
      private var _startedAt:int;
      
      protected var config:Object;
      
      public function AComponent()
      {
         super();
      }
      
      public function init(param1:Object) : void
      {
         this.config = param1;
         if(this.config == null)
         {
            this.config = {};
         }
         this._inited = true;
      }
      
      public function start() : void
      {
         this._startedAt = getTimer();
      }
      
      public function stop() : void
      {
         this._startedAt = 0;
      }
      
      public function destroy() : void
      {
         this._startedAt = 0;
         this._inited = false;
         this.onCallback = null;
      }
      
      public function call(param1:String, param2:Array) : *
      {
         var methodname:String = param1;
         var args:Array = param2;
         if(this.hasOwnProperty(methodname) && this[methodname] is Function)
         {
            try
            {
               return (this[methodname] as Function).apply(this,args);
            }
            catch(e:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function get hasdisplay() : Boolean
      {
         return true;
      }
      
      public function update(param1:Number) : void
      {
      }
      
      protected function callback(param1:String, ... rest) : *
      {
         var name:String = param1;
         var args:Array = rest;
         if(this.onCallback == null)
         {
            return;
         }
         try
         {
            return this.onCallback(name,args);
         }
         catch(e:ArgumentError)
         {
            return;
         }
      }
      
      public function set onCallback(param1:Function) : void
      {
         this._onCallback = param1;
      }
      
      public function get onCallback() : Function
      {
         return this._onCallback;
      }
      
      public function get inited() : Boolean
      {
         return this._inited;
      }
      
      public function get started() : Boolean
      {
         return this._startedAt != 0;
      }
      
      public function get startedAt() : int
      {
         return this._startedAt;
      }
   }
}
