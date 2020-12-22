package de.freggers.content
{
   import de.freggers.isostar.IsoEffectConfig;
   import de.freggers.isostar.IsoSpriteEffect;
   import de.freggers.roomlib.util.ResourceManager;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public final class Effects
   {
      
      public static const DEFAULT_EFFECT_LAYER:int = -1;
      
      public static const SYNTHETIC_EFFECT_ID:int = -1;
       
      
      private var _renderLayer:DisplayObjectContainer;
      
      private var _effectMap:Dictionary;
      
      private var _configMap:Dictionary;
      
      private var _initedMap:Dictionary;
      
      public function Effects()
      {
         this._effectMap = new Dictionary();
         this._configMap = new Dictionary(true);
         this._initedMap = new Dictionary(true);
         super();
      }
      
      public function update(param1:int) : void
      {
         var _loc2_:IsoSpriteEffect = null;
         var _loc3_:uint = 0;
         if(this._renderLayer.numChildren > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this._renderLayer.numChildren)
            {
               _loc2_ = this._renderLayer.getChildAt(_loc3_) as IsoSpriteEffect;
               if(_loc2_)
               {
                  _loc2_.update(param1);
                  if(_loc2_.finished)
                  {
                     this.remove(_loc2_);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function get count() : uint
      {
         if(!this._renderLayer)
         {
            return 0;
         }
         return this._renderLayer.numChildren;
      }
      
      public function set renderLayer(param1:DisplayObjectContainer) : void
      {
         if(param1 == this._renderLayer)
         {
            return;
         }
         this._renderLayer = param1;
      }
      
      public function get renderLayer() : DisplayObjectContainer
      {
         return this._renderLayer;
      }
      
      public function add(param1:int, param2:IsoSpriteEffect, param3:IsoEffectConfig, param4:int = -1) : void
      {
         if(this._renderLayer == null || param2 == null || param2.parent == this._renderLayer)
         {
            return;
         }
         this.removeById(param1);
         if(param4 >= this._renderLayer.numChildren)
         {
            param4 = DEFAULT_EFFECT_LAYER;
         }
         if(param4 == DEFAULT_EFFECT_LAYER)
         {
            this._renderLayer.addChild(param2);
         }
         else
         {
            this._renderLayer.addChildAt(param2,param4);
         }
         this._effectMap[param1] = param2;
         this._configMap[param2] = param3;
         this._initedMap[param2] = false;
      }
      
      public function initEffect(param1:int, param2:IIsoSpriteContent) : void
      {
         if(this._effectMap[param1] == null)
         {
            return;
         }
         var _loc3_:IsoSpriteEffect = this._effectMap[param1] as IsoSpriteEffect;
         if(this._configMap[_loc3_] == null || this._initedMap[_loc3_] == true)
         {
            return;
         }
         _loc3_.init(param2,this._configMap[_loc3_] as IsoEffectConfig);
         this._initedMap[_loc3_] = true;
      }
      
      public function startEffect(param1:int) : void
      {
         if(this._effectMap[param1] == null)
         {
            return;
         }
         (this._effectMap[param1] as IsoSpriteEffect).start();
      }
      
      public function initAllEffects(param1:IIsoSpriteContent) : void
      {
         var _loc2_:IsoSpriteEffect = null;
         for each(_loc2_ in this._effectMap)
         {
            if(!(_loc2_ == null || this._initedMap[_loc2_] == true))
            {
               _loc2_.init(param1,this._configMap[_loc2_] as IsoEffectConfig);
               this._initedMap[_loc2_] = true;
            }
         }
      }
      
      public function startAllEffects() : void
      {
         var _loc1_:IsoSpriteEffect = null;
         for each(_loc1_ in this._effectMap)
         {
            if(_loc1_ != null)
            {
               _loc1_.start();
            }
         }
      }
      
      public function removeAndCancelLoading(param1:int, param2:String) : void
      {
         ResourceManager.instance.cancelCallbacksFor(param2);
         this.removeById(param1);
      }
      
      public function removeById(param1:int) : void
      {
         var _loc2_:IsoSpriteEffect = null;
         if(param1 != SYNTHETIC_EFFECT_ID)
         {
            _loc2_ = this._effectMap[param1];
            delete this._effectMap[param1];
            delete this._configMap[_loc2_];
            delete this._initedMap[_loc2_];
            this.remove(_loc2_);
         }
      }
      
      private function remove(param1:IsoSpriteEffect) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         param1.cleanup();
      }
   }
}
