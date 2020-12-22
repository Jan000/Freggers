package de.schulterklopfer.interaction.manager
{
   import de.schulterklopfer.interaction.data.MouseManagerData;
   
   final class MouseEventData
   {
       
      
      public var events:Array;
      
      public var callback:Function;
      
      public var currentMouseData:MouseManagerData;
      
      public var lastMouseData:MouseManagerData;
      
      function MouseEventData()
      {
         super();
      }
      
      public function clone() : MouseEventData
      {
         var _loc1_:MouseEventData = new MouseEventData();
         _loc1_.events = this.events;
         _loc1_.callback = this.callback;
         _loc1_.currentMouseData = this.currentMouseData;
         _loc1_.lastMouseData = this.lastMouseData;
         return _loc1_;
      }
      
      public function toString() : String
      {
         return "MouseEventData";
      }
   }
}
