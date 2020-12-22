package de.freggers.roomdisplay
{
   import flash.events.Event;
   
   public class MyLoaderEvent extends Event
   {
      
      public static const VISIBLE:String = "loadervisible";
      
      public static const HIDDEN:String = "loaderhidden";
       
      
      public function MyLoaderEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
