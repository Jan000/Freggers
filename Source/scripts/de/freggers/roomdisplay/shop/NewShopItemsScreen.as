package de.freggers.roomdisplay.shop
{
   import de.freggers.notify.events.CloseEvent;
   import de.freggers.notify.events.RequestActionEvent;
   import de.freggers.notify.events.WalkToRoomEvent;
   import de.freggers.ui.Scrollbar;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   
   public class NewShopItemsScreen extends Sprite
   {
       
      
      private var _items:Array;
      
      private var _background:BargainListGfx;
      
      private var _scrollpane:Sprite;
      
      private var _scrollbar:Scrollbar;
      
      private var _listlength:Number;
      
      public function NewShopItemsScreen(param1:Array)
      {
         super();
         this._items = param1;
         this.init();
      }
      
      private function init() : void
      {
         var listItemGfx:BargainListItemGfx = null;
         var item:ShopItem = null;
         var l:Loader = null;
         if(this._items == null)
         {
            return;
         }
         this._background = new BargainListGfx();
         this._background.close.buttonMode = true;
         this._background.close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
         });
         var backgroundHeight:Number = 100;
         var scrollRect:Rectangle = new Rectangle();
         this._scrollpane = new Sprite();
         this._listlength = 0;
         var i:uint = 0;
         while(i < this._items.length)
         {
            item = this._items[i];
            if(item != null)
            {
               listItemGfx = new BargainListItemGfx();
               listItemGfx.itemname.multiline = true;
               listItemGfx.itemname.wordWrap = true;
               listItemGfx.itemname.autoSize = TextFieldAutoSize.LEFT;
               listItemGfx.itemname.text = item.name;
               listItemGfx.itemdescription.autoSize = TextFieldAutoSize.LEFT;
               listItemGfx.itemdescription.text = item.description;
               listItemGfx.buttons.today.text = item.price;
               listItemGfx.buttons.tomorrow.text = item.base_price;
               listItemGfx.buttons.shopname.text = item.shop_name;
               listItemGfx.itemdescription.y = listItemGfx.itemname.y + listItemGfx.itemname.height + 10;
               listItemGfx.buttons.y = listItemGfx.itemdescription.y + listItemGfx.itemdescription.height + 10;
               listItemGfx.background.height = listItemGfx.buttons.y + listItemGfx.buttons.height;
               l = new Loader();
               l.load(new URLRequest(item.iconUrl));
               listItemGfx.itemgfx.addChild(l);
               listItemGfx.x = 0;
               listItemGfx.y = this._listlength;
               this._listlength = this._listlength + (listItemGfx.height + 20);
               scrollRect.width = listItemGfx.width > scrollRect.width?Number(listItemGfx.width):Number(scrollRect.width);
               if(i <= 1)
               {
                  scrollRect.height = this._listlength - 20;
               }
               listItemGfx.buttons.go.buttonMode = true;
               listItemGfx.buttons.go["room_label"] = item.room_label;
               if(item.room_label != null)
               {
                  listItemGfx.buttons.go.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
                  {
                     var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
                     if(_loc2_ == null)
                     {
                        return;
                     }
                     dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
                     dispatchEvent(new WalkToRoomEvent(RequestActionEvent.EXECUTE,_loc2_["room_label"] as String));
                  });
                  listItemGfx.buttons.go.addEventListener(MouseEvent.MOUSE_UP,this.__cb_mouse_ignore);
                  listItemGfx.buttons.go.addEventListener(MouseEvent.MOUSE_DOWN,this.__cb_mouse_ignore);
               }
               else
               {
                  listItemGfx.buttons.go.visible = false;
               }
               this._scrollpane.addChild(listItemGfx);
               item = null;
            }
            i++;
         }
         this._listlength = this._listlength - 20;
         this._scrollpane.x = this._background.listitemlocation.x;
         this._scrollpane.y = this._background.listitemlocation.y - 40;
         this._scrollpane.scrollRect = scrollRect;
         if(this._items.length > 2)
         {
            this._scrollbar = new Scrollbar(new ScrollbarGfx(),scrollRect.height,scrollRect.height * scrollRect.height / this._listlength);
            this._scrollbar.addEventListener(Event.CHANGE,this.handleScrollbarChange);
            this._scrollbar.x = this._background.scrollbarlocation.x;
            this._scrollbar.y = this._background.scrollbarlocation.y;
            this._scrollbar.alpha = 0.75;
         }
         this._background.background.height = this._scrollpane.y + scrollRect.height + 40;
         addChild(this._background);
         addChild(this._scrollpane);
         if(this._scrollbar != null)
         {
            addChild(this._scrollbar);
         }
      }
      
      private function handleScrollbarChange(param1:Event) : void
      {
         var _loc2_:Rectangle = this._scrollpane.scrollRect.clone();
         _loc2_.y = (this._listlength - _loc2_.height) * this._scrollbar.position;
         this._scrollpane.scrollRect = _loc2_;
      }
      
      private function __cb_mouse_ignore(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
   }
}
