package de.freggers.roomdisplay.metroplan
{
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.StyleSheet;
   
   public class AreaSelector extends MapItem
   {
      
      public static const SIZE:uint = 80;
      
      private static const MAINFONTSIZE:uint = 12;
      
      private static const COUNTFONTSIZE:uint = 20;
      
      private static const BORDERSIZE:uint = 3;
      
      private static const FILLMAX:Number = 0.8;
       
      
      public var context:AreaContext;
      
      public var label:String;
      
      public var nusers:uint;
      
      private var _maincolor:uint;
      
      private var _countcolor:uint;
      
      private var _bordercolor:uint;
      
      private var _name:String;
      
      public var id:uint = 0;
      
      private var fill:Shape;
      
      private var idbmd:BitmapData;
      
      private var labelbmd:BitmapData;
      
      private var _playerIcon:Sprite;
      
      public var isCurrent:Boolean = false;
      
      public function AreaSelector(param1:AreaContext, param2:String, param3:String, param4:uint = 999, param5:uint = 15770661, param6:uint = 0, param7:uint = 16777215)
      {
         super();
         this.context = param1;
         this.label = param2;
         this._name = param3;
         this.nusers = param4;
         this._maincolor = param5;
         this._countcolor = param6;
         this._bordercolor = param7;
         this.enabled = true;
         this.mouseChildren = false;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Array = this.label.split(".",2)[0].split("%",2);
         this.id = uint(_loc1_[1]);
         var _loc2_:Sprite = new Sprite();
         var _loc3_:StyleSheet = new StyleSheet();
         _loc3_.setStyle(".foo",{
            "fontSize":MAINFONTSIZE,
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "textAlign":"center",
            "color":"#" + this._bordercolor.toString(16)
         });
         _loc3_.setStyle(".bar",{
            "fontSize":COUNTFONTSIZE,
            "fontWeight":"bold",
            "fontFamily":"Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif",
            "color":"#" + this._bordercolor.toString(16)
         });
         this.labelbmd = TextRenderer.renderToBitmap("<span class=\'foo\' text-align=\'center\'>" + this._name + "</span>",_loc3_,1.5 * SIZE,true,0,false);
         var _loc4_:Bitmap = new Bitmap(this.labelbmd,"auto",true);
         var _loc5_:Sprite = new Sprite();
         _loc5_.graphics.beginFill(2771788);
         _loc5_.graphics.drawRect(0,0,_loc4_.width + 6,_loc4_.height + 6);
         _loc5_.graphics.endFill();
         _loc4_.x = _loc4_.y = 3;
         _loc5_.addChild(_loc4_);
         this.idbmd = TextRenderer.renderToBitmap("<span class=\'bar\'>" + this.nusers + "</span>",_loc3_,SIZE,false,0,true);
         _loc4_ = new Bitmap(this.idbmd,"auto",true);
         var _loc6_:Shape = new Shape();
         _loc6_.graphics.beginFill(255);
         _loc6_.graphics.drawCircle(SIZE / 2,SIZE / 2,SIZE / 2);
         _loc6_.graphics.endFill();
         this.fill = new Shape();
         this.fill.mask = _loc6_;
         _loc2_.addChild(this.fill);
         _loc2_.addChild(_loc6_);
         _loc2_.addChild(_loc5_);
         _loc2_.addChild(_loc4_);
         _loc2_.graphics.beginFill(this._bordercolor);
         _loc2_.graphics.drawCircle(0,0,SIZE / 2 + 4);
         _loc2_.graphics.endFill();
         this.fill.x = _loc6_.x = -SIZE / 2;
         this.fill.y = _loc6_.y = -SIZE / 2;
         _loc5_.x = -_loc5_.width / 2;
         _loc5_.y = _loc6_.x + _loc6_.height - 10;
         _loc4_.x = -_loc4_.width / 2;
         _loc4_.y = -_loc4_.height / 2;
         this.updateFilled();
         gfx = _loc2_;
         this.filters = [new DropShadowFilter(4,90,0,0.5)];
         this._playerIcon = new Sprite();
         addChild(this._playerIcon);
      }
      
      public function set playerIcon(param1:DisplayObject) : void
      {
         this.isCurrent = true;
         this._playerIcon.addChild(param1);
         this._playerIcon.x = SIZE / 2 + 10;
         this._playerIcon.y = SIZE / 2 - 10;
      }
      
      public function get playerIcon() : DisplayObject
      {
         return this._playerIcon.getChildAt(0);
      }
      
      public function updateFilled() : void
      {
         var _loc1_:uint = SIZE * this.fillpercentage;
         this.fill.graphics.clear();
         this.fill.graphics.beginFill(11454137);
         this.fill.graphics.drawRect(0,0,SIZE,SIZE - _loc1_);
         this.fill.graphics.endFill();
         this.fill.graphics.beginFill(16098343);
         this.fill.graphics.drawRect(0,SIZE - _loc1_,SIZE,_loc1_);
         this.fill.graphics.endFill();
      }
      
      private function get fillpercentage() : Number
      {
         if(this.context.nusers == 0)
         {
            return 0;
         }
         var _loc1_:Number = this.nusers * this.context.areaselectors.length / this.context.nusers;
         return FILLMAX * Math.min(_loc1_,1);
      }
      
      override protected function updateHighlight() : void
      {
         if(!_gfx)
         {
            return;
         }
         if(highlight)
         {
            if(!this.isCurrent)
            {
               _gfx.filters = [HIGHLIGHT_FILTER];
            }
         }
         else
         {
            _gfx.filters = null;
         }
      }
      
      override public function cleanup() : void
      {
         if(this.idbmd)
         {
            this.idbmd.dispose();
         }
      }
   }
}
