package de.freggers.roomdisplay
{
   import de.freggers.isostar.IsoDisplayObject;
   
   public class TargetPicker
   {
      
      public static const WOBID_INV:uint = 1;
      
      public static const WOBID_ROOM:uint = 2;
      
      public static const UVZ_FLOORED:uint = 4;
      
      public static const UVZ:uint = 8;
       
      
      public var customPointer:IsoDisplayObject = null;
      
      public var selectionFlags:uint;
      
      public var target;
      
      public var passthroughData:Object;
      
      public function TargetPicker(param1:uint, param2:IsoDisplayObject, param3:Object)
      {
         super();
         this.selectionFlags = param1;
         this.customPointer = param2;
         this.passthroughData = param3;
      }
   }
}
