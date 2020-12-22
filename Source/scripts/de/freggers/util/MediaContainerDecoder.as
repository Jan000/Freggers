package de.freggers.util
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class MediaContainerDecoder
   {
      
      public static const TYPE_BITMAP:int = 0;
      
      public static const TYPE_RAWBYTES:int = 1;
      
      public static const TYPE_STRING:int = 2;
      
      public static const TYPE_INT:int = 3;
      
      public static const TYPE_BYTE:int = 4;
      
      public static const TYPE_ISOCOMP:int = 5;
      
      public static const TYPE_ARGB32:int = 6;
      
      public static const TYPE_ROOMCOMP:int = 7;
      
      public static const TYPE_MP3:int = 8;
      
      public static const TYPE_NULL:int = 99;
       
      
      private var content:MediaContainerContent = null;
      
      private var onComplete:Function = null;
      
      private var count:int = 0;
      
      private var done:int = 0;
      
      public function MediaContainerDecoder()
      {
         super();
      }
      
      private static function _extractBitmap(param1:Loader) : ByteArray
      {
         var _loc2_:BitmapData = (param1.content as Bitmap).bitmapData;
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:ByteArray = _loc2_.getPixels(_loc2_.rect);
         _loc4_.position = 0;
         _loc3_.writeInt(_loc2_.rect.width);
         _loc3_.writeInt(_loc2_.rect.height);
         _loc3_.writeBytes(_loc4_,0,_loc4_.length);
         _loc2_.dispose();
         return _loc3_;
      }
      
      private static function _extractMp3(param1:Loader) : Object
      {
         var DynaSound:Class = null;
         var loader:Loader = param1;
         try
         {
            DynaSound = loader.contentLoaderInfo.applicationDomain.getDefinition(SoundSwfBuilder.SOUND_CLASS_NAME) as Class;
            return new DynaSound();
         }
         catch(error:Error)
         {
         }
         return null;
      }
      
      public function decodeDataBytes(param1:ByteArray, param2:Function) : void
      {
         if(!param2)
         {
            throw new Error("onComplete handler is required");
         }
         if(this.content)
         {
            throw new Error("decoding already started");
         }
         this.content = new MediaContainerContent();
         this.onComplete = param2;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(param1,0,param1.length);
         _loc3_.position = 0;
         _loc3_.uncompress();
         this._decodeDataBytes(_loc3_);
      }
      
      private function _decodeDataBytes(param1:ByteArray) : *
      {
         var type:uint = 0;
         var size:uint = 0;
         var ba:ByteArray = null;
         var nextPos:* = undefined;
         var data:ByteArray = param1;
         this.count = data.readUnsignedInt();
         this.content.initWithSize(this.count);
         var i:int = 0;
         while(i < this.count)
         {
            type = data.readUnsignedByte();
            size = data.readUnsignedInt();
            if(size == 0)
            {
               type = MediaContainerDecoder.TYPE_NULL;
            }
            else
            {
               nextPos = data.position + size;
               ba = new ByteArray();
               ba.writeBytes(data,data.position,size);
               ba.position = 0;
               data.position = nextPos;
            }
            this.content.setElementAt(i,new MCCE(type,null));
            switch(type)
            {
               case MediaContainerDecoder.TYPE_ARGB32:
               case MediaContainerDecoder.TYPE_RAWBYTES:
                  this.content.setContentAt(i,ba);
                  this.done++;
                  break;
               case MediaContainerDecoder.TYPE_STRING:
                  this.content.setContentAt(i,ba.toString());
                  this.done++;
                  break;
               case MediaContainerDecoder.TYPE_INT:
                  this.content.setContentAt(i,ba.readInt());
                  this.done++;
                  break;
               case MediaContainerDecoder.TYPE_BYTE:
                  this.content.setContentAt(i,ba.readUnsignedByte());
                  this.done++;
                  break;
               case MediaContainerDecoder.TYPE_MP3:
                  this.loadAndSetContentAt(i,SoundSwfBuilder.create(ba),_extractMp3);
                  break;
               case MediaContainerDecoder.TYPE_BITMAP:
                  this.loadAndSetContentAt(i,ba,_extractBitmap);
                  break;
               case MediaContainerDecoder.TYPE_ROOMCOMP:
               case MediaContainerDecoder.TYPE_ISOCOMP:
                  this.loadAndSetContentAt(i,ba,function(param1:Loader):Object
                  {
                     return param1.content;
                  });
                  break;
               case MediaContainerDecoder.TYPE_NULL:
               default:
                  this.done++;
            }
            i++;
         }
         if(this.done >= this.count)
         {
            this.onComplete(this.content);
         }
      }
      
      private function loadAndSetContentAt(param1:int, param2:ByteArray, param3:Function) : void
      {
         var callback:* = undefined;
         var index:int = param1;
         var data:ByteArray = param2;
         var extract:Function = param3;
         callback = function(param1:Event):void
         {
            var _loc2_:* = param1.target;
            _loc2_.removeEventListener(Event.INIT,callback);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,callback);
            if(param1.type != IOErrorEvent.IO_ERROR)
            {
               content.setContentAt(index,extract(_loc2_.loader));
            }
            _loc2_.loader.unload();
            if(++done >= count)
            {
               onComplete(content);
            }
         };
         var loader:Loader = new Loader();
         var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.INIT,callback,false,int.MAX_VALUE);
         loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,callback,false,int.MAX_VALUE);
         var loaderContext:LoaderContext = new LoaderContext();
         if(Capabilities.playerType == "Desktop")
         {
            loaderContext["allowLoadBytesCodeExecution"] = true;
         }
         loader.loadBytes(data,loaderContext);
      }
   }
}
