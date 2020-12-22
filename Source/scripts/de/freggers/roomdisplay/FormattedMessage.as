package de.freggers.roomdisplay
{
   import de.freggers.roomlib.util.StyleSheetBuilder;
   import de.freggers.util.StringUtil;
   import flash.text.StyleSheet;
   
   public class FormattedMessage
   {
      
      public static const STYLE_LINK:StyleSheet = new StyleSheetBuilder(".link").add("fontSize",14).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("fontWeight","bold").add("color","#D6BF37").build();
      
      public static const STYLE_BOLD:StyleSheet = new StyleSheetBuilder(".bold").add("fontSize",14).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("fontWeight","bold").build();
      
      public static const STYLE_NORMAL:StyleSheet = new StyleSheetBuilder(".normal").add("fontSize",14).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").build();
      
      public static const STYLE_ITALIC:StyleSheet = new StyleSheetBuilder(".italic").add("fontSize",14).add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("fontStyle","italic").build();
       
      
      private var message:String;
      
      private var textParts:Array;
      
      private var styleSheets:Array;
      
      public function FormattedMessage(param1:String, param2:Array = null, param3:Array = null)
      {
         var _loc4_:int = 0;
         super();
         this.message = StringUtil.escapeHTML(param1);
         if(!param3)
         {
            param3 = new Array();
         }
         if(param3.indexOf(STYLE_NORMAL) < 0)
         {
            param3.push(STYLE_NORMAL);
         }
         this.styleSheets = param3;
         this.textParts = param2;
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               param2[_loc4_] = StringUtil.escapeHTML(param2[_loc4_]);
               _loc4_++;
            }
         }
      }
      
      public static function mergeStyles(param1:StyleSheet, param2:StyleSheet) : void
      {
         var _loc4_:int = 0;
         if(!param2 || !param1)
         {
            return;
         }
         var _loc3_:Array = param2.styleNames;
         if(_loc3_ && _loc3_.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               param1.setStyle(_loc3_[_loc4_],param2.getStyle(_loc3_[_loc4_]));
               _loc4_++;
            }
         }
      }
      
      public function get styles() : Array
      {
         return this.styleSheets;
      }
      
      public function toString() : String
      {
         var _loc1_:Array = null;
         var _loc3_:int = 0;
         if(this.textParts)
         {
            _loc1_ = new Array(this.textParts.length);
         }
         if(this.message && this.styleSheets && this.textParts)
         {
            _loc3_ = 0;
            while(_loc3_ < this.textParts.length)
            {
               if(this.styleSheets.length > _loc3_ && this.styleSheets[_loc3_])
               {
                  _loc1_[_loc3_] = "<span class=\'" + (this.styleSheets[_loc3_] as StyleSheet).styleNames[0].replace(".","") + "\'>" + this.textParts[_loc3_] + "</span>";
               }
               _loc3_++;
            }
         }
         var _loc2_:* = this.message;
         if(_loc2_)
         {
            _loc2_ = "<span class=\'" + STYLE_NORMAL.styleNames[0].replace(".","") + "\'>" + this.message + "</span>";
         }
         return StringUtil.formattedString(_loc2_,_loc1_);
      }
      
      public function get styleSheet() : StyleSheet
      {
         var _loc2_:int = 0;
         var _loc1_:StyleSheet = new StyleSheet();
         if(this.styles)
         {
            _loc2_ = 0;
            while(_loc2_ < this.styles.length)
            {
               mergeStyles(_loc1_,this.styles[_loc2_]);
               _loc2_++;
            }
         }
         return _loc1_;
      }
   }
}
