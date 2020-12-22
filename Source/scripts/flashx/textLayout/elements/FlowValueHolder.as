package flashx.textLayout.elements
{
   import flashx.textLayout.formats.TextLayoutFormatValueHolder;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   public class FlowValueHolder extends TextLayoutFormatValueHolder
   {
       
      
      private var _userStyles:Object;
      
      private var _privateData:Object;
      
      public function FlowValueHolder(param1:FlowValueHolder = null)
      {
         super(param1);
         this.initialize(param1);
      }
      
      private function initialize(param1:FlowValueHolder) : void
      {
         var _loc2_:* = null;
         if(param1)
         {
            for(_loc2_ in param1.userStyles)
            {
               this.writableUserStyles()[_loc2_] = param1.userStyles[_loc2_];
            }
            for(_loc2_ in param1.privateData)
            {
               this.writablePrivateData()[_loc2_] = param1.privateData[_loc2_];
            }
         }
      }
      
      private function writableUserStyles() : Object
      {
         if(this._userStyles == null)
         {
            this._userStyles = new Object();
         }
         return this._userStyles;
      }
      
      public function get userStyles() : Object
      {
         return this._userStyles;
      }
      
      public function set userStyles(param1:Object) : void
      {
         this._userStyles = param1;
      }
      
      public function getUserStyle(param1:String) : *
      {
         return !!this._userStyles?this._userStyles[param1]:undefined;
      }
      
      public function setUserStyle(param1:String, param2:*) : void
      {
         if(param2 === undefined)
         {
            if(this._userStyles)
            {
               delete this._userStyles[param1];
            }
         }
         else
         {
            this.writableUserStyles()[param1] = param2;
         }
      }
      
      private function writablePrivateData() : Object
      {
         if(this._privateData == null)
         {
            this._privateData = new Object();
         }
         return this._privateData;
      }
      
      public function get privateData() : Object
      {
         return this._privateData;
      }
      
      public function set privateData(param1:Object) : void
      {
         this._privateData = param1;
      }
      
      public function getPrivateData(param1:String) : *
      {
         return !!this._privateData?this._privateData[param1]:undefined;
      }
      
      public function setPrivateData(param1:String, param2:*) : void
      {
         if(param2 === undefined)
         {
            if(this._privateData)
            {
               delete this._privateData[param1];
            }
         }
         else
         {
            this.writablePrivateData()[param1] = param2;
         }
      }
   }
}
