package de.freggers.roomlib
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class IconBox extends Sprite
   {
      
      public static const ICON_COMPOSING:String = "composing";
      
      public static const ICON_AWAY:String = "away";
      
      public static const ICON_QUICK:String = "quick";
      
      public static const ICON_PRANKED:String = "pranked";
      
      public static const ICON_NOSOUND:String = "nosound";
      
      public static const ICON_PLAYING:String = "playing";
      
      public static const ICON_ADMIN:String = "admin";
      
      public static const ICON_SERVEROP:String = "serverop";
      
      private static const ICONSIZE:int = 14;
       
      
      private var icons:Object;
      
      private var iconorder:Array;
      
      private var iconlayer:Sprite;
      
      private var cols:int;
      
      public function IconBox(param1:int = 3)
      {
         super();
         this.iconlayer = new Sprite();
         this.icons = new Object();
         this.iconorder = new Array();
         addChild(this.iconlayer);
         this.cols = param1;
      }
      
      public function addIcon(param1:String, param2:DisplayObject) : void
      {
         if(this.icons[param1])
         {
            return;
         }
         if(param2 is MovieClip)
         {
            (param2 as MovieClip).stop();
         }
         this.icons[param1] = param2;
         this.iconorder.push(param1);
      }
      
      public function removeIcon(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < this.iconorder.length)
         {
            _loc3_ = this.iconorder[_loc4_] as String;
            if(_loc3_)
            {
               if(_loc3_ == param1 && !_loc2_)
               {
                  _loc2_ = true;
               }
               if(_loc2_ && _loc4_ < this.iconorder.length - 1)
               {
                  this.iconorder[_loc4_] = this.iconorder[_loc4_ + 1];
               }
            }
            _loc4_++;
         }
         if(this.iconlayer.contains(this.icons[param1] as DisplayObject))
         {
            this.iconlayer.removeChild(this.icons[param1] as DisplayObject);
         }
         this.iconorder.length--;
         delete this.icons[param1];
         this.repaint();
      }
      
      public function showIcon(param1:String) : void
      {
         if(!this.icons[param1])
         {
            return;
         }
         this.iconlayer.addChild(this.icons[param1] as DisplayObject);
         this.repaint();
      }
      
      public function hideIcon(param1:String) : void
      {
         if(!this.icons[param1])
         {
            return;
         }
         if(this.icons[param1] is MovieClip)
         {
            (this.icons[param1] as MovieClip).stop();
         }
         if(this.iconlayer.contains(this.icons[param1] as DisplayObject))
         {
            this.iconlayer.removeChild(this.icons[param1] as DisplayObject);
         }
         this.repaint();
      }
      
      public function iconIsVisible(param1:String) : Boolean
      {
         if(!this.icons[param1])
         {
            return false;
         }
         return this.iconlayer.contains(this.icons[param1] as DisplayObject);
      }
      
      public function playIcon(param1:String) : void
      {
         if(!this.icons[param1] || !(this.icons[param1] is MovieClip))
         {
            return;
         }
         (this.icons[param1] as MovieClip).play();
      }
      
      public function pauseIcon(param1:String) : void
      {
         if(!this.icons[param1] || !(this.icons[param1] is MovieClip))
         {
            return;
         }
         (this.icons[param1] as MovieClip).stop();
      }
      
      public function stopIcon(param1:String) : void
      {
         if(!this.icons[param1] || !(this.icons[param1] is MovieClip))
         {
            return;
         }
         (this.icons[param1] as MovieClip).gotoAndStop(0);
      }
      
      public function getIcon(param1:String) : DisplayObject
      {
         return this.icons[param1];
      }
      
      public function getLabels() : Array
      {
         return this.iconorder.slice(0,this.iconorder.length);
      }
      
      private function repaint() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc5_ = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this.iconorder.length)
         {
            _loc1_ = this.iconorder[_loc6_] as String;
            if(_loc1_)
            {
               _loc2_ = this.icons[_loc1_] as DisplayObject;
               if(!(!_loc2_ || !this.iconlayer.contains(_loc2_)))
               {
                  _loc2_.x = _loc3_ + ICONSIZE / 2;
                  _loc2_.y = _loc4_ + ICONSIZE / 2;
                  _loc3_ = _loc3_ + ICONSIZE;
                  if((_loc5_ + 1) % this.cols == 0 && _loc5_ != 0)
                  {
                     _loc4_ = _loc4_ + ICONSIZE;
                     _loc3_ = 0;
                  }
                  _loc5_++;
               }
            }
            _loc6_++;
         }
         if(_loc5_ <= this.cols)
         {
            this.iconlayer.x = -_loc5_ * ICONSIZE / 2;
            this.iconlayer.y = -ICONSIZE;
         }
         else
         {
            this.iconlayer.x = -this.cols * ICONSIZE / 2;
            this.iconlayer.y = -Math.ceil(_loc5_ / this.cols) * ICONSIZE;
         }
      }
      
      override public function get height() : Number
      {
         return this.iconlayer.numChildren > 0?Number(ICONSIZE):Number(0);
      }
   }
}
