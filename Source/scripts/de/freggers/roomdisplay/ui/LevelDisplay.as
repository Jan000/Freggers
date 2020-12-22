package de.freggers.roomdisplay.ui
{
   import de.freggers.roomdisplay.data.UserLevelProgress;
   import de.schulterklopfer.interaction.data.MouseManagerData;
   import flash.display.Sprite;
   
   public class LevelDisplay extends Sprite
   {
      
      private static const MARGIN:int = 5;
       
      
      public var onClickCallback:Function;
      
      private var _levelProgress:UserLevelProgress;
      
      private var _progress:LevelProgressBar;
      
      private var _levelLabel:LevelLabel;
      
      private var _lightBulb:Lightbulb;
      
      public function LevelDisplay()
      {
         super();
         this._progress = new LevelProgressBar();
         this._progress.progress = 1;
         addChild(this._progress);
         this._levelLabel = new LevelLabel();
         this._levelLabel.y = 25.1;
         this._levelLabel.x = 25;
         addChild(this._levelLabel);
         this._lightBulb = new Lightbulb();
         this._lightBulb.x = this._progress.x + this._progress.width - this._lightBulb.width / 2;
         this._lightBulb.y = 24.5;
         addChild(this._lightBulb);
         mouseEnabled = true;
         buttonMode = true;
         mouseChildren = false;
      }
      
      public function get progressBarTip() : Sprite
      {
         return this._progress.progressBarTip;
      }
      
      public function resize(param1:Number) : void
      {
         this._progress.resize(param1 - this._lightBulb.width / 2);
         this._lightBulb.x = param1 - this._lightBulb.width;
      }
      
      public function get levelProgress() : UserLevelProgress
      {
         return this._levelProgress;
      }
      
      public function update(param1:UserLevelProgress) : void
      {
         this._levelProgress = param1;
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         this._progress.setRange(0,this._levelProgress.xpTotal);
         this._progress.progress = this._levelProgress.xpCurrent / this._levelProgress.xpTotal;
         this._progress.xpCap = this._levelProgress.xpCap;
         this._levelLabel.value = this._levelProgress.level;
      }
      
      public function handleMouseManagerData(param1:MouseManagerData) : void
      {
         if(param1.type != MouseManagerData.CLICK)
         {
            return;
         }
         if(this.onClickCallback != null)
         {
            this.onClickCallback();
         }
      }
   }
}

import caurina.transitions.Tweener;
import de.freggers.ui.AProgressBar;
import de.freggers.util.GraphicsUtil;
import de.freggers.util.RectangleSprite;
import flash.display.BlendMode;
import flash.display.CapsStyle;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.utils.Timer;

class LevelProgressBar extends AProgressBar
{
   
   private static const BACKGROUND_POSITION_X:Number = 25;
   
   private static const BACKGROUND_POSITION_Y:Number = 10.5;
   
   private static const FOREGROUND_POSITION_X:Number = 42;
   
   private static const FOREGROUND_POSITION_Y:Number = 15.3;
   
   private static const FOREGROUND_OFFSET_RIGHT:Number = FOREGROUND_POSITION_X - BACKGROUND_POSITION_X;
   
   private static const FOREGROUND_OFFSET_LEFT:Number = 7.2;
   
   private static const TOTAL_TIME:int = 32000;
   
   private static const GLOW_FADEIN_DURATION:int = 200;
   
   private static const GLOW_FADEOUT_DURATION:int = 2000;
   
   private static const TWEEN_BAR_ANIMATE:String = "animate";
   
   private static const TWEEN_GLOW_START:String = "glow start";
   
   private static const TWEEN_GLOW_END:String = "glow end";
   
   private static const SEGMENT_COUNT:int = 20;
    
   
   private var _background:LevelProgressBackground;
   
   private var _capDisplay:DisplayObject;
   
   private var _foregroundMask:RectangleSprite;
   
   private var _foreground:DisplayObject;
   
   private var _timer:Timer;
   
   private var _glowEffect:GlowFilter;
   
   private var _capValue:int = 0;
   
   private var _segmentsOverlay:Sprite;
   
