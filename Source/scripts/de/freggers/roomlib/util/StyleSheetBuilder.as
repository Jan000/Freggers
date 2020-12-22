package de.freggers.roomlib.util
{
   import flash.text.StyleSheet;
   
   public class StyleSheetBuilder
   {
       
      
      private var _options:Object;
      
      private var _styleName:String;
      
      private var _style:StyleSheet;
      
      public function StyleSheetBuilder(param1:String = null)
      {
         this._style = new StyleSheet();
         super();
         if(param1 != null)
         {
            this.addStyle(param1);
         }
      }
      
      public function add(param1:String, param2:*) : StyleSheetBuilder
      {
         this._options[param1] = param2;
         return this;
      }
      
      public function addStyle(param1:String, param2:Object = null) : StyleSheetBuilder
      {
         if(this._styleName != null)
         {
            this._style.setStyle(this._styleName,this._options);
         }
         if(param2 == null)
         {
            this._options = new Object();
         }
         else
         {
            this._options = param2;
         }
         this._styleName = param1;
         return this;
      }
      
      public function build() : StyleSheet
      {
         if(this._styleName != null)
         {
            this._style.setStyle(this._styleName,this._options);
         }
         return this._style;
      }
   }
}
