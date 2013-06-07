//
//  IntroLayer.h
//  TaLuoPai
//
//  Created by Ivan on 13-6-5.
//  Copyright Ivan 2013年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import <Foundation/Foundation.h>
// HelloWorldLayer
@interface IntroLayer : CCLayer<CCScrollLayerDelegate>
{
    CCLayer *infoLayer;
    
    CCLayer *selectLayer;
    CCSprite *infoBg;
    BOOL isInfoMoving;
    BOOL isShowed;
    
    CCScrollLayer *_shareBgLayer;
    CCLayerColor *layHold;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
