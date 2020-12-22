package de.freggers.isostar
{
   import de.freggers.util.ICroppedBitmapDataContainer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class AIsoFlatThing extends IsoSortable
   {
       
      
      private var _bounds:Rectangle;
      
      private var _content:DisplayObject;
      
      private var _cutmaskbm:Bitmap;
      
      private var _cutmaskbmd:BitmapData;
      
      private var _isoparent:IIsoContainer;
      
      public function AIsoFlatThing(param1:IIsoContainer, param2:Vector3D = null)
      {
         super();
         if(param2 == null)
         {
            param2 = new Vector3D();
         }
         this._isoparent = param1;
         this._bounds = new Rectangle();
         setIsoPosition(param2.x,param2.y,param2.z);
      }
      
      public function set content(param1:DisplayObject) : void
      {
         if(this._content && this.contains(this._content))
         {
            this.removeChild(this._content);
         }
         this._content = param1;
         if(!this._content)
         {
            return;
         }
         this.addChildAt(this._content,0);
         if(this._content is Sprite)
         {
            this.hitArea = this._content as Sprite;
         }
         if(this.isoparent.hasMasks())
         {
            if(this._cutmaskbmd)
            {
               this._cutmaskbmd.dispose();
            }
            this._cutmaskbmd = new BitmapData(this._content.width,this._content.height,true,0);
            if(!this._cutmaskbm)
            {
               this._cutmaskbm = new Bitmap();
            }
            this._cutmaskbm.bitmapData = this._cutmaskbmd;
            this._cutmaskbm.blendMode = BlendMode.ERASE;
            addChild(this._cutmaskbm);
            this.updateCutmask();
         }
         else
         {
            if(this._cutmaskbmd)
            {
               this._cutmaskbmd.dispose();
               this._cutmaskbmd = null;
            }
            if(this.cutmaskbm)
            {
               removeChild(this.cutmaskbm);
            }
            this._cutmaskbm = null;
         }
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      override protected function recalc() : void
      {
         super.recalc();
         this.updateCutmask();
         bounds.x = this.x;
         bounds.y = this.y;
         bounds.width = this.width;
         bounds.height = this.height;
      }
      
      private function updateCutmask() : void
      {
         var mask:ICroppedBitmapDataContainer = null;
         var p:Point = null;
         var i:int = 0;
         var j:int = 0;
         var offset:Point = null;
         var u:Number = NaN;
         var v:Number = NaN;
         var l:int = 0;
         var r:int = 0;
         var b:int = 0;
         var f:int = 0;
         var maskData:BitmapData = null;
         if(!this._cutmaskbmd)
         {
            return;
         }
         this._cutmaskbmd.fillRect(this._cutmaskbmd.rect,0);
         var dest:Point = new Point();
         var basetiles:Array = new Array();
         l = int(min_u / IsoGrid.upt);
         r = Math.ceil(max_u / IsoGrid.upt);
         b = int(min_v / IsoGrid.upt);
         f = Math.ceil(max_v / IsoGrid.upt);
         u = l - 1;
         while(u <= r)
         {
            basetiles.push(new Point(u,b));
            u++;
         }
         v = f - 1;
         while(v >= b)
         {
            basetiles.push(new Point(l,v));
            v--;
         }
         l = Math.ceil(min_u / IsoGrid.upt);
         r = int(max_u / IsoGrid.upt);
         b = Math.ceil(min_v / IsoGrid.upt);
         f = int(max_v / IsoGrid.upt);
         var equals:Function = function(param1:Point, param2:int, param3:Array):Boolean
         {
            return (this as Point).equals(param1);
         };
         u = l - 1;
         while(u <= r)
         {
            p = new Point(u,b);
            if(!basetiles.some(equals,p))
            {
               basetiles.push(p);
            }
            u++;
         }
         v = f - 1;
         while(v >= b)
         {
            p = new Point(l,v);
            if(!basetiles.some(equals,p))
            {
               basetiles.push(p);
            }
            v--;
         }
         var bounds:Rectangle = this.getBounds(this.parent);
         var boundsX:Number = bounds.x;
         var boundsY:Number = bounds.y;
         i = 0;
         while(i < basetiles.length)
         {
            offset = basetiles[i] as Point;
            if(offset)
            {
               j = 0;
               while(j < IsoStar.BACKGROUNDMASK_SEARCHDEPTH)
               {
                  u = offset.x + j;
                  v = offset.y + j;
                  if(!(u < 0 || v < 0))
                  {
                     mask = this._isoparent.getMask(u,v);
                     p = IsoGrid.xy(u,v,0,IsoGrid.MODE_MAIN);
                     if(mask)
                     {
                        dest.x = p.x + mask.crect.x - IsoGrid.tile_width / 2 - boundsX;
                        dest.y = p.y - mask.height + IsoGrid.tile_height + mask.crect.y - boundsY;
                        maskData = mask.bitmapData;
                        this._cutmaskbmd.threshold(maskData,maskData.rect,dest,"==",4294967295,4294967295);
                     }
                  }
                  j++;
               }
            }
            i++;
         }
      }
      
      private function get cutmaskbm() : Bitmap
      {
         return this._cutmaskbm;
      }
      
      protected function get isoparent() : IIsoContainer
      {
         return this._isoparent;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         if(this._cutmaskbmd)
         {
            this._cutmaskbmd.dispose();
         }
      }
   }
}
