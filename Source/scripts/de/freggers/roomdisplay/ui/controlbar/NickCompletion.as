package de.freggers.roomdisplay.ui.controlbar
{
   import de.freggers.roomlib.Player;
   import de.freggers.roomlib.util.WOBRegistry;
   
   class NickCompletion
   {
       
      
      private var nextNicknameIndex:uint = 0;
      
      private var currentPrefix:String = null;
      
      private var currentNickList:Vector.<String>;
      
      private var started:Boolean = false;
      
      function NickCompletion()
      {
         this.currentNickList = new Vector.<String>();
         super();
      }
      
      private static function normalizeWord(param1:String) : String
      {
         return param1.replace(/[^A-Za-z0-9]/g,"").toLowerCase();
      }
      
      public function getNext(param1:String, param2:uint) : String
      {
         var playerIds:Array = null;
         var playerId:int = 0;
         var player:Player = null;
         var currentInput:String = param1;
         var currentCaretIndex:uint = param2;
         if(currentCaretIndex != currentInput.length)
         {
            return currentInput;
         }
         var m:Array = currentInput.match(/(\S+)\s*$/);
         if(!m)
         {
            return currentInput;
         }
         var lastWord:String = m[1];
         var isFirstWord:Boolean = currentInput.lastIndexOf(lastWord) === 0;
         if(!this.started)
         {
            this.currentPrefix = normalizeWord(lastWord);
            playerIds = WOBRegistry.instance.getPlayerIds();
            for each(playerId in playerIds)
            {
               player = WOBRegistry.instance.getPlayerByWobId(playerId);
               this.currentNickList.push(player.name);
            }
            this.currentNickList.sort(function(param1:String, param2:String):int
            {
               if(param1.toLowerCase() < param2.toLowerCase())
               {
                  return -1;
               }
               if(param1.toLowerCase() > param2.toLowerCase())
               {
                  return 1;
               }
               return 0;
            });
            this.started = true;
         }
         var matchingNicknames:Vector.<String> = this.currentNickList.filter(function(param1:String, param2:int, param3:Vector.<String>):Boolean
         {
            var _loc4_:* = normalizeWord(param1);
            return _loc4_.indexOf(currentPrefix) === 0;
         });
         if(matchingNicknames.length === 0)
         {
            return currentInput;
         }
         var foundNickname:String = matchingNicknames[this.nextNicknameIndex];
         this.nextNicknameIndex = (this.nextNicknameIndex + 1) % matchingNicknames.length;
         lastWord = lastWord.replace(/([\[\]\*\.\+])/g,"\\$1");
         var newInput:String = currentInput.replace(new RegExp(lastWord + "\\s*$"),foundNickname + (!!isFirstWord?": ":" "));
         return newInput;
      }
      
      public function stopCompletion() : void
      {
         this.started = false;
         this.nextNicknameIndex = 0;
         this.currentPrefix = null;
         this.currentNickList.splice(0,this.currentNickList.length);
      }
   }
}
