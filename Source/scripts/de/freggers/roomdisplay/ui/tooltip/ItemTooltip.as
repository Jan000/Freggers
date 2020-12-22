package de.freggers.roomdisplay.ui.tooltip
{
   import caurina.transitions.Tweener;
   import de.freggers.property.Property;
   import de.freggers.roomdisplay.FormattedMessage;
   import de.freggers.roomlib.IsoItem;
   import de.freggers.util.TextRenderer;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemTooltip extends ATooltip
   {
      
      private static const MIN_STICKY_WIDTH:Number = 16;
      
      private static const MIN_STICKY_HEIGHT:Number = 16;
       
      
      private var _item:IsoItem;
      
      private var _bubbleSize:Point;
      
      private var _bubble:Sprite;
      
      private var _stickyNote:Sprite;
      
      public function ItemTooltip(param1:IsoItem)
      {
         this._bubbleSize = new Point();
         super();
         this._item = param1;
         visible = false;
      }
      
      override public function show() : void
      {
         visible = true;
      }
      
      override public function hide() : void
      {
         visible = false;
      }
      
      override public function get isShowing() : Boolean
      {
         return visible;
      }
      
      override public function createContents() : void
      {
         var _loc2_:FormattedMessage = null;
         var _loc3_:Bitmap = null;
         var _loc8_:IconContainer = null;
         var _loc9_:TextContainer = null;
         var _loc13_:Property = null;
         var _loc14_:DisplayObject = null;
         var _loc15_:Bitmap = null;
         var _loc1_:int = MARGIN_TOP;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         this._bubble = new Sprite();
         addChild(this._bubble);
         var _loc6_:Shape = new Shape();
         this._bubble.addChild(_loc6_);
         _loc2_ = new FormattedMessage("{0}",[this._item.name],[FormattedMessage.STYLE_BOLD]);
         var _loc7_:* = "<p align=\'center\'>" + _loc2_.toString() + "<p>";
         _loc3_ = new Bitmap(TextRenderer.renderToBitmap(_loc7_,_loc2_.styleSheet,MAX_WIDTH,true),PixelSnapping.AUTO,true);
         _loc3_.y = _loc1_;
         _loc3_.alpha = 0.7;
         _loc5_ = _loc3_.width;
         _loc4_ = _loc3_.height;
         _loc1_ = _loc1_ + (_loc3_.height + SPACING);
         this._bubble.addChild(_loc3_);
         var _loc10_:Array = this._item.properties;
         if(_loc10_.length > 0)
         {
            _loc10_.sortOn(["priority","name"],[Array.NUMERIC,0]);
            _loc9_ = new TextContainer();
            _loc8_ = new IconContainer();
            for each(_loc13_ in _loc10_)
            {
               switch(_loc13_.type)
               {
                  case Property.TYPE_TOOLTIP_TEXT:
                     _loc9_.addLine(_loc13_.value,MAX_WIDTH);
                     continue;
                  default:
                     continue;
               }
            }
            if(_loc9_.lineCount > 0)
            {
               this._bubble.addChild(_loc9_);
               _loc5_ = Math.max(_loc5_,_loc9_.width);
               _loc4_ = _loc4_ + (_loc9_.height + SPACING);
            }
            else
            {
               _loc9_ = null;
            }
            if(_loc8_.iconCount > 0)
            {
               this._bubble.addChild(_loc8_);
               _loc5_ = Math.max(_loc5_,_loc8_.width);
               _loc4_ = _loc4_ + (_loc8_.height + SPACING);
            }
            else
            {
               _loc8_ = null;
            }
         }
         var _loc11_:Number = _loc5_ + MARGIN_LEFT + MARGIN_RIGHT;
         var _loc12_:Number = _loc4_ + MARGIN_TOP + MARGIN_BOTTOM;
         _loc6_.graphics.clear();
         _loc6_.graphics.beginFill(16777215,0.7);
         _loc6_.graphics.drawRoundRect(-_loc11_ / 2,0,_loc11_,_loc12_,8,8);
         _loc6_.graphics.endFill();
         this._bubbleSize.x = _loc6_.width;
         this._bubbleSize.y = _loc6_.height;
         _loc1_ = 0;
         if(_loc3_)
         {
            _loc3_.x = (_loc5_ - _loc3_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            _loc1_ = _loc1_ + (_loc3_.y + _loc3_.height + SPACING);
         }
         if(_loc9_ != null)
         {
            _loc9_.x = (_loc5_ - _loc9_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            _loc9_.y = _loc1_;
            _loc1_ = _loc1_ + (_loc9_.height + SPACING);
         }
         if(_loc8_ != null)
         {
            _loc8_.x = (_loc5_ - _loc8_.width) / 2 + MARGIN_LEFT - this._bubbleSize.x / 2;
            _loc8_.y = _loc1_;
            _loc1_ = _loc1_ + (_loc8_.height + SPACING);
         }
         this._bubble.scaleX = 0;
         this._bubble.scaleY = 0;
         Tweener.addTween(this._bubble,{
            "scaleX":1,
            "scaleY":1,
            "time":0.35,
            "transition":"easeOutBack"
         });
         if(this._item.nstickies > 0)
         {
            this._stickyNote = new Sprite();
            _loc14_ = new NStickyBg();
            this._stickyNote.addChild(_loc14_);
            _loc2_ = new FormattedMessage("{0}",[this._item.nstickies]);
            _loc15_ = new Bitmap(TextRenderer.renderToBitmap(_loc2_.toString(),_loc2_.styleSheet,MAX_WIDTH),PixelSnapping.AUTO,true);
            this._stickyNote.addChild(_loc15_);
            _loc14_.width = Math.max(_loc15_.width + 4,MIN_STICKY_WIDTH);
            _loc14_.height = Math.max(_loc15_.height + 4,MIN_STICKY_HEIGHT);
            _loc15_.x = (_loc14_.width - _loc15_.width) / 2;
            _loc15_.y = (_loc14_.height - _loc15_.height) / 2;
            addChild(this._stickyNote);
         }
      }
      
      override public function updatePosition() : void
      {
         var _loc1_:Rectangle = null;
         if(!this._item.isoobj.sprite.isAdded || this._bubble == null && this._stickyNote == null)
         {
            return;
         }
         _loc1_ = this._item.isoobj.sprite.getContentDisplayObjectBounds();
         _loc1_.width = _loc1_.width * (this._item.isoobj.sprite.isoparent as Sprite).scaleX;
         _loc1_.height = _loc1_.height * (this._item.isoobj.sprite.isoparent as Sprite).scaleY;
         var _loc2_:Point = this._item.isoobj.sprite.parent.localToGlobal(_loc1_.topLeft);
         if(this._bubble != null)
         {
            this._bubble.x = _loc2_.x + _loc1_.width / 2;
            this._bubble.y = _loc2_.y - 5 - this._bubbleSize.y;
         }
         if(this._stickyNote != null)
         {
            this._stickyNote.x = _loc2_.x + (_loc1_.width - this._stickyNote.width) / 2;
            this._stickyNote.y = _loc2_.y + (_loc1_.height - this._stickyNote.height) / 2;
         }
      }
      
      override public function cleanup() : void
      {
         this._item = null;
      }
      
      override public function get showDelay() : int
      {
         return 350;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Sprite;

class IconContainer extends Sprite
{
   
   private static const ICON_SPACING:int = 4;
   
   private static const ICON_SIZE:int = 25;
    
   
   private var _iconCount:int = 0;
   
   function IconContainer()
   {
      super();
   }
   
   public function addIcon(param1:DisplayObject) : void
   {
      var _loc2_:Number = ICON_SIZE / param1.width;
      var _loc3_:Number = ICON_SIZE / param1.height;
      if(_loc2_ > _loc3_)
      {
         param1.width = param1.width * _loc3_;
         param1.height = param1.height * _loc3_;
      }
      else
      {
         param1.width = param1.width * _loc2_;
         param1.height = param1.height * _loc2_;
      }
      param1.x = this._iconCount * (ICON_SIZE + ICON_SPACING);
      addChild(param1);
      this._iconCount++;
   }
   
   public function get iconCount() : int
   {
      return this._iconCount;
   }
}

import de.freggers.roomdisplay.FormattedMessage;
import de.freggers.roomlib.util.StyleSheetBuilder;
import de.freggers.util.TextRenderer;
import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.text.StyleSheet;

class TextContainer extends Sprite
{
   
   private static const TEXT_STYLE:StyleSheet = new StyleSheetBuilder(".line").add("fontSize",13).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("fontWeight","bold").build();
    
   
   private var _lines:Array;
   
   private var _yOffset:Number = 0;
   
   private var _width:Number = 0;
   
   function TextContainer()
   {
      this._lines = new Array();
      super();
   }
   
   public function addLine(param1:String, param2:Number) : void
   {
      var _loc3_:FormattedMessage = new FormattedMessage("{0}",[param1],[TEXT_STYLE]);
      var _loc4_:* = "<p align=\'center\'>" + _loc3_.toString() + "<p>";
      var _loc5_:Bitmap = new Bitmap(TextRenderer.renderToBitmap(_loc4_,_loc3_.styleSheet,param2,true),PixelSnapping.AUTO,true);
      _loc5_.y = this._yOffset;
      _loc5_.alpha = 0.7;
      addChild(_loc5_);
      this._yOffset = this._yOffset + _loc5_.height;
      this._lines.push(_loc5_);
      this._width = Math.max(this._width,_loc5_.width);
      this.layoutLines();
   }
   
   private function layoutLines() : void
   {
      var _loc1_:Bitmap = null;
      for each(_loc1_ in this._lines)
      {
         _loc1_.x = (this._width - _loc1_.width) / 2;
      }
   }
   
   public function get lineCount() : int
   {
      return this._lines.length;
   }
}
