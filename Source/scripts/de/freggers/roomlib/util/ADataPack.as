package de.freggers.roomlib.util
{
   import de.freggers.data.BinaryDecodable;
   import de.freggers.data.Lightmap;
   import de.freggers.decoder.Decoder;
   import flash.media.Sound;
   import flash.utils.getTimer;
   
   public class ADataPack extends BinaryDecodable
   {
       
      
      private var _name:String;
      
      private var _lastAccess:int = -1;
      
      protected var _version:int;
      
      protected var _sounds:Object;
      
      protected var _lightmaps:Object;
      
      public function ADataPack(param1:String)
      {
         super();
         this._name = param1;
         this._sounds = new Object();
         this._lightmaps = new Object();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      protected function touch() : void
      {
         this._lastAccess = getTimer();
      }
      
      function getAge(param1:Number) : int
      {
         return param1 - this._lastAccess;
      }
      
      function increaseAgeBy(param1:int) : void
      {
         this._lastAccess = this._lastAccess - param1;
      }
      
      public function get version() : int
      {
         return this._version;
      }
      
      public function getSoundLabels() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._sounds)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getLightmapLabels() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._lightmaps)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getSound(param1:String) : Sound
      {
         this.touch();
         return this._sounds[param1][Decoder.SOUND_OBJ] as Sound;
      }
      
      public function getLightmap(param1:String) : Lightmap
      {
         this.touch();
         return this._lightmaps[param1];
      }
      
      public function hasLightmap(param1:String) : Boolean
      {
         return this._lightmaps[param1] != null;
      }
      
      public function hasSound(param1:String) : Boolean
      {
         return this._sounds[param1] != null;
      }
   }
}
