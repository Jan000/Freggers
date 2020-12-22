package de.freggers.roomlib
{
   import de.freggers.isostar.AIsoFlatThing;
   import de.freggers.isostar.IIsoContainer;
   import de.freggers.isostar.IsoGrid;
   import de.freggers.ui.IGameInteractionProvider;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Exit extends AIsoFlatThing implements IGameInteractionProvider
   {
      
      private static const INTERACTIONS:Vector.<ItemInteraction> = GlobalAction.interactionVector(GlobalAction.USE_EXIT);
      
      public static const EXIT_TYPE_DEFAULT:String = "default";
      
      public static const EXIT_TYPE_SHOP:String = "shop";
      
      public static const EXIT_TYPE_METRO:String = "metro";
      
      public static const EXIT_TYPE_HOME:String = "home";
      
      public static const EXIT_TYPE_BANK:String = "bank";
      
      public static const EXIT_TYPE_HOP:String = "hop";
       
      
      public var wobID:uint;
      
      public var exitLabel:String;
      
      private var points:Array;
      
      private var min:Point;
      
      private var max:Point;
      
      private var dir:int;
      
      private var _highlighted:Boolean;
      
      private var _hitbmd:BitmapData;
      
      private var centroid:Point;
      
      private var _stripeslayer:Sprite;
      
      private var _stripesbmd:BitmapData;
      
      private var _offset:Point;
      
      private var _arrow:Sprite;
      
      private var _exitContent:Sprite;
      
      private var _arrowLocation:Point;
      
      private var _type:String;
      
      private var _handleMouseCallback:Function;
      
      public function Exit(param1:IIsoContainer, param2:Array, param3:int, param4:int, param5:String)
      {
         this._offset = new Point();
         this.min = this.getMin(param2);
         this.max = this.getMax(param2);
         super(param1);
         this.mouseEnabled = true;
         this.mouseChildren = false;
         this.dir = (param4 + 4) % 8;
         this._type = param5;
         switch(param5)
         {
            case EXIT_TYPE_BANK:
               this._arrow = new ExitSymbolBank();
               break;
            case EXIT_TYPE_HOME:
               this._arrow = new ExitSymbolHome();
               break;
            case EXIT_TYPE_METRO:
               this._arrow = new ExitSymbolMetro();
               break;
            case EXIT_TYPE_SHOP:
               this._arrow = new ExitSymbolShop();
               break;
            case EXIT_TYPE_HOP:
               this._arrow = new ExitSymbolHop();
               break;
            default:
               this._type = EXIT_TYPE_DEFAULT;
               this._arrow = new ExitSymbolArrow();
         }
         setIsoPosition(this.min.x,this.min.y,param3);
         this.updateBoundingBox();
         this.points = this.relativePoints(param2,this.min);
         this.centroid = this.computeCentroid();
         this.createContent();
         this.recalc();
         this.addEventListener(Event.ADDED,this.handleAdded);
      }
      
      function handleAdded(param1:Event) : void
      {
         this.recalc();
      }
      
      private function updateBoundingBox() : void
      {
         min_u = this.min.x;
         min_v = this.min.y;
         max_u = this.max.x;
         max_v = this.max.y;
         max_z = min_z = isoZ;
      }
      
      public function set exitScale(param1:Number) : void
      {
         this._exitContent.scaleX = param1;
         this._exitContent.scaleY = param1;
         this._exitContent.x = this._arrowLocation.x * (1 / param1) - this._exitContent.width / 2;
         this._exitContent.y = this._arrowLocation.y * (1 / param1) - this._exitContent.height / 2;
      }
      
      private function createContent() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc7_:Rectangle = null;
         this._exitContent = new Sprite();
         var _loc1_:Sprite = new Sprite();
         var _loc4_:Number = Number.MAX_VALUE;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Stripes = new Stripes();
         this._stripesbmd = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         this._stripeslayer = new Sprite();
         this._stripesbmd.draw(_loc6_);
         var _loc8_:Sprite = new Sprite();
         _loc8_.addChild(this._arrow);
         var _loc9_:Matrix = new Matrix();
         _loc9_.translate(-3,-5);
         _loc9_.rotate(Math.PI / 4);
         _loc9_.scale(1.1,0.55);
         _loc2_ = 0;
         while(_loc2_ < this.points.length)
         {
            if(this.points[_loc2_])
            {
               _loc3_ = IsoGrid.xy(this.points[_loc2_].x,this.points[_loc2_].y,0);
               _loc4_ = Math.min(_loc3_.x,_loc4_);
               _loc5_ = Math.min(_loc3_.y,_loc5_);
            }
            _loc2_++;
         }
         this._offset.x = _loc4_;
         this._offset.y = _loc5_;
         this._arrow.rotation = 45 - 45 * this.dir;
         _loc8_.scaleY = 0.5;
         _loc3_ = IsoGrid.xy(this.centroid.x,this.centroid.y,0);
         _loc3_.x = _loc3_.x - _loc4_;
         _loc3_.y = _loc3_.y - _loc5_;
         _loc8_.x = _loc3_.x;
         _loc8_.y = _loc3_.y;
         _loc8_.alpha = 0.9;
         this._arrowLocation = _loc3_;
         this._exitContent.graphics.beginFill(0,0);
         this._stripeslayer.graphics.beginBitmapFill(this._stripesbmd,_loc9_,true,true);
         _loc2_ = 0;
         while(_loc2_ < this.points.length)
         {
            if(this.points[_loc2_])
            {
               _loc3_ = IsoGrid.xy(this.points[_loc2_].x,this.points[_loc2_].y,0);
               _loc3_.x = _loc3_.x - _loc4_;
               _loc3_.y = _loc3_.y - _loc5_;
               if(_loc2_ == 0)
               {
                  this._stripeslayer.graphics.moveTo(_loc3_.x,_loc3_.y);
                  this._exitContent.graphics.moveTo(_loc3_.x,_loc3_.y);
               }
               else
               {
                  this._stripeslayer.graphics.lineTo(_loc3_.x,_loc3_.y);
                  this._exitContent.graphics.lineTo(_loc3_.x,_loc3_.y);
               }
            }
            _loc2_++;
         }
         this._stripeslayer.graphics.endFill();
         this._stripeslayer.visible = this._highlighted;
         this._exitContent.graphics.endFill();
         this._exitContent.addChild(this._stripeslayer);
         this._exitContent.addChild(_loc8_);
         _loc1_.addChild(this._exitContent);
         _loc1_.mouseChildren = _loc1_.mouseEnabled = false;
         this.content = _loc1_;
      }
      
      public function get stripeslayer() : Sprite
      {
         return this._stripeslayer;
      }
      
      private function relativePoints(param1:Array, param2:Point) : Array
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:Array = new Array(param1.length / 2);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_] - this.min.x;
            _loc6_ = param1[_loc4_ + 1] - this.min.y;
            _loc3_[_loc4_ / 2] = new Point(_loc5_,_loc6_);
            _loc4_ = _loc4_ + 2;
         }
         return _loc3_;
      }
      
      private function getMin(param1:Array) : Point
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Point = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = param1[_loc3_ + 1];
            _loc2_.x = Math.min(_loc4_,_loc2_.x);
            _loc2_.y = Math.min(_loc5_,_loc2_.y);
            _loc3_ = _loc3_ + 2;
         }
         return _loc2_;
      }
      
      private function getMax(param1:Array) : Point
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Point = new Point(Number.MIN_VALUE,Number.MIN_VALUE);
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = param1[_loc3_ + 1];
            _loc2_.x = Math.max(_loc4_,_loc2_.x);
            _loc2_.y = Math.max(_loc5_,_loc2_.y);
            _loc3_ = _loc3_ + 2;
         }
         return _loc2_;
      }
      
      override protected function recalc() : void
      {
         var _loc1_:Point = IsoGrid.xy(isoU,isoV,isoZ);
         var _loc2_:int = (this.max.y - this.min.y - 1) * IsoGrid.tile_width / (IsoGrid.upt * 2);
         x = _loc1_.x + this._offset.x;
         y = _loc1_.y + this._offset.y;
         super.recalc();
      }
      
      override public function get displayindex() : int
      {
         return -1;
      }
      
      public function get highLight() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highLight(param1:Boolean) : void
      {
         this._highlighted = param1;
         this._stripeslayer.visible = this._highlighted;
      }
      
      public function get interactions() : Vector.<ItemInteraction>
      {
         return INTERACTIONS;
      }
      
      public function get isOldSkool() : Boolean
      {
         return false;
      }
      
      public function get wobId() : int
      {
         return 0;
      }
      
      public function get isThrowTarget() : Boolean
      {
         return false;
      }
      
      public function get isTrash() : Boolean
      {
         return false;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._hitbmd)
         {
            this._hitbmd.dispose();
            this._hitbmd = null;
         }
         if(this._stripesbmd)
         {
            this._stripesbmd.dispose();
            this._stripesbmd = null;
         }
      }
      
      private function computeArea() : Number
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(!this.points)
         {
            return 0;
         }
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.points.length)
         {
            _loc3_ = this.points[_loc2_] as Point;
            if(_loc2_ == this.points.length - 1)
            {
               _loc4_ = this.points[0] as Point;
            }
            else
            {
               _loc4_ = this.points[_loc2_ + 1] as Point;
            }
            _loc1_ = _loc1_ + (_loc3_.x * _loc4_.y - _loc4_.x * _loc3_.y);
            _loc2_++;
         }
         return _loc1_ / 2;
      }
      
      private function computeCentroid() : Point
      {
         var _loc3_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         if(!this.points)
         {
            return null;
         }
         var _loc1_:Number = this.computeArea();
         var _loc2_:Point = new Point(0,0);
         var _loc4_:int = 0;
         while(_loc4_ < this.points.length)
         {
            _loc5_ = this.points[_loc4_] as Point;
            if(_loc4_ == this.points.length - 1)
            {
               _loc6_ = this.points[0] as Point;
            }
            else
            {
               _loc6_ = this.points[_loc4_ + 1] as Point;
            }
            _loc3_ = _loc5_.x * _loc6_.y - _loc6_.x * _loc5_.y;
            _loc2_.x = _loc2_.x + (_loc5_.x + _loc6_.x) * _loc3_;
            _loc2_.y = _loc2_.y + (_loc5_.y + _loc6_.y) * _loc3_;
            _loc4_++;
         }
         _loc2_.x = _loc2_.x / (6 * _loc1_);
         _loc2_.y = _loc2_.y / (6 * _loc1_);
         return _loc2_;
      }
   }
}
