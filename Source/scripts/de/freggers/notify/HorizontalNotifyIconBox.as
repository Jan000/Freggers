package de.freggers.notify
{
   import caurina.transitions.Tweener;
   import de.schulterklopfer.interaction.manager.InteractionManager;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public final class HorizontalNotifyIconBox extends Sprite
   {
      
      private static var DISABLE_FILTER:ColorMatrixFilter = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,1,0]);
       
      
      private var _hgap:int;
      
      private var _height:int;
      
      private var _hidden:Dictionary;
      
      private var _icons:Vector.<InteractiveObject>;
      
      private var _iconPositions:Vector.<Point>;
      
      public function HorizontalNotifyIconBox(param1:int = 40, param2:int = 5)
      {
         super();
         this._hgap = param2;
         this._height = param1;
         this.mouseEnabled = false;
         this.init();
      }
      
      private function init() : void
      {
         this._icons = new Vector.<InteractiveObject>();
         this._iconPositions = new Vector.<Point>();
         this._hidden = new Dictionary(true);
      }
      
      public function hide(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         if(this._icons.indexOf(param1) < 0)
         {
            return;
         }
         param1.visible = false;
         this._hidden[param1] = true;
         this.computePositions();
         var _loc3_:int = this._icons.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Tweener.addTween(this._icons[_loc2_],{
               "x":this._iconPositions[_loc2_].x,
               "y":this._iconPositions[_loc2_].y,
               "time":0.5,
               "transition":"easeOutBounce"
            });
            _loc2_++;
         }
      }
      
      public function show(param1:InteractiveObject) : void
      {
         var _loc2_:int = 0;
         param1.alpha = 0;
         param1.visible = true;
         delete this._hidden[param1];
         this.computePositions();
         var _loc3_:int = this._icons.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            Tweener.addTween(this._icons[_loc2_],{
               "x":this._iconPositions[_loc2_].x,
               "y":this._iconPositions[_loc2_].y,
               "time":0.5,
               "transition":"easeOutBack"
            });
            _loc2_++;
         }
         Tweener.addTween(param1,{
            "alpha":1,
            "time":0.5
         });
      }
      
      public function disable(param1:InteractiveObject) : void
      {
         InteractionManager.disableMouseFor(param1);
         param1.filters = [DISABLE_FILTER];
      }
      
      public function enable(param1:InteractiveObject) : void
      {
         InteractionManager.enableMouseFor(param1);
         param1.filters = null;
      }
      
      public function disableAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._icons.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.disable(this._icons[_loc1_]);
            _loc1_++;
         }
      }
      
      public function enableAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._icons.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.enable(this._icons[_loc1_]);
            _loc1_++;
         }
      }
      
      public function add(param1:InteractiveObject, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:int = this._icons.length;
         this._icons.push(param1);
         this._iconPositions.push(new Point());
         this.computePositionForIndex(_loc4_);
         this._icons[_loc4_].x = this._iconPositions[_loc4_].x;
         this._icons[_loc4_].y = this._iconPositions[_loc4_].y;
         if(param3)
         {
            param1.visible = false;
            this._hidden[param1] = true;
         }
         if(param2)
         {
            this.disable(param1);
         }
         addChild(param1);
      }
      
      public function remove(param1:InteractiveObject) : void
      {
         var _loc2_:int = this._icons.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         param1.parent.removeChild(param1);
         this._icons.splice(_loc2_,1);
         this._iconPositions.splice(_loc2_,1);
         if(_loc2_ < this._icons.length)
         {
            this.computePositions();
         }
         delete this._hidden[param1];
      }
      
      public function removeAll() : void
      {
         var _loc1_:int = 0;
         var _loc3_:InteractiveObject = null;
         var _loc2_:int = this._icons.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._icons[_loc1_];
            _loc3_.parent.removeChild(_loc3_);
            delete this._hidden[_loc3_];
            _loc1_++;
         }
         this._icons.length = this._iconPositions.length = 0;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      private function computePositionForIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Rectangle = null;
         var _loc5_:InteractiveObject = null;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ <= param1)
         {
            _loc5_ = this._icons[_loc2_];
            if(!this._hidden[_loc5_])
            {
               _loc3_ = _loc5_.getBounds(null);
               _loc4_ = _loc4_ - _loc3_.x;
               if(_loc2_ < param1)
               {
                  _loc4_ = _loc4_ + (_loc3_.x + _loc3_.width + this._hgap);
               }
            }
            _loc2_++;
         }
         this._iconPositions[param1].x = _loc4_;
         this._iconPositions[param1].y = -_loc3_.y + (this._height - _loc3_.height) / 2;
      }
      
      private function computePositions() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Rectangle = null;
         var _loc5_:InteractiveObject = null;
         var _loc2_:int = this._icons.length;
         var _loc4_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._icons[_loc1_];
            if(!this._hidden[_loc5_])
            {
               _loc3_ = _loc5_.getBounds(null);
               _loc4_ = _loc4_ - _loc3_.x;
               this._iconPositions[_loc1_].x = _loc4_;
               this._iconPositions[_loc1_].y = -_loc3_.y + (this._height - _loc3_.height) / 2;
               _loc4_ = _loc4_ + (_loc3_.x + _loc3_.width + this._hgap);
            }
            _loc1_++;
         }
      }
   }
}
