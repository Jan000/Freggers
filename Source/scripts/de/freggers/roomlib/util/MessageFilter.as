package de.freggers.roomlib.util
{
   import de.freggers.util.StringUtil;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public final class MessageFilter
   {
      
      private static var _inited:Boolean = false;
      
      private static var _filters:Array;
      
      private static var _data:Object;
      
      private static var _filtList:Array;
      
      private static var _simpFiltList:Array;
       
      
      public function MessageFilter()
      {
         super();
      }
      
      public static function load(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,filtersLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,loadingFailed);
         _loc2_.load(new URLRequest(param1));
      }
      
      private static function filtersLoaded(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            _data = com.adobe.serialization.json.JSON.decode((e.target as URLLoader).data);
         }
         catch(e:Error)
         {
         }
         init();
      }
      
      private static function loadingFailed(param1:IOErrorEvent) : void
      {
      }
      
      private static function init() : void
      {
         var i:int = 0;
         var token:String = null;
         var regExp:RegExp = null;
         var t:String = replaceWords(_data["filtData"]);
         var tmp:Array = t.split(/#/);
         _filtList = new Array();
         _simpFiltList = new Array();
         var l:int = tmp.length;
         i = 0;
         while(i < l)
         {
            token = tmp[i];
            if(!StringUtil.startsWith(token,".*") && !StringUtil.startsWith(token,"^"))
            {
               token = "\\b" + token;
            }
            if(!StringUtil.endsWith(token,".*") && !StringUtil.endsWith(token,"$"))
            {
               token = token + "\\b";
            }
            try
            {
               regExp = new RegExp(token,"i");
               if(!regExp.test("abc"))
               {
                  _filtList.push(regExp);
               }
            }
            catch(e:Error)
            {
            }
            i++;
         }
         initArray(_data["simpFiltData"],_simpFiltList);
         _inited = true;
      }
      
      private static function initArray(param1:String, param2:Array) : void
      {
         var i:int = 0;
         var r:RegExp = null;
         var t:String = param1;
         var arr:Array = param2;
         t = replaceWords(t);
         var tmp:Array = t.split(/#/);
         var l:int = tmp.length;
         i = 0;
         while(i < l)
         {
            try
            {
               r = new RegExp(tmp[i],"i");
               if(!r.test("abc"))
               {
                  arr.push(r);
               }
            }
            catch(e:Error)
            {
            }
            i++;
         }
      }
      
      private static function replaceWords(param1:String) : String
      {
         param1 = param1.replace(/WORDPUSSY/g,_data["wordpussy"]);
         param1 = param1.replace(/WORDWANT/g,_data["wordwant"]);
         param1 = param1.replace(/WORDUNDERWEAR/g,_data["wordunderwear"]);
         param1 = param1.replace(/WORDBREAST/g,_data["wordbreast"]);
         param1 = param1.replace(/WORDPIC/g,_data["wordpic"]);
         param1 = param1.replace(/WORDNAKED/g,_data["wordnaked"]);
         return param1.replace(/WORDPENIS/g,_data["wordpenis"]);
      }
      
      private static function reportMatch(param1:int, param2:String, param3:String) : void
      {
      }
      
      public static function filter(param1:String) : String
      {
         var _loc5_:int = 0;
         if(!_inited)
         {
            return null;
         }
         var _loc2_:String = param1;
         param1 = StringUtil.simplify(param1);
         var _loc3_:String = param1.replace(/([a-z])([A-Z])/g,"$1 $2");
         var _loc4_:String = param1.replace(/[^a-zA-Z0-9]/g,"");
         var _loc6_:int = _filtList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_filtList[_loc5_].test(param1) || _filtList[_loc5_].test(_loc3_))
            {
               reportMatch(1,_filtList[_loc5_],_loc2_);
               return _filtList[_loc5_];
            }
            _loc5_++;
         }
         _loc6_ = _simpFiltList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_simpFiltList[_loc5_].test(_loc4_) || _simpFiltList[_loc5_].test(param1))
            {
               reportMatch(2,_simpFiltList[_loc5_],_loc2_);
               return _simpFiltList[_loc5_];
            }
            _loc5_++;
         }
         return null;
      }
   }
}
