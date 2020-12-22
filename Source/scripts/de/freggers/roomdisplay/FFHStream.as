package de.freggers.roomdisplay
{
   import flash.errors.IOError;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   public class FFHStream
   {
      
      private static const STREAM_URL:String = "http://streams.ffh.de/radioffh/mp3/hqlivestream.mp3";
       
      
      private var _soundChannel:SoundChannel;
      
      private var _sound:Sound;
      
      private var _context:SoundLoaderContext;
      
      private var _soundIOErrorOccured:Boolean;
      
      private var _volume:Number = 1;
      
      private var _countStream:Number = 0;
      
      public function FFHStream()
      {
         super();
         this._context = new SoundLoaderContext(8000,false);
      }
      
      public function setVolume(param1:Number) : void
      {
         var _loc2_:SoundTransform = null;
         this._volume = param1 > 0?Number(1):Number(0);
         if(this._soundChannel)
         {
            _loc2_ = this._soundChannel.soundTransform;
            _loc2_.volume = this._volume * 0.35;
            this._soundChannel.soundTransform = _loc2_;
         }
         if(this._countStream > 0)
         {
            if(this._volume == 1 && !this._sound)
            {
               this.playSound();
            }
            else if(this._volume == 0 && this._sound)
            {
               this.stopSound();
            }
         }
      }
      
      public function startStream() : void
      {
         if(this._countStream == 0)
         {
            if(this._volume > 0)
            {
               this.playSound();
               this.setVolume(this._volume);
            }
         }
         this._countStream++;
      }
      
      public function stopStream(param1:Boolean = false) : void
      {
         this._countStream--;
         if(param1 || this._countStream < 1)
         {
            this.stopSound();
            this._countStream = 0;
         }
      }
      
      private function playSound() : void
      {
         this._sound = new Sound();
         var _loc1_:URLRequest = new URLRequest(STREAM_URL);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this._sound.load(_loc1_,this._context);
         this._soundChannel = this._sound.play();
         this._soundIOErrorOccured = false;
      }
      
      private function stopSound() : void
      {
         if(this._sound && !this._soundIOErrorOccured)
         {
            if(this._soundChannel)
            {
               this._soundChannel.stop();
            }
            try
            {
               this._sound.close();
            }
            catch(err:IOError)
            {
            }
         }
         this._sound = null;
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         JSApi.writeConsole("",0,"[FFH RADIO STREAM ERROR]",0,"#990000");
         this._soundIOErrorOccured = true;
         this.stopSound();
      }
   }
}
