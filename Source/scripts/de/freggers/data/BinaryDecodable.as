package de.freggers.data
{
   import de.freggers.util.MediaContainerContent;
   import de.freggers.util.MediaContainerDecoder;
   import flash.utils.ByteArray;
   
   public class BinaryDecodable
   {
      
      public static var DEFAULT_DATAPACK:String = "init";
       
      
      public var onMediaContainerDecoded:Function;
      
      public var onMediaContainerDecodeError:Function;
      
      public function BinaryDecodable()
      {
         super();
      }
      
      public function removeCallbacks() : void
      {
         this.onMediaContainerDecoded = null;
         this.onMediaContainerDecodeError = null;
      }
      
      public function decodeBytes(param1:ByteArray) : void
      {
         var _loc2_:MediaContainerDecoder = new MediaContainerDecoder();
         _loc2_.decodeDataBytes(param1,this.__cb_onComplete);
      }
      
      private function __cb_onComplete(param1:MediaContainerContent) : void
      {
         var content:MediaContainerContent = param1;
         if(this.decode(content))
         {
            if(this.onMediaContainerDecoded != null)
            {
               try
               {
                  this.onMediaContainerDecoded(this);
               }
               catch(error:ArgumentError)
               {
               }
            }
         }
         else if(this.onMediaContainerDecodeError != null)
         {
            try
            {
               this.onMediaContainerDecodeError(this);
            }
            catch(error:ArgumentError)
            {
            }
         }
         this.removeCallbacks();
      }
      
      public function decode(param1:MediaContainerContent) : Boolean
      {
         throw new Error("not implemented");
      }
   }
}
