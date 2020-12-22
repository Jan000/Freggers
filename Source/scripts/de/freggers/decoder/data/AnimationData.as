package de.freggers.decoder.data
{
   import de.freggers.isocomp.AIsoComponent;
   
   public class AnimationData
   {
       
      
      public var label:String;
      
      public var directions:Array;
      
      public var isoComponent:AIsoComponent;
      
      public var frameCount:uint;
      
      public var frameWidth:int;
      
      public var frames:Array;
      
      public var hasBounds:Boolean;
      
      public var bounds:Array;
      
      public function AnimationData()
      {
         super();
      }
   }
}
