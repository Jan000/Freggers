package de.freggers.roomlib
{
   import de.freggers.data.Lightmap;
   import de.freggers.isocomp.AIsoComponent;
   import de.freggers.roomlib.util.ADataPack;
   import de.freggers.roomlib.util.DataPackContainer;
   import de.freggers.roomlib.util.IsoObjectDataPack;
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   
   class IsoObjectMedia implements DataPackContainer
   {
       
      
      public var onDataPackAdded:Function;
      
      public var onDefaultsAvailable:Function;
      
      private var dataPacks:Object;
      
      private var animationNames:Object;
      
      private var soundLabels:Object;
      
      private var lightmapLabels:Object;
      
      private var _defaultDataPack:IsoObjectDataPack;
      
      function IsoObjectMedia()
      {
         super();
         this.dataPacks = new Object();
         this.animationNames = new Object();
         this.soundLabels = new Object();
         this.lightmapLabels = new Object();
      }
      
      public function cleanup() : void
      {
         this.onDataPackAdded = null;
         this.onDefaultsAvailable = null;
         this._defaultDataPack = null;
      }
      
      public function hasDataPack(param1:String) : Boolean
      {
         return this.dataPacks[param1] != null;
      }
      
      public function hasDefaultDatapack() : Boolean
      {
         return this._defaultDataPack != null;
      }
      
      public function getDataPacks() : Array
      {
         var _loc2_:ADataPack = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.dataPacks)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function addDataPack(param1:ADataPack) : void
      {
         var label:String = null;
         var labels:Array = null;
         var pack:ADataPack = param1;
         this._removeDataPack(pack,true);
         var defaultsChanged:Boolean = false;
         if(pack is IsoObjectDataPack && !this._defaultDataPack)
         {
            this._defaultDataPack = pack as IsoObjectDataPack;
            defaultsChanged = true;
         }
         this.dataPacks[pack.name] = pack;
         labels = pack.getSoundLabels();
         for each(label in labels)
         {
            this.soundLabels[label] = pack;
         }
         labels = pack.getLightmapLabels();
         for each(label in labels)
         {
            this.lightmapLabels[label] = pack;
         }
         if(pack is IsoObjectDataPack)
         {
            labels = (pack as IsoObjectDataPack).getAnimationNames();
            for each(label in labels)
            {
               this.animationNames[label] = pack;
            }
         }
         if(defaultsChanged && this.onDefaultsAvailable != null)
         {
            try
            {
               this.onDefaultsAvailable(this);
            }
            catch(err:ArgumentError)
            {
            }
         }
         if(this.onDataPackAdded != null)
         {
            try
            {
               this.onDataPackAdded(pack);
               return;
            }
            catch(err:ArgumentError)
            {
               return;
            }
         }
      }
      
      public function removeDataPack(param1:ADataPack) : void
      {
         this._removeDataPack(param1,false);
      }
      
      private function _removeDataPack(param1:ADataPack, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         if(!this.dataPacks[param1.name])
         {
            return;
         }
         if(this._defaultDataPack != null && param1.name == this._defaultDataPack.name)
         {
            if(!param2)
            {
               return;
            }
            this._defaultDataPack = null;
         }
         delete this.dataPacks[param1.name];
         _loc4_ = param1.getSoundLabels();
         for each(_loc3_ in _loc4_)
         {
            delete this.soundLabels[_loc3_];
         }
         _loc4_ = param1.getLightmapLabels();
         for each(_loc3_ in _loc4_)
         {
            delete this.lightmapLabels[_loc3_];
         }
         if(param1 is IsoObjectDataPack)
         {
            _loc4_ = (param1 as IsoObjectDataPack).getAnimationNames();
            for each(_loc3_ in _loc4_)
            {
               delete this.animationNames[_loc3_];
            }
         }
      }
      
      public function getSound(param1:String) : Sound
      {
         if(!this.soundLabels[param1])
         {
            return null;
         }
         return (this.soundLabels[param1] as ADataPack).getSound(param1);
      }
      
      public function hasFrame(param1:String, param2:uint, param3:uint) : Boolean
      {
         if(!this.animationNames[param1])
         {
            return false;
         }
         return (this.animationNames[param1] as IsoObjectDataPack).hasFrame(param1,param2,param3);
      }
      
      public function getFrame(param1:String, param2:uint, param3:uint) : ICroppedBitmapDataContainer
      {
         if(!this.animationNames[param1])
         {
            return null;
         }
         return (this.animationNames[param1] as IsoObjectDataPack).getFrame(param1,param2,param3);
      }
      
      public function getMask(param1:String, param2:uint) : ICroppedBitmapDataContainer
      {
         if(!this.animationNames[param1])
         {
            return null;
         }
         return (this.animationNames[param1] as IsoObjectDataPack).getMask(param1,param2);
      }
      
      public function getLightmap(param1:String) : Lightmap
      {
         if(!this.lightmapLabels[param1])
         {
            return null;
         }
         return (this.lightmapLabels[param1] as ADataPack).getLightmap(param1);
      }
      
      public function getFrameCount(param1:String, param2:uint) : int
      {
         if(!this.animationNames[param1])
         {
            return -1;
         }
         return (this.animationNames[param1] as IsoObjectDataPack).getFrameCount(param1,param2);
      }
      
      public function getGrip(param1:String, param2:uint) : BitmapData
      {
         if(!this.animationNames[param1])
         {
            return null;
         }
         return (this.animationNames[param1] as IsoObjectDataPack).getGrip(param1,param2);
      }
      
      public function hasAnimation(param1:String) : Boolean
      {
         return this.animationNames[param1] != null;
      }
      
      public function hasLightmap(param1:String) : Boolean
      {
         return this.lightmapLabels[param1] != null;
      }
      
      public function hasComponent(param1:String, param2:uint) : Boolean
      {
         if(!this._defaultDataPack)
         {
            return false;
         }
         return this._defaultDataPack.hasComponent(param1,param2);
      }
      
      public function getComponentBounds(param1:String, param2:uint) : Rectangle
      {
         if(!this._defaultDataPack)
         {
            return null;
         }
         return this._defaultDataPack.getComponentBounds(param1,param2);
      }
      
      public function getComponent() : AIsoComponent
      {
         if(!this._defaultDataPack)
         {
            return null;
         }
         return this._defaultDataPack.component;
      }
      
      public function get defaultFrame() : int
      {
         if(!this._defaultDataPack)
         {
            return -1;
         }
         return this._defaultDataPack.defaultFrame;
      }
      
      public function get defaultAnimation() : String
      {
         if(!this._defaultDataPack)
         {
            return null;
         }
         return this._defaultDataPack.defaultAnimation;
      }
      
      public function get defaultDirection() : int
      {
         if(!this._defaultDataPack)
         {
            return -1;
         }
         return this._defaultDataPack.defaultDirection;
      }
      
      public function get topHeight() : int
      {
         return this._defaultDataPack.topHeight;
      }
      
      public function get totalHeight() : int
      {
         return this._defaultDataPack.totalHeight;
      }
      
      public function get version() : int
      {
         if(!this._defaultDataPack)
         {
            return -1;
         }
         return this._defaultDataPack.version;
      }
      
      public function removeDataPacks(param1:Boolean = false) : void
      {
         var _loc2_:ADataPack = null;
         for each(_loc2_ in this.dataPacks)
         {
            if(!(param1 && _loc2_ == this._defaultDataPack))
            {
               this.removeDataPack(_loc2_);
            }
         }
      }
      
      public function get dataPackNames() : Array
      {
         var _loc2_:ADataPack = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.dataPacks)
         {
            _loc1_.push(_loc2_.name);
         }
         return _loc1_;
      }
      
      public function merge(param1:IsoObjectMedia) : void
      {
         var _loc2_:ADataPack = null;
         for each(_loc2_ in param1.dataPacks)
         {
            this.addDataPack(_loc2_);
         }
      }
   }
}
