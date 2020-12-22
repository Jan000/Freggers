package de.freggers.roomdisplay
{
   import de.freggers.ui.ISelectable;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ItemMenu extends Sprite
   {
      
      private static const MENU_ITEM_SPACING:Number = 0;
      
      private static const BOTTOM_OFFSET:Number = 15;
      
      private static const ICON_SIZE:int = 32;
       
      
      public var onMenuHidden:Function;
      
      public var onMenuAction:Function;
      
      public var onActionsRequest:Function;
      
      private var _title:MenuTitle;
      
      private var _items:Array;
      
      private var _itemlayer:Sprite;
      
      private var _content:MyMenuContent;
      
      private var _menuitems:Array;
      
      private var _selection:ISelectable;
      
      private var _selectionBounds:Rectangle;
      
      private var _contentBounds:Rectangle;
      
      private var _icon:Bitmap;
      
      private var _iconBg:Shape;
      
      private var screenMaxX:int = 0;
      
      private var screenMaxY:int = 0;
      
      public function ItemMenu(param1:String = null)
      {
         super();
         this.visible = false;
         if(param1)
         {
            this.title = param1;
         }
         this._content = new MyMenuContent();
         this._icon = new Bitmap();
         this._iconBg = new Shape();
         this._iconBg.graphics.lineStyle(2,11454137,0.5);
         this._iconBg.graphics.beginFill(16777215,0.75);
         this._iconBg.graphics.drawCircle(0,0,ICON_SIZE / 2 + 3);
         this._iconBg.graphics.endFill();
         addChild(this._content);
         addChild(this._iconBg);
         addChild(this._icon);
         this._itemlayer = new Sprite();
         this._itemlayer.mouseEnabled = false;
         this._content.addChild(this._itemlayer);
         this._content.mouseEnabled = false;
         this._content.bg.mouseEnabled = false;
         this._content.bg.alpha = 0.35;
         this._content.close.buttonMode = true;
      }
      
      public function get close() : DisplayObject
      {
         return this._content.close;
      }
      
      private function set bgheight(param1:Number) : void
      {
         this._content.bg.height = param1;
      }
      
      public function get menuHeight() : Number
      {
         return this._content.height;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title && this._content.contains(this._title))
         {
            this._title.cleanup();
            this._content.removeChild(this._title);
         }
         if(param1 == null)
         {
            param1 = "";
         }
         this._title = new MenuTitle(param1,this._content.close.x - ICON_SIZE);
         this._content.addChild(this._title);
         this._title.x = (this._content.width - this._title.width) / 2;
         this._title.y = this._content.itemsloc.y;
         this._itemlayer.y = this._title.y + this._title.height + 5;
      }
      
      public function show() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:BitmapData = null;
         var _loc6_:Matrix = null;
         if(this.visible)
         {
            return;
         }
         this.repaint();
         this.visible = true;
         if(this.selection != null)
         {
            this._content.x = this.parent.mouseX;
            this._content.y = this.parent.mouseY;
            if(this._content.x < 0)
            {
               this._content.x = 0 + ICON_SIZE / 2;
            }
            if(this._content.y < 0)
            {
               this._content.y = 0 + ICON_SIZE / 2;
            }
            if(this._content.x > this.screenMaxX - this._content.width)
            {
               this._content.x = this.screenMaxX - this._content.width;
            }
            if(this._content.y > this.screenMaxY - this._content.height)
            {
               this._content.y = this.screenMaxY - this._content.height;
            }
            _loc1_ = this.selection.icon;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.width;
               _loc3_ = _loc1_.height;
               _loc4_ = ICON_SIZE / (_loc2_ > _loc3_?_loc2_:_loc3_);
               if(_loc4_ > 1)
               {
                  _loc4_ = 1;
               }
               _loc2_ = _loc2_ * _loc4_;
               _loc3_ = _loc3_ * _loc4_;
               _loc5_ = new BitmapData(_loc2_,_loc3_,true,0);
               _loc6_ = new Matrix();
               _loc6_.scale(_loc4_,_loc4_);
               _loc5_.draw(_loc1_,_loc6_,null,null,null,true);
               this._icon.bitmapData = _loc5_;
               this._icon.x = this._content.x - this._icon.width / 2;
               this._icon.y = this._content.y - this._icon.height / 2;
               this._iconBg.x = this._content.x;
               this._iconBg.y = this._content.y;
               this._icon.visible = true;
               this._iconBg.visible = true;
            }
            else
            {
               this._icon.visible = false;
               this._iconBg.visible = false;
            }
         }
      }
      
      public function hide() : void
      {
         if(!this.visible)
         {
            return;
         }
         this.visible = false;
         if(this._icon.bitmapData != null)
         {
            this._icon.bitmapData.dispose();
            this._icon.bitmapData = null;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:MenuItem = null;
         if(!this._items)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            _loc1_ = this._items[_loc2_] as MenuItem;
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            _loc1_.cleanup();
            _loc2_++;
         }
         this._items.length = 0;
      }
      
      public function set items(param1:Array) : void
      {
         this.clear();
         this._items = param1;
         this.repaint();
      }
      
      private function repaint() : void
      {
         var _loc2_:int = 0;
         var _loc4_:MenuItem = null;
         var _loc1_:Number = 0;
         var _loc3_:int = this._itemlayer.numChildren;
         if(this._items)
         {
            _loc2_ = 0;
            while(_loc2_ < this._items.length)
            {
               _loc4_ = this._items[_loc2_] as MenuItem;
               _loc4_.y = _loc1_;
               _loc4_.x = (this._content.bg.width - _loc4_.width) / 2;
               _loc4_.slot = _loc2_;
               this._itemlayer.addChild(_loc4_);
               _loc1_ = _loc1_ + (_loc4_.height + MENU_ITEM_SPACING);
               _loc2_++;
            }
         }
         this._itemlayer.y = this._title.y + this._title.height + 5;
         this.bgheight = _loc1_ + this._itemlayer.y + BOTTOM_OFFSET;
      }
      
      public function getEnabledMenuItem() : MenuItem
      {
         if(!this._items)
         {
            return null;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_] && (this._items[_loc1_] as MenuItem).enabled)
            {
               return this._items[_loc1_] as MenuItem;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function getMenuItemAt(param1:int) : MenuItem
      {
         if(!this._items || param1 < 0 || param1 >= this._items.length)
         {
            return null;
         }
         return this._items[param1] as MenuItem;
      }
      
      public function cleanup() : void
      {
         this.clear();
         this.title = null;
      }
      
      public function set selection(param1:ISelectable) : void
      {
         if(this._selection == param1)
         {
            return;
         }
         this._selection = param1;
      }
      
      public function get selection() : ISelectable
      {
         return this._selection;
      }
      
      public function handleResize(param1:int, param2:int) : void
      {
         this.screenMaxX = param1;
         this.screenMaxY = param2;
      }
   }
}
