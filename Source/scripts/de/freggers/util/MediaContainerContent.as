package de.freggers.util
{
   import de.freggers.isocomp.AIsoComponent;
   import de.freggers.roomcomp.ARoomComponent;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   
   public class MediaContainerContent
   {
       
      
      private var _content:Vector.<MCCE>;
      
      public function MediaContainerContent()
      {
         super();
      }
      
      public function initWithSize(param1:int) : void
      {
         this._content = new Vector.<MCCE>(param1);
      }
      
      public function setElementAt(param1:int, param2:MCCE) : void
      {
         if(!param2)
         {
            return;
         }
         if(this._content[int(param1)])
         {
            this.cleanupElementAt(param1);
         }
         this._content[int(param1)] = param2;
      }
      
      public function getElementAt(param1:int) : MCCE
      {
         return this._content[int(param1)] as MCCE;
      }
      
      public function getTypeAt(param1:int) : int
      {
         if(!this._content[int(param1)])
         {
            return -1;
         }
         return (this._content[int(param1)] as MCCE).type;
      }
      
      public function getContentAt(param1:int) : *
      {
         if(!this._content[int(param1)])
         {
            return null;
         }
         return (this._content[int(param1)] as MCCE).content;
      }
      
      public function setTypeAt(param1:int, param2:int) : void
      {
         if(!this._content[int(param1)])
         {
            return;
         }
         (this._content[int(param1)] as MCCE).type = param2;
      }
      
      public function setContentAt(param1:int, param2:*) : void
      {
         if(!this._content[int(param1)])
         {
            return;
         }
         (this._content[int(param1)] as MCCE).content = param2;
      }
      
      public function push(param1:*, param2:int) : void
      {
         this._content.push(new MCCE(param2,param1));
      }
      
      public function get length() : int
      {
         return this._content.length;
      }
      
      public function getStringAt(param1:int) : String
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         if(this.getTypeAt(param1) != MediaContainerDecoder.TYPE_STRING)
         {
            return null;
         }
         return String(this.getContentAt(param1));
      }
      
      public function getIntAt(param1:int) : int
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return NaN;
         }
         if(!(this.getTypeAt(param1) == MediaContainerDecoder.TYPE_INT || this.getTypeAt(param1) == MediaContainerDecoder.TYPE_BYTE))
         {
            return NaN;
         }
         return int(this.getContentAt(param1));
      }
      
      public function getByteAt(param1:int) : int
      {
         return this.getIntAt(param1);
      }
      
      public function getByteArrayAt(param1:int) : ByteArray
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         if(this.getTypeAt(param1) != MediaContainerDecoder.TYPE_RAWBYTES)
         {
            return null;
         }
         return ByteArray(this.getContentAt(param1));
      }
      
      public function getRoomCompAt(param1:int) : ARoomComponent
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         if(this.getTypeAt(param1) != MediaContainerDecoder.TYPE_ROOMCOMP)
         {
            return null;
         }
         return this.getContentAt(param1) as ARoomComponent;
      }
      
      public function getBitmapDataAt(param1:int) : BitmapData
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         var _loc2_:int = this.getTypeAt(param1);
         if(_loc2_ != MediaContainerDecoder.TYPE_BITMAP && _loc2_ != MediaContainerDecoder.TYPE_ARGB32)
         {
            return null;
         }
         if(this._content[param1] == null)
         {
            return null;
         }
         var _loc3_:ByteArray = this.getContentAt(param1) as ByteArray;
         _loc3_.position = 0;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt();
         var _loc6_:BitmapData = new BitmapData(_loc4_,_loc5_,true,0);
         _loc3_.position = 2 * 4;
         _loc6_.setPixels(new Rectangle(0,0,_loc4_,_loc5_),_loc3_);
         return _loc6_;
      }
      
      public function getCroppedBitmapDataAt(param1:int, param2:uint, param3:uint, param4:Boolean = false) : ICroppedBitmapDataContainer
      {
         var _loc7_:ICroppedBitmapDataContainer = null;
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         var _loc5_:int = this.getTypeAt(param1);
         if(_loc5_ != MediaContainerDecoder.TYPE_BITMAP && _loc5_ != MediaContainerDecoder.TYPE_ARGB32)
         {
            return null;
         }
         var _loc6_:BitmapData = this.getBitmapDataAt(param1);
         if(param4)
         {
            _loc7_ = new CroppedVBitmapDataContainer(_loc6_,param2,param3);
         }
         else
         {
            _loc7_ = new CroppedBitmapDataContainer(_loc6_,param2,param3);
         }
         _loc6_.dispose();
         _loc6_ = null;
         return _loc7_;
      }
      
      public function getIsoComponentAt(param1:int) : AIsoComponent
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         if(this.getTypeAt(param1) != MediaContainerDecoder.TYPE_ISOCOMP || !(this.getContentAt(param1) is AIsoComponent))
         {
            return null;
         }
         return AIsoComponent(this.getContentAt(param1));
      }
      
      public function getSoundAt(param1:int) : Sound
      {
         if(param1 < 0 || param1 >= this._content.length)
         {
            return null;
         }
         if(this.getTypeAt(param1) != MediaContainerDecoder.TYPE_MP3)
         {
            return null;
         }
         return this.getContentAt(param1) as Sound;
      }
      
      public function cleanup() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._content.length)
         {
            this.cleanupElementAt(_loc1_);
            _loc1_++;
         }
         this._content.length = 0;
      }
      
      public function cleanupElementAt(param1:int) : void
      {
         if(!this._content[param1])
         {
            return;
         }
         if((this._content[param1] as MCCE).content is BitmapData)
         {
            ((this._content[param1] as MCCE).content as BitmapData).dispose();
         }
         this._content[param1] = null;
      }
   }
}
