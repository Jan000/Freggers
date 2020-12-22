package de.freggers.roomdisplay.ui.controlbar
{
   import de.freggers.roomdisplay.ControlsEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   
   public final class InputDelegate
   {
      
      private static const IDLE_TIME:Number = 3000;
      
      private static const HISTORY_SIZE:int = 40;
      
      private static const COMPOSING_UNKNOWN:int = -1;
      
      private static const COMPOSING_START:int = 1;
      
      private static const COMPOSING_IDLE:int = 2;
      
      private static const COMPOSING_STOP:int = 0;
       
      
      private var _composingStatus:int;
      
      private var _composingTimer:int;
      
      private var _input:MovieClip;
      
      private var _history:Array;
      
      private var _historyIndex:int;
      
      private var _lastTyped:String;
      
      private var _textField:TextField;
      
      private var _mask:MovieClip;
      
      private var _background:MovieClip;
      
      private var _hint:MovieClip;
      
      private var _killring:String;
      
      private var nickCompletion:NickCompletion;
      
      public function InputDelegate(param1:MovieClip)
      {
         super();
         this.init(param1);
      }
      
      private static function isValidInput(param1:MovieClip) : Boolean
      {
         return param1["background"] != null && param1["textField"] != null && param1["mask"] != null && param1["hint"] != null;
      }
      
      private static function trim(param1:String, param2:String) : String
      {
         return trimBack(trimFront(param1,param2),param2);
      }
      
      private static function trimFront(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(0) == param2)
         {
            param1 = trimFront(param1.substring(1),param2);
         }
         return param1;
      }
      
      private static function trimBack(param1:String, param2:String) : String
      {
         param2 = stringToCharacter(param2);
         if(param1.charAt(param1.length - 1) == param2)
         {
            param1 = trimBack(param1.substring(0,param1.length - 1),param2);
         }
         return param1;
      }
      
      private static function stringToCharacter(param1:String) : String
      {
         if(param1.length == 1)
         {
            return param1;
         }
         return param1.slice(0,1);
      }
      
      private function init(param1:MovieClip) : void
      {
         if(!isValidInput(param1))
         {
            throw new Error("InputDelegate: input view failed structure test");
         }
         this._input = param1;
         this._history = new Array();
         this._historyIndex = -1;
         this.nickCompletion = new NickCompletion();
         this._textField = param1["textField"];
         this._background = param1["background"];
         this._mask = param1["mask"];
         this._hint = param1["hint"];
         this._hint.mouseEnabled = this._hint.mouseChildren = false;
         this._textField.restrict = "^\x01\x05\x0b\x19";
         this._textField.multiline = false;
         this._textField.wordWrap = false;
         this._textField.cacheAsBitmap = true;
         this._textField.addEventListener(FocusEvent.FOCUS_IN,this.handleTextFieldFocus);
         this._textField.addEventListener(FocusEvent.FOCUS_OUT,this.handleTextFieldFocus);
         this._textField.defaultTextFormat = new TextFormat("Arial",13,2039583,true);
         this._textField.maxChars = 255;
         this._hint.mouseEnabled = this._hint.mouseChildren = false;
      }
      
      private function handleTextFieldFocus(param1:FocusEvent) : void
      {
         if(param1.type == FocusEvent.FOCUS_IN)
         {
            this._background.gotoAndStop("enabled");
            this._textField.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyboard);
            this._textField.addEventListener(Event.CHANGE,this.handleTextFieldChanged);
            this._textField.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.handleFocusChanged);
            this._hint.visible = false;
         }
         else if(param1.type == FocusEvent.FOCUS_OUT)
         {
            this._background.gotoAndStop("disabled");
            this._textField.removeEventListener(KeyboardEvent.KEY_UP,this.handleKeyboard);
            this._textField.removeEventListener(Event.CHANGE,this.handleTextFieldChanged);
            this._textField.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.handleFocusChanged);
            this._hint.visible = true && this._textField.text.length == 0;
         }
      }
      
      private function handleFocusChanged(param1:FocusEvent) : void
      {
         param1.preventDefault();
      }
      
      private function handleTextFieldChanged(param1:Event) : void
      {
         var _loc2_:int = COMPOSING_UNKNOWN;
         this._composingTimer = getTimer();
         this._textField.text = trimFront(this._textField.text," ");
         if(this._textField.text.length == 0 || this._textField.text == "")
         {
            _loc2_ = COMPOSING_STOP;
         }
         else
         {
            _loc2_ = COMPOSING_START;
         }
         if(this._composingStatus != _loc2_ && _loc2_ != COMPOSING_UNKNOWN)
         {
            this._composingStatus = _loc2_;
            this.onComposing(_loc2_);
         }
      }
      
      private function handleKeyboard(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey)
         {
            if(param1.charCode == 1)
            {
               this._textField.setSelection(0,0);
            }
            else if(param1.charCode == 5)
            {
               this._textField.setSelection(this._textField.text.length,this._textField.text.length);
            }
            else if(param1.charCode == 11)
            {
               this._killring = this._textField.text.substring(this._textField.caretIndex,this._textField.text.length);
               this._textField.text = this._textField.text.substr(0,this._textField.caretIndex);
            }
            else if(param1.charCode == 25)
            {
               if(this._killring)
               {
                  this._textField.appendText(this._killring);
                  this._textField.setSelection(this._textField.text.length,this._textField.text.length);
               }
            }
         }
         else if(!param1.ctrlKey && !param1.shiftKey)
         {
            if(param1.keyCode == Keyboard.UP)
            {
               if(this._historyIndex >= this._history.length || this._historyIndex >= HISTORY_SIZE)
               {
                  return;
               }
               if(this._historyIndex < 0)
               {
                  this._lastTyped = this._textField.text;
               }
               this._historyIndex++;
               if(this._historyIndex >= this._history.length || this._historyIndex >= HISTORY_SIZE)
               {
                  this._historyIndex = this._history.length - 1;
               }
               if(this._historyIndex >= 0)
               {
                  this._textField.text = this._history[this._historyIndex];
                  this.handleTextFieldChanged(null);
               }
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               if(this._historyIndex < 0)
               {
                  return;
               }
               this._historyIndex--;
               if(this._historyIndex < 0)
               {
                  this._textField.text = this._lastTyped;
               }
               else
               {
                  this._textField.text = this._history[this._historyIndex];
               }
               this.handleTextFieldChanged(null);
            }
            else if(param1.keyCode == Keyboard.TAB)
            {
               this._textField.text = this.nickCompletion.getNext(this._textField.text,this._textField.caretIndex);
               this._textField.setSelection(this._textField.text.length,this._textField.text.length);
            }
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(!this._textField.text || this._textField.text.length == 0)
            {
               if(this._input != null && this._input.stage != null)
               {
                  this._input.stage.focus = null;
               }
               return;
            }
            this.inputComplete(trim(this._textField.text," "));
         }
         if(param1.keyCode != Keyboard.TAB)
         {
            this.nickCompletion.stopCompletion();
         }
      }
      
      private function inputComplete(param1:String) : void
      {
         if(!param1 || param1.length == 0)
         {
            return;
         }
         this.appendHistory(param1);
         this._lastTyped = "";
         this._textField.text = this._lastTyped;
         this._composingStatus = COMPOSING_STOP;
         this.onComposing(this._composingStatus);
         this._input.dispatchEvent(new ControlsEvent(ControlsEvent.INPUT_COMPLETE));
      }
      
      private function appendHistory(param1:String) : void
      {
         this._historyIndex = -1;
         this._history.unshift(param1);
         if(this._history.length > HISTORY_SIZE)
         {
            this._history.length = HISTORY_SIZE;
         }
      }
      
      public function get lastinput() : String
      {
         if(this._history == null || this._history.length == 0)
         {
            return null;
         }
         return this._history[0];
      }
      
      public function get textField() : TextField
      {
         return this._textField;
      }
      
      public function update(param1:int) : void
      {
         if(this._textField.text.length > 0 && this._composingTimer > 0 && param1 >= this._composingTimer + IDLE_TIME)
         {
            if(this._composingStatus != COMPOSING_IDLE)
            {
               this._composingStatus = COMPOSING_IDLE;
               this.onComposing(this._composingStatus);
               this._composingTimer = param1;
            }
         }
      }
      
      public function onComposing(param1:int) : void
      {
         switch(param1)
         {
            case COMPOSING_IDLE:
               this._input.dispatchEvent(new ControlsEvent(ControlsEvent.COMPOSING_IDLE));
               break;
            case COMPOSING_STOP:
               this._input.dispatchEvent(new ControlsEvent(ControlsEvent.COMPOSING_STOP));
               break;
            case COMPOSING_START:
               this._input.dispatchEvent(new ControlsEvent(ControlsEvent.COMPOSING_START));
         }
      }
   }
}
