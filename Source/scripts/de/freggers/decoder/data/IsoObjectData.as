package de.freggers.decoder.data
{
   import de.freggers.isocomp.AIsoComponent;
   import flash.geom.Rectangle;
   
   public class IsoObjectData
   {
       
      
      public var version:uint;
      
      public var tileBase:uint;
      
      public var sizeU:uint;
      
      public var sizeV:uint;
      
      public var sitBounds:Rectangle;
      
      public var sitDirections:Array;
      
      public var defaultDirection:uint;
      
      public var gripDirection:uint;
      
      public var defaultAnimation:String;
      
      public var defaultFrame:uint;
      
      public var animations:Object;
      
      public var isoComponent:AIsoComponent;
      
      public var sounds:Object;
      
      public var trigger:TriggerData;
      
      public var lightmaps:Object;
      
      public function IsoObjectData()
      {
         super();
      }
   }
}