   private var _progressBarTip:Sprite;
   
   function LevelProgressBar()
   {
      this._timer = new Timer(33);
      super();
      this._background = new LevelProgressBackground();
      this._background.x = BACKGROUND_POSITION_X;
      this._background.y = BACKGROUND_POSITION_Y;
      addChild(this._background);
      this._foreground = new LevelProgress();
      this._foreground.x = FOREGROUND_POSITION_X;
      this._foreground.y = FOREGROUND_POSITION_Y;
      this._foreground.cacheAsBitmap = true;
      addChild(this._foreground);
      this._segmentsOverlay = new Sprite();
      this._segmentsOverlay.x = FOREGROUND_POSITION_X;
      this._segmentsOverlay.y = FOREGROUND_POSITION_Y;
      this._segmentsOverlay.blendMode = BlendMode.MULTIPLY;
      addChild(this._segmentsOverlay);
      this._foregroundMask = new RectangleSprite(this._foreground.width,this._foreground.height);
      this._foregroundMask.x = FOREGROUND_POSITION_X;
      this._foregroundMask.y = FOREGROUND_POSITION_Y;
      this._foregroundMask.cacheAsBitmap = true;
      addChild(this._foregroundMask);
      this._foreground.mask = this._foregroundMask;
      this._capDisplay = new LevelProgressCap();
      addChild(this._capDisplay);
      this._capDisplay.x = this._foregroundMask.x;
      this._capDisplay.y = this._foregroundMask.y + (this._foregroundMask.height - this._capDisplay.height) / 2;
      this._capDisplay.visible = false;
      _width = this._foregroundMask.width;
      _height = this._foregroundMask.height;
      this.drawSegmentsOverlay();
      this._glowEffect = new GlowFilter(7922943,0,20,20,1);
      this._foreground.filters = [this._glowEffect];
      this._progressBarTip = new Sprite();
      this._progressBarTip.width = this._progressBarTip.height = 1;
      this._progressBarTip.x = this._foregroundMask.x + this._foregroundMask.width;
      this._progressBarTip.y = this._foregroundMask.y + this._foregroundMask.height / 2;
      addChild(this._progressBarTip);
   }
   
   public function get progressBarTip() : Sprite
   {
      return this._progressBarTip;
   }
   
   public function set xpCap(param1:int) : void
   {
      if(param1 == this._capValue)
      {
         return;
      }
      this._capValue = param1;
      if(this._capValue == endValue)
      {
         this._capDisplay.visible = false;
      }
      else
      {
         this._capDisplay.visible = true;
         this.updateXpCapPosition();
      }
   }
   
   private function updateXpCapPosition() : void
   {
      this._capDisplay.x = this._foreground.x + this._foreground.width * (this._capValue / (endValue - startValue));
   }
   
   private function drawSegmentsOverlay() : void
   {
      var _loc1_:Number = this._foreground.width / SEGMENT_COUNT;
      var _loc2_:Point = new Point();
      var _loc3_:Point = new Point();
      _loc2_.y = -1;
      _loc3_.y = this._foreground.height + 7;
      var _loc4_:Graphics = this._segmentsOverlay.graphics;
      _loc4_.clear();
      var _loc5_:int = 1;
      while(_loc5_ < SEGMENT_COUNT)
      {
         _loc2_.x = _loc3_.x = _loc5_ * _loc1_;
         if(_loc5_ % 2 == 1)
         {
            GraphicsUtil.drawDashedLine(_loc4_,_loc2_,_loc3_,4278190080,0.8,0.5,0.7,4,CapsStyle.NONE);
         }
         else
         {
            GraphicsUtil.drawDashedLine(_loc4_,_loc2_,_loc3_,4278190080,0.8,0.5,1.5,3,CapsStyle.NONE);
         }
         _loc5_++;
      }
   }
   
