//
//  IntroLayer.m
//  TaLuoPai
//
//  Created by Ivan on 13-6-5.
//  Copyright Ivan 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"

extern BOOL soundFlag;

#pragma mark - IntroLayer
extern int sceneIdx;
// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background = [CCSprite spriteWithFile:@"me_bg.jpg"];

		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
        
        //infoLayer = [CCLayer node];
        infoBg = [CCSprite spriteWithFile:@"me_jieshao_bg.png"];
        infoBg.position = ccp(384,1024-infoBg.contentSize.height/2+533);
        [self addChild:infoBg z:0];
        
        {
            
            
            CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"me_jieshao_maggic.png" selectedImage:@"me_jieshao_maggic.png" block:^(id sender){}];
            item1.position = ccp(110,226);
            CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"me_jieshao_star.png" selectedImage:@"me_jieshao_star.png" block:^(id sender){}];
            item2.position = ccp(641,150);
            
            CCMenu *menu = [CCMenu menuWithItems:item1,item2, nil];
            menu.position = CGPointZero;
            
            [infoBg addChild:menu z:1];
        }
        
        CCSprite *setBar = [CCSprite spriteWithFile:@"me_set.png"];
        setBar.position = ccp(384,1024-setBar.contentSize.height/2);
        [self addChild:setBar z:0];
        
        
        {
            
            //            CCMenuItemToggle *itemSound = [CCMenuItemToggle itemWithTarget:self selector:@selector(mSoundFunc:) items:
            //                                           [CCMenuItemImage itemFromNormalImage:@"me_icon_sound1" selectedImage:@"me_icon_sound1.png"],
            //                                           [CCMenuItemImage itemFromNormalImage:@"me_icon_sound2.png" selectedImage:@"me_icon_sound2.png"],
            //                                           nil];
            //            CCMenu *mSound = [CCMenu menuWithItems:itemSound,nil];
            //            if (soundFlag) {
            //                itemSound.selectedIndex = 0;
            //            }
            //            else {
            //                itemSound.selectedIndex = 1;
            //            }
            //            itemSound.position = ccp(138,86);
            
            
            CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"me_icon_sound1.png" selectedImage:@"me_icon_sound2.png" block:^(id sender){
                
                
            }];
            item1.position = ccp(138,86);
            CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"me_icon_jieshao1.png" selectedImage:@"me_icon_jieshao2.png" block:^(id sender){
                if (!isInfoMoving) {
                    isInfoMoving = YES;
                    if (isShowed) {
                        
                        id b1 = [CCMoveBy actionWithDuration:0.4f position:ccp(0,533)];
                        id b2 = [CCEaseIn actionWithAction:b1 rate:1.7];
                        [infoBg runAction:[CCSequence actionOne:b2 two:[CCCallBlock actionWithBlock:^{
                            isInfoMoving = NO;
                            isShowed = NO;
                        }]]];
                    }
                    else
                    {
                        
                        id b1 = [CCMoveBy actionWithDuration:0.4f position:ccp(0,-533)];
                        id b2 = [CCEaseIn actionWithAction:b1 rate:1.7];
                        [infoBg runAction:[CCSequence actionOne:b2 two:[CCCallBlock actionWithBlock:^{
                            isInfoMoving = NO;
                            isShowed = YES;
                        }]]];
                    }
                }
            }];
            item2.position = ccp(609,86);
            
            CCMenu *menu = [CCMenu menuWithItems:item1,item2, nil];
            menu.position = CGPointZero;
            
            [setBar addChild:menu z:1];
        }
        
        
        
        
        
        CCSprite *waikuang= [CCSprite spriteWithFile:@"me_kuang_1.png"];
        waikuang.position = ccp(384,waikuang.contentSize.height/2);
        
        
        
        CCSprite *neikuang = [CCSprite spriteWithFile:@"me_kuang_2.png"];
        neikuang.position = waikuang.position;
        
        [self addChild:neikuang z:0];
        
        [self addChild:waikuang z:2];
        
        CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:@"me_icon_set1.png" selectedImage:@"me_icon_set1.png" block:^(id sender){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
           
            for (int i = 1; i <=22 ; i++) {
                [defaults setBool:NO forKey:[NSString stringWithFormat:@"unlocked%d",i]];
                
                [defaults synchronize];
            }
            
        }];
        item.position = ccp(394,484);
        CCMenu *menu = [CCMenu menuWithItems:item,nil];
        menu.position=CGPointZero;
        [self addChild:menu z:3];
        
       
        _shareBgLayer = [CCScrollLayer nodeWithLayers:[self scrollLayerPages] widthOffset:
                         500];
        //[_shareBgLayer setContentSize:CGSizeMake(225,300)];
        layHold = [CCLayer node];
        [_shareBgLayer setDelegate:self];
        //_shareBgLayer.position = ccp(384,600);
        
        _shareBgLayer.showPagesIndicator = NO;
        //[self addChild:_shareBgLayer z:1];
        [layHold addChild:_shareBgLayer z:2];
        //layHold.scale = 0.75;
        layHold.position = ccp(100,260);
        [self addChild:layHold z:1];
        
	}
	
	return self;
}
-(void)mSoundFunc:(id)sender
{
    soundFlag = !soundFlag;
	if (soundFlag) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
	else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.mp3"];
    }
}
- (void) scrollLayer: (CCScrollLayer *) sender scrolledToPageNumber: (int) page
{
    //[label setString:[NSString stringWithFormat:@"%d/%d",_shareBgLayer.currentScreen+1,_shareBgLayer.totalScreens]];
    
}
- (NSArray *) scrollLayerPages
{
    //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"clMk_res.plist"];
	//CGSize screenSize = [CCDirector sharedDirector].winSize;
    NSMutableArray *layerArr = [NSMutableArray arrayWithCapacity:40];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:@"" selectedImage:@"" block:^(id sender){
        //to sceneIdx page;
    //}];
    
    
    CCSprite *spr;
    for (int i = 1 ;i<=22 ; i++) {
        
        CCLayer *pageOne = [CCLayerColor layerWithColor:ccc4(255,255,255,0) width:225 height:300];
       
        
        BOOL unlocked =  [defaults boolForKey:[NSString stringWithFormat:@"unlocked%d",i]];
        
        if (unlocked) {
            spr = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%02d_icon_color.png",i*2]];
        }
        else
        {
             spr = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%02d_icon_name.png",i*2]];
        }
        [pageOne addChild:spr z:1];
        spr.position = CGPointZero;
        
        [layerArr addObject:pageOne];
        
        
        CCMenuItem *item  = [CCMenuItem itemWithBlock:^(CCNode *sender){
            CCLOG(@"taped %d",(int)(sender.userData));
            sceneIdx = i*2-1;
            
            CCScene *scene = [CCScene node];
            HelloWorldLayer *layer = [[[HelloWorldLayer alloc] init] autorelease];
            [scene addChild:layer ];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccc3(255, 255, 255)]];
        }];
        [item setContentSize:spr.boundingBox.size];
        item.position = ccp(0,0);
        item.userData = (void*)i;
        CCMenu *menu = [CCMenu menuWithItems:item, nil];
        [pageOne addChild:menu z:1];
        menu.position = CGPointZero;
    }
    return layerArr;
}
-(void) onEnter
{
	[super onEnter];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}
@end
