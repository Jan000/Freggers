package de.freggers.roomdisplay.milwkit
{
   import de.freggers.notify.events.CloseEvent;
   import de.freggers.notify.events.RequestActionEvent;
   import de.freggers.notify.events.ShowBadgesEvent;
   import de.freggers.notify.events.WalkToRoomEvent;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.net.Responder;
   import flash.net.URLRequest;
   import flash.text.TextFieldAutoSize;
   
   public class MILWKITScreen extends Sprite
   {
       
      
      private var _background:MILWKITGfx;
      
      private var loading:DisplayObject;
      
      private var param:Object;
      
      public function MILWKITScreen(param1:Object)
      {
         super();
         this.param = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._background = new MILWKITGfx();
         this._background.close.buttonMode = true;
         this._background.close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
         });
         addChildAt(this._background,0);
         this.loading = new icon_composing();
         this.loading.x = this._background.width / 2;
         this.loading.y = this._background.height / 2;
         this.loading.filters = [new ColorMatrixFilter([0.66,0.66,0.66,0,0,0.66,0.66,0.66,0,0,0.66,0.66,0.66,0,0,0,0,0,1,0])];
         this.loading.scaleX = this.loading.scaleY = 3;
         addChild(this.loading);
         this.loadMILWKIT();
      }
      
      private function loadMILWKIT() : void
      {
         var _loc1_:String = this.param["amfgw"];
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:NetConnection = new NetConnection();
         _loc2_.objectEncoding = ObjectEncoding.AMF0;
         _loc2_.connect(this.param["amfgw"]);
         _loc2_.addEventListener(NetStatusEvent.NET_STATUS,this._onNetStatus,false,0,true);
         _loc2_.call("Core.get_milwkit",new Responder(this._onGWResponse,this._onGWError));
      }
      
      private function _onGWResponse(param1:Object) : void
      {
         var show:DisplayObject = null;
         var hint:DisplayObject = null;
         var loader:Loader = null;
         var b:Rectangle = null;
         var badge:MILWKITBadgeGfx = null;
         var item:BargainListItemGfx = null;
         var staticTip:MILWKITStaticGfx = null;
         var yPosition:int = 0;
         var showHeight:Number = NaN;
         var result:Object = param1;
         RoomDisplay.dump(result);
         if(this.loading.parent != null)
         {
            this.loading.parent.removeChild(this.loading);
         }
         if(result["type"] == "badge")
         {
            badge = new MILWKITBadgeGfx();
            hint = new MILWKITBadgeGfxHint();
            badge.badgename.multiline = true;
            badge.badgename.wordWrap = true;
            badge.badgename.autoSize = TextFieldAutoSize.LEFT;
            badge.badgename.text = result["data"]["name"];
            badge.badgedescription.autoSize = TextFieldAutoSize.LEFT;
            badge.badgedescription.text = result["data"]["description"];
            badge.badgedescription.y = badge.badgename.y + badge.badgename.height + 10;
            badge.showBadges.y = badge.badgedescription.y + badge.badgedescription.height + 10;
            loader = new Loader();
            loader.load(new URLRequest(result["data"]["icon_url"]));
            badge.itemgfx.addChild(loader);
            badge.showBadges.buttonMode = true;
            badge.showBadges.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               param1.stopImmediatePropagation();
               dispatchEvent(new ShowBadgesEvent(RequestActionEvent.EXECUTE));
            });
            badge.showBadges.addEventListener(MouseEvent.MOUSE_UP,this.__cb_mouse_ignore);
            badge.showBadges.addEventListener(MouseEvent.MOUSE_DOWN,this.__cb_mouse_ignore);
            if(badge.showBadges.y + badge.showBadges.height > badge.background.height)
            {
               badge.background.height = badge.showBadges.y + badge.showBadges.height;
            }
            show = badge;
         }
         else if(result["type"] == "item")
         {
            item = new BargainListItemGfx();
            hint = new BargainListItemGfxHint();
            item.itemname.multiline = true;
            item.itemname.wordWrap = true;
            item.itemname.autoSize = TextFieldAutoSize.LEFT;
            item.itemname.text = result["data"]["name"];
            item.itemdescription.autoSize = TextFieldAutoSize.LEFT;
            item.itemdescription.text = result["data"]["description"];
            item.buttons.today.text = result["data"]["price"];
            item.buttons.tomorrow.text = result["data"]["base_price"];
            item.buttons.shopname.text = result["data"]["shop_name"];
            item.itemdescription.y = item.itemname.y + item.itemname.height + 10;
            item.buttons.y = item.itemdescription.y + item.itemdescription.height + 10;
            if(item.buttons.y + item.buttons.height > item.background.height)
            {
               item.background.height = item.buttons.y + item.buttons.height;
            }
            loader = new Loader();
            loader.load(new URLRequest(result["data"]["icon_url"]));
            item.itemgfx.addChild(loader);
            item.buttons.go.buttonMode = true;
            if(result["data"]["room_label"] != null)
            {
               item.buttons.go.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  param1.stopImmediatePropagation();
                  dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
                  dispatchEvent(new WalkToRoomEvent(RequestActionEvent.EXECUTE,result["data"]["room_label"]));
               });
               item.buttons.go.addEventListener(MouseEvent.MOUSE_UP,this.__cb_mouse_ignore);
               item.buttons.go.addEventListener(MouseEvent.MOUSE_DOWN,this.__cb_mouse_ignore);
            }
            else
            {
               item.buttons.go.visible = false;
            }
            show = item;
         }
         else if(result["type"] == "static")
         {
            staticTip = new MILWKITStaticGfx();
            hint = new MILWKITStaticGfxHint();
            staticTip.head.multiline = true;
            staticTip.head.wordWrap = true;
            staticTip.head.autoSize = TextFieldAutoSize.LEFT;
            staticTip.head.text = result["data"]["head"];
            staticTip.body.autoSize = TextFieldAutoSize.LEFT;
            staticTip.body.text = result["data"]["body"];
            staticTip.body.y = staticTip.head.y + staticTip.head.height + 10;
            staticTip.buttons.y = staticTip.body.y + staticTip.body.height + 10;
            if(staticTip.buttons.y + staticTip.buttons.height > staticTip.background.height)
            {
               staticTip.background.height = staticTip.buttons.y + staticTip.buttons.height;
            }
            loader = new Loader();
            loader.load(new URLRequest(result["data"]["icon_url"]));
            staticTip.itemgfx.addChild(loader);
            staticTip.buttons.go.buttonMode = true;
            if(result["data"]["room_label"] != null)
            {
               staticTip.buttons.roomname.text = result["data"]["room_name"];
               staticTip.buttons.go.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  param1.stopImmediatePropagation();
                  dispatchEvent(new CloseEvent(RequestActionEvent.EXECUTE));
                  dispatchEvent(new WalkToRoomEvent(RequestActionEvent.EXECUTE,result["data"]["room_label"]));
               });
               staticTip.buttons.go.addEventListener(MouseEvent.MOUSE_UP,this.__cb_mouse_ignore);
               staticTip.buttons.go.addEventListener(MouseEvent.MOUSE_DOWN,this.__cb_mouse_ignore);
            }
            else
            {
               staticTip.buttons.visible = false;
            }
            show = staticTip;
         }
         if(show != null)
         {
            yPosition = this._background.suggestionlocation.y;
            if(hint != null)
            {
               hint.x = 0;
               hint.y = yPosition;
               yPosition = yPosition + (hint.height + 20);
               addChild(hint);
            }
            show.x = this._background.suggestionlocation.x;
            show.y = yPosition;
            showHeight = show.height;
            addChild(show);
            b = show.getBounds(this._background);
            this._background.background.height = b.y + showHeight + 60;
         }
      }
      
      private function _onGWError(param1:Object) : void
      {
      }
      
      private function _onNetStatus(param1:NetStatusEvent) : void
      {
      }
      
      private function __cb_mouse_ignore(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
      }
   }
}
