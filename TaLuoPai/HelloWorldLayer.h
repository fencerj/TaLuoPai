//
//  HelloWorldLayer.h
//  TaLuoPai
//
//  Created by Ivan on 13-6-5.
//  Copyright Ivan 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "MyContactListener.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "AppDelegate.h"
#import "IntroLayer.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer 
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    CCScene *preScene;
	CCScene *nextScene;
    BOOL isTextPage;
    BOOL unLocked;
    BOOL isNextAllow;
    BOOL isBox2d;
    MyContactListener *_contactListener;
    int guidCountBall;
    BOOL isInPic;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *) sceneOther;
+(CCScene *) scenePic;
-(id) initPicture;
+ (NSInteger)createRandomsizeValueInt:(NSInteger)fromInt toInt:(NSInteger)toInt;

+ (double)createRandomsizeValueFloat:(double)fromFloat toFloat:(double)toFloat;

@end



