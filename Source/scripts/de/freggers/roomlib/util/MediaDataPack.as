package de.freggers.roomlib.util
{
   import de.freggers.data.Lightmap;
   import de.freggers.decoder.Decoder;
   import de.freggers.util.MediaContainerContent;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class MediaDataPack extends ADataPack
   {
      
      public static const DEFAULT_DIRECTION:int = 0;
       
      
      private var _triggers:Object;
      
      private var _images:Object;
      
      public function MediaDataPack(param1:String)
      {
         super(param1);
      }
      
      public function getImageLabels() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._images)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getTriggerLabels() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._triggers)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getImage(param1:String) : BitmapData
      {
         return this._images[param1];
      }
      
      public function getTrigger(param1:String) : Object
      {
         return this._triggers[param1];
      }
      
      public function hasImage(param1:String) : Boolean
      {
         return this._images[param1] != null;
      }
      
      public function hasTrigger(param1:String) : Boolean
      {
         return this._triggers[param1] != null;
      }
      
      override public function decode(param1:MediaContainerContent) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:Object = Decoder.decodeMediapackContainer(param1);
         _loc3_ = this.initFromDecodedData(_loc2_);
         if(param1)
         {
            param1.cleanup();
         }
         return _loc3_;
      }
      
      private function initFromDecodedData(param1:Object) : Boolean
      {
         var _loc2_:* = null;
         if(!param1)
         {
            return false;
         }
         _version = param1[Decoder.VERSION_NUMBER];
         if(!this._images)
         {
            this._images = new Object();
         }
         for(_loc2_ in param1[Decoder.IMAGES])
         {
            this._images[_loc2_] = param1[Decoder.IMAGES][_loc2_];
         }
         if(!_lightmaps)
         {
            _lightmaps = new Object();
         }
         for(_loc2_ in param1[Decoder.LIGHTMAPS])
         {
            _lightmaps[_loc2_] = new Lightmap(param1[Decoder.LIGHTMAPS][_loc2_][Decoder.LIGHTMAP] as BitmapData,DEFAULT_DIRECTION,new Point(param1[Decoder.LIGHTMAPS][_loc2_][Decoder.OFFSET_X],param1[Decoder.LIGHTMAPS][_loc2_][Decoder.OFFSET_Y]));
         }
         if(!_sounds)
         {
            _sounds = new Object();
         }
         for(_loc2_ in param1[Decoder.SOUNDS])
         {
            _sounds[_loc2_] = param1[Decoder.SOUNDS][_loc2_];
         }
         if(!this._triggers)
         {
            this._triggers = new Object();
         }
         for(_loc2_ in param1[Decoder.TRIGGERS])
         {
            this._triggers[_loc2_] = param1[Decoder.TRIGGERS][_loc2_];
         }
         touch();
         return true;
      }
   }
}
