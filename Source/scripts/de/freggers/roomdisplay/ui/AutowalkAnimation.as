package de.freggers.roomdisplay.ui
{
   import caurina.transitions.Tweener;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public final class AutowalkAnimation extends Sprite
   {
      
      private static const DURATION_PER_UNIT:Number = 10;
      
      private static const DISABLED_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0.3,0.3,0.3,0.3,0,0,0,0,1,0]);
       
      
      private var _metroPlanGfx:MetroPlanGfx;
      
      private var _background:Shape;
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      private var _sourceContext:String;
      
      private var _targetContext:String;
      
      private var _connectionTweenPoint:Point;
      
      public var onDrawComplete:Function;
      
      public function AutowalkAnimation(param1:Number, param2:Number, param3:String, param4:String)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._sourceContext = param3;
         this._targetContext = param4;
         this.init();
      }
      
      private static function drawConnection(param1:Graphics, param2:Point, param3:Point, param4:int = 16777215, param5:Number = 1, param6:Number = 8, param7:Number = 1, param8:Number = 14) : void
      {
         param1.clear();
         param1.lineStyle(param6,param4,param5,false,LineScaleMode.NONE,CapsStyle.ROUND);
         var _loc9_:Point = param2.subtract(param3);
         var _loc10_:int = _loc9_.length / (param7 + param8);
         var _loc11_:Number = (param3.x - param2.x) / (_loc9_.length / param7);
         var _loc12_:Number = (param3.y - param2.y) / (_loc9_.length / param7);
         var _loc13_:Number = (param3.x - param2.x) / (_loc9_.length / param8);
         var _loc14_:Number = (param3.y - param2.y) / (_loc9_.length / param8);
         var _loc15_:Number = param2.x;
         var _loc16_:Number = param2.y;
         param1.moveTo(_loc15_,_loc16_);
         var _loc17_:int = 0;
         while(_loc17_ < _loc10_)
         {
            param1.moveTo(_loc15_,_loc16_);
            _loc15_ = _loc15_ + _loc11_;
            _loc16_ = _loc16_ + _loc12_;
            param1.lineTo(_loc15_,_loc16_);
            _loc15_ = _loc15_ + _loc13_;
            _loc16_ = _loc16_ + _loc14_;
            _loc17_++;
         }
      }
      
      private function init() : void
      {
         var _loc1_:DisplayObject = null;
         this._connectionTweenPoint = new Point();
         this._metroPlanGfx = new MetroPlanGfx();
         this._metroPlanGfx.close.visible = false;
         this._background = new Shape();
         this._background.filters = [new GlowFilter(0,0.65,20,20,1,10,true)];
         addChild(this._background);
         addChild(this._metroPlanGfx);
         this._metroPlanGfx.background.filters = [DISABLED_FILTER];
         var _loc2_:int = 0;
         while(_loc2_ < this._metroPlanGfx.icons.numChildren)
         {
            _loc1_ = this._metroPlanGfx.icons.getChildAt(_loc2_);
            if(!(_loc1_ == null || this.getContextIcon(this._sourceContext) == _loc1_ || this.getContextIcon(this._targetContext) == _loc1_))
            {
               _loc1_.filters = [DISABLED_FILTER];
            }
            _loc2_++;
         }
         this.layout();
         this.animateConnection();
      }
      
      private function getContextIcon(param1:String) : MovieClip
      {
         if(param1 == null)
         {
            return null;
         }
         return this._metroPlanGfx.icons[param1];
      }
      
      public function handleResize(param1:Number, param2:Number) : void
      {
         this._width = param1;
         this.height = param2;
         this.layout();
      }
      
      private function layout() : void
      {
         this._background.graphics.clear();
         this._background.graphics.beginFill(3947580);
         this._background.graphics.drawRect(0,0,this._width,this._height);
         this._background.graphics.endFill();
         this._metroPlanGfx.x = (this._background.width - this._metroPlanGfx.width) / 2;
         this._metroPlanGfx.y = (this._background.height - this._metroPlanGfx.height) / 2;
      }
      
      private function animateConnection() : void
      {
         var _loc1_:MovieClip = this.getContextIcon(this._sourceContext);
         var _loc2_:MovieClip = this.getContextIcon(this._targetContext);
         if(_loc1_ == null || _loc2_ == null)
         {
            Tweener.addTween(this._connectionTweenPoint,{
               "time":2,
               "onComplete":this.drawComplete
            });
            return;
         }
         var _loc3_:Point = new Point(_loc1_.x,_loc1_.y);
         this._connectionTweenPoint.x = _loc3_.x;
         this._connectionTweenPoint.y = _loc3_.y;
         var _loc4_:Point = new Point(_loc2_.x,_loc2_.y);
         var _loc5_:Point = _loc4_.subtract(_loc3_);
         var _loc6_:Number = _loc5_.length * DURATION_PER_UNIT / 1000;
         Tweener.addTween(this._connectionTweenPoint,{
            "x":_loc4_.x,
            "y":_loc4_.y,
            "time":_loc6_,
            "transition":"linear",
            "onUpdate":drawConnection,
            "onUpdateParams":[this._metroPlanGfx.connections.graphics,_loc3_,this._connectionTweenPoint],
            "onComplete":this.drawComplete
         });
      }
      
      private function drawComplete() : void
      {
         this.onDrawComplete();
      }
      
      private function clearConnectionLayer() : void
      {
         Tweener.removeTweens(this._connectionTweenPoint);
         this._metroPlanGfx.connections.graphics.clear();
      }
   }
}
