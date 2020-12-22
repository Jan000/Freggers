package de.freggers.notify
{
   import flash.display.InteractiveObject;
   
   public final class NotifyElement
   {
      
      public static const FLAG_PERMANENT:uint = 1;
      
      public static const FLAG_SHOWMAXIMIZED:uint = 2;
       
      
      public var icon:InteractiveObject;
      
      public var view:InteractiveObject;
      
      public var flags:int;
      
      public var notifyClass:String;
      
      public function NotifyElement(param1:InteractiveObject, param2:InteractiveObject = null, param3:int = 0, param4:String = null)
      {
         super();
         this.view = param1;
         this.icon = param2;
         this.flags = param3;
         this.notifyClass = param4;
      }
   }
}