   public function resize(param1:Number) : void
   {
      this._background.width = param1 - BACKGROUND_POSITION_X;
      this._foreground.width = this._background.width - FOREGROUND_OFFSET_LEFT - FOREGROUND_OFFSET_RIGHT;
      this._foregroundMask.handleResize(this._foreground.width,this._foreground.height);
      this.drawSegmentsOverlay();
      if(this._capDisplay.visible)
      {
         this.updateXpCapPosition();
      }
      this._progressBarTip.x = this._foregroundMask.x + this._foregroundMask.width;
   }
   
   override protected function updateContents() : void
   {
      var _loc1_:Number = NaN;
      var _loc2_:Number = NaN;
      if(this._foregroundMask.scaleX > progress)
      {
         Tweener.removeTweens(this._foregroundMask,"scaleX");
         Tweener.removeTweens(this._progressBarTip,"x");
         this._foregroundMask.scaleX = progress;
         this._progressBarTip.x = this._foregroundMask.x + this._foregroundMask.width;
      }
      else
      {
         _loc1_ = progress - this._foregroundMask.scaleX;
         if(_loc1_ > 0)
         {
            _loc2_ = TOTAL_TIME * _loc1_ / 1000;
            Tweener.addTween(this._progressBarTip,{
               "x":this._foreground.x + this._foreground.width * progress,
               "time":_loc2_
            });
            Tweener.addTween(this._foregroundMask,{
               "scaleX":progress,
               "time":_loc2_
            });
            Tweener.addTween(this._glowEffect,{
               "alpha":1,
               "time":Math.min(GLOW_FADEIN_DURATION,TOTAL_TIME * _loc1_) / 1000,
               "onComplete":this.__glowStartComplete,
               "onUpdate":this.__updateGlowFilter
            });
         }
      }
   }
   
   private function __glowStartComplete() : void
   {
      Tweener.addTween(this._glowEffect,{
         "alpha":0,
         "time":GLOW_FADEOUT_DURATION / 1000,
         "onComplete":this.__glowEndComplete,
         "onUpdate":this.__updateGlowFilter
      });
   }
   
   private function __glowEndComplete() : void
   {
      this._foreground.filters = null;
   }
   
   private function __updateGlowFilter() : void
   {
      this._foreground.filters = [this._glowEffect];
   }
}

import de.freggers.roomlib.util.StyleSheetBuilder;
import de.freggers.util.BitmapDataUtils;
import de.freggers.util.TextRenderer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.text.StyleSheet;

class LevelLabel extends Sprite
{
   
   private static const TEXT_STYLE:StyleSheet = new StyleSheetBuilder(".number").add("fontSize",30).add("fontWeight","bold").add("fontFamily","Arial,Helvetica,Verdana,\'Lucida Grande\',sans-serif").add("color","#40210B").build();
   
   private static const MAX_WIDTH:int = 26;
   
   private static const MAX_HEIGHT:int = 26;
    
   
   private var _currentLevel:int = 0;
   
   private var _label:Bitmap;
   
   function LevelLabel()
   {
      super();
      addChild(new LevelLabelBackground());
      this._label = new Bitmap(null,PixelSnapping.ALWAYS,true);
      addChild(this._label);
      this.render();
   }
   
   public function set value(param1:int) : void
   {
      if(param1 == this._currentLevel)
      {
         return;
      }
      this._currentLevel = param1;
      this.render();
   }
   
   private function render() : void
   {
      var _loc2_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc4_:Number = NaN;
      var _loc1_:BitmapData = TextRenderer.renderToBitmap("<span class=\'number\'>" + this._currentLevel + "</span>",TEXT_STYLE,0,false);
      if(_loc1_.width > MAX_WIDTH || _loc1_.height > MAX_HEIGHT)
      {
         _loc2_ = MAX_WIDTH / _loc1_.width;
         _loc3_ = MAX_HEIGHT / _loc1_.height;
         if(_loc2_ > _loc3_)
         {
            _loc4_ = _loc3_;
         }
         else
         {
            _loc4_ = _loc2_;
         }
         _loc1_ = BitmapDataUtils.scale(_loc1_,_loc4_,_loc4_);
      }
      this._label.bitmapData = _loc1_;
      this._label.x = -this._label.width / 2;
      this._label.y = -this._label.height / 2;
   }
}
