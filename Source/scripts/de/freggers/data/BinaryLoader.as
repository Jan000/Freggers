package de.freggers.data
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   
   public class BinaryLoader extends BinaryDecodable
   {
      
      public static const DPS_NOTTHERE:int = 0;
      
      public static const DPS_LOADING:int = 1;
      
      public static const DPS_BYTEDECODING:int = 2;
      
      public static const DPS_OK:int = 3;
      
      public static const IO_FLAG_NONE:uint = 0;
      
      public static const IO_FLAG_DECODED:uint = 1;
      
      public static const IO_FLAG_CANCELLED:uint = 2;
      
      public static const IO_FLAG_LOADING:uint = 4;
      
      public static const IO_FLAG_ERROR:uint = 8;
       
      
      public var onLoadComplete:Function;
      
      public var onIOError:Function;
      
      public var onSecurityError:Function;
      
      public var onLoadProgress:Function;
      
      private var _urlStream:URLStream;
      
      private var _ioFlags:uint = 0;
      
      public function BinaryLoader()
      {
         super();
      }
      
      override public function removeCallbacks() : void
      {
         super.removeCallbacks();
         this.onLoadComplete = this.onIOError = this.onSecurityError = this.onLoadProgress = null;
      }
      
      public function get ioFlags() : uint
      {
         return this._ioFlags;
      }
      
      public function load(param1:String) : void
      {
         this._ioFlags = this._ioFlags | IO_FLAG_LOADING;
         this._urlStream = new URLStream();
         this._addEventListeners(this._urlStream,this.handleLoadEvents);
         this._urlStream.load(new URLRequest(param1));
      }
      
      private function handleLoadEvents(param1:Event) : void
      {
         var ioe:IOErrorEvent = null;
         var se:SecurityErrorEvent = null;
         var pe:ProgressEvent = null;
         var ba:ByteArray = null;
         var e:Event = param1;
         e.stopImmediatePropagation();
         if(!(e.target is URLStream))
         {
            return;
         }
         var urlstream:URLStream = e.target as URLStream;
         try
         {
            switch(e.type)
            {
               case IOErrorEvent.IO_ERROR:
                  this._ioFlags = this._ioFlags & ~IO_FLAG_LOADING | IO_FLAG_ERROR;
                  this._removeEventListeners(urlstream,this.handleLoadEvents);
                  ioe = e as IOErrorEvent;
                  if(this.onIOError != null)
                  {
                     this.onIOError(this,ioe);
                  }
                  this.removeCallbacks();
                  break;
               case SecurityErrorEvent.SECURITY_ERROR:
                  this._ioFlags = this._ioFlags & ~IO_FLAG_LOADING | IO_FLAG_ERROR;
                  this._removeEventListeners(urlstream,this.handleLoadEvents);
                  se = e as SecurityErrorEvent;
                  if(this.onSecurityError != null)
                  {
                     this.onSecurityError(this,se);
                  }
                  this.removeCallbacks();
                  break;
               case ProgressEvent.PROGRESS:
                  pe = e as ProgressEvent;
                  if(this.onLoadProgress != null)
                  {
                     this.onLoadProgress(this,pe.bytesLoaded,pe.bytesTotal);
                  }
                  break;
               case Event.COMPLETE:
                  this._removeEventListeners(urlstream,this.handleLoadEvents);
                  ba = new ByteArray();
                  urlstream.readBytes(ba,0,urlstream.bytesAvailable);
                  urlstream.close();
                  this._urlStream = null;
                  if(this.onLoadComplete != null)
                  {
                     this.onLoadComplete(this);
                  }
                  this.onLoadComplete = this.onIOError = this.onSecurityError = this.onLoadProgress = null;
                  decodeBytes(ba);
                  break;
               default:
                  this._ioFlags = this._ioFlags | IO_FLAG_ERROR;
                  this.removeCallbacks();
                  this._removeEventListeners(urlstream,this.handleLoadEvents);
            }
            return;
         }
         catch(error:ArgumentError)
         {
            return;
         }
      }
      
      public function cancelLoad() : void
      {
         var _loc1_:URLStream = null;
         this._ioFlags = this._ioFlags & ~IO_FLAG_LOADING | IO_FLAG_CANCELLED;
         this.removeCallbacks();
         this._removeEventListeners(_loc1_,this.handleLoadEvents);
         if(this._urlStream && this._urlStream.connected)
         {
            this._urlStream.close();
            this._urlStream = null;
         }
      }
      
      private function _addEventListeners(param1:URLStream, param2:Function) : void
      {
         param1.addEventListener(Event.COMPLETE,param2);
         param1.addEventListener(IOErrorEvent.IO_ERROR,param2);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,param2);
         param1.addEventListener(ProgressEvent.PROGRESS,param2);
      }
      
      private function _removeEventListeners(param1:URLStream, param2:Function) : void
      {
         if(!param1 || param2 == null)
         {
            return;
         }
         param1.removeEventListener(Event.COMPLETE,param2);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,param2);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,param2);
         param1.removeEventListener(ProgressEvent.PROGRESS,param2);
      }
   }
}
