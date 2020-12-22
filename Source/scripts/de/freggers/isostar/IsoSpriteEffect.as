package de.freggers.isostar
{
   import de.freggers.content.IIsoSpriteContent;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class IsoSpriteEffect extends Sprite
   {
      
      public static const LOOP_TYPE_NONE:uint = 0;
      
      public static const LOOP_TYPE_NORMAL:uint = 1;
      
      public static const LOOP_TYPE_RANDOM:uint = 2;
       
      
      protected var _started:int = 0;
      
      protected var _duration:int = 0;
      
      private var _lastupdate:int = 0;
      
      private var _updateinterval:int = 0;
      
      private var _onComplete:Function;
      
      private var _userData;
      
      protected var _content:IIsoSpriteContent;
      
      private var _inited:Boolean = false;
      
      protected var _loopEveryMax:uint = 0;
      
      protected var _loopEveryMin:uint = 0;
      
      protected var _loopType:uint = 0;
      
      protected var _startAfter:int = -1;
      
      public var finished:Boolean = false;
      
      public function IsoSpriteEffect()
      {
         super();
      }
      
      public function init(param1:IIsoSpriteContent, param2:IsoEffectConfig) : void
      {
         this._onComplete = param2.onCompleteCallback;
         this._userData = param2.userData;
         this._updateinterval = param2.updateInterval;
         this._duration = param2.duration;
         this._content = param1;
         this.setLoop(param2.loopMode,param2.loopIntervalMax,param2.loopIntervalMin);
         this._inited = true;
      }
      
      public final function update(param1:int) : void
      {
         var time:int = param1;
         if(time - this._lastupdate < this._updateinterval || this.finished || !this._inited)
         {
            return;
         }
         if(this._startAfter >= 0)
         {
            if(time - this._lastupdate > this._startAfter)
            {
               this._lastupdate = 0;
               this._startAfter = -1;
               this.visible = true;
            }
            return;
         }
         if(this._lastupdate == 0)
         {
            this._started = this._lastupdate = time;
         }
         if(this._duration > 0 && this._lastupdate - this._started > this._duration)
         {
            if(this._loopType == LOOP_TYPE_NONE)
            {
               this._startAfter = -1;
               this.finished = true;
            }
            else if(this._loopType == LOOP_TYPE_RANDOM)
            {
               this._startAfter = this._loopEveryMin + Math.random() * (this._loopEveryMax - this._loopEveryMin);
            }
            else if(this._loopType == LOOP_TYPE_NORMAL)
            {
               this._startAfter = this._loopEveryMax;
            }
            if(this._startAfter > 0)
            {
               this.visible = false;
            }
            this.updateHook(this._duration);
            this.reset();
            if(this._onComplete != null)
            {
               try
               {
                  this._onComplete(this);
               }
               catch(e:ArgumentError)
               {
               }
            }
            if(this.finished)
            {
               this.cleanup();
            }
         }
         else
         {
            this.updateHook(this._lastupdate - this._started);
         }
         this._lastupdate = time;
      }
      
      public function get userData() : *
      {
         return this._userData;
      }
      
      protected function updateHook(param1:int) : void
      {
      }
      
      public function cleanup() : void
      {
         this._onComplete = null;
         this._userData = null;
         this._content = null;
      }
      
      public function start() : void
      {
         this.startAfter(0);
      }
      
      public function startAfter(param1:uint) : void
      {
         this._startAfter = param1;
         this.visible = this._startAfter == 0;
         this._lastupdate = 0;
      }
      
      protected function getMinimumBounds() : Rectangle
      {
         return this.getDisplayObjectBounds();
      }
      
      protected final function getDisplayObjectBounds() : Rectangle
      {
         if(this._content == null)
         {
            return null;
         }
         return this._content.displayObject.getBounds(this._content.effects.renderLayer);
      }
      
      public function setLoop(param1:uint, param2:uint, param3:uint = 0) : void
      {
         this._loopType = param1;
         this._loopEveryMin = param3;
         this._loopEveryMax = param2;
      }
      
      public function reset() : void
      {
      }
   }
}
