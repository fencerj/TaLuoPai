//
//  HelloWorldLayer.mm
//  TaLuoPai
//
//  Created by Ivan on 13-6-5.
//  Copyright Ivan 2013年. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "GB2ShapeCache.h"

enum {
	kTagParentNode = 1,
};
int sceneIdx=7;
int B2FrameCount[22] = {0,0,2,4,2,1,2,1,5,2,3,3,2,3,1,2,1,1,1,4,1,4};
#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
+(CCScene *) sceneOther
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initOther] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) initOther
{
	if( (self=[super init])) {
		
		// enable events
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		// init physics
		[self initPhysics];
		
        
        CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d_bg.jpg",sceneIdx+1]];
        bg.position = ccp(s.width/2,s.height/2);
        [self addChild:bg z:-1];
        
        if (sceneIdx>4)
        {
            CCSprite *migongSpr = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%02d_map_color.png",sceneIdx+1]];
            
            migongSpr.position = ccp(s.width/2,s.height/2);
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"b2_kuang_1.plist"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"b2_kuang_2.plist"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"b2_kuang_3.plist"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"b2_kuang_4.plist"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"b2_kuang_5.plist"];
            b2BodyDef bodyDef;
            bodyDef.type = b2_kinematicBody;
            bodyDef.userData = migongSpr;
            bodyDef.position.Set(migongSpr.position.x/32.0,migongSpr.position.y/32.0 );
            b2Body *body = world->CreateBody(&bodyDef);
            
            for (int i = 1; i <= B2FrameCount[(sceneIdx+1)/2-1]; i++) {
                [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:[NSString stringWithFormat:@"%02d_map_kuang_%d",sceneIdx+1,i]];
            }
            
            [migongSpr setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:[NSString stringWithFormat:@"%02d_map_kuang_1",sceneIdx+1]]];
            [self addChild:migongSpr z:-1];

        }
        if (sceneIdx==3) {
            [self addBall];
        }
        [self addBall];
        [self addHoll];
		[self scheduleUpdate];
	}
	return self;
}
-(void)addBall
{
    
    CCSprite *ball = [CCSprite spriteWithFile:@"qiu_hong.png"];
    ball.position = ccp(100,900);
    ball.userData = @"ball";
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(ball.position.x/PTM_RATIO, ball.position.y/PTM_RATIO);
    bodyDef.userData = ball;
    b2Body *bodyC;
    bodyC = world->CreateBody(&bodyDef);
    
    
    b2CircleShape circle;
    circle.m_radius = ball.contentSize.width/2.35/PTM_RATIO;
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 3.0f;
    fixtureDef.friction = 5.0;
    fixtureDef.restitution = 0;
    fixtureDef.userData = @"ball";
    bodyC->CreateFixture(&fixtureDef);
    bodyC->ApplyForceToCenter(b2Vec2(10,0));
    
    [self addChild:ball z:-1 ];
}

-(void)addHoll
{
    
    CCSprite *ball = [CCSprite spriteWithFile:@"dong_color.png"];
    ball.position = ccp(384,512);
    //ball.userData = @"ball";
    b2BodyDef bodyDef;
    bodyDef.type = b2_kinematicBody;
    
    bodyDef.position.Set(ball.position.x/PTM_RATIO, ball.position.y/PTM_RATIO);
    bodyDef.userData = ball;
    b2Body *bodyC;
    bodyC = world->CreateBody(&bodyDef);
    
    
    b2CircleShape circle;
    circle.m_radius = ball.contentSize.width/3.3/PTM_RATIO;
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 3.0f;
    fixtureDef.friction = 5.0;
    fixtureDef.restitution = 0;
    fixtureDef.userData = @"holl";
    bodyC->CreateFixture(&fixtureDef);
    //bodyC->ApplyForceToCenter(b2Vec2(10,0));
    
    [self addChild:ball z:-1 ];
}
-(id) init
{
	if( (self=[super init])) {
        
      
        
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        unLocked = [defaults boolForKey:[NSString stringWithFormat:@"unlocked%d",(sceneIdx+1)/2]];
         CGSize screenSize = [[CCDirector sharedDirector] winSize];
        if (!unLocked) {
           
            self.touchEnabled = NO;
            CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d_bg.jpg",sceneIdx+1]];
            CCSprite *text = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%02d_ch.png",sceneIdx+1]];
            bg.position = ccp(screenSize.width/2,screenSize.height/2);
            text.position = ccp(screenSize.width/2,screenSize.height/2);
            [self addChild:bg z:0];
            [self addChild:text z:0];
            
            CCMenuItemImage *item = [CCMenuItemImage itemWithNormalImage:@"tu_game1.png" selectedImage:@"tu_game2.png" block:^(id sender){
                CCScene *scene = [CCScene node];
                HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initOther] autorelease];
                [scene addChild:layer ];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccc3(255, 255, 255)]];
            } ];
            
            item.position = ccp(screenSize.width/2,268-item.contentSize.height/2);
            CCMenu *menu = [CCMenu menuWithItems:item, nil];
            menu.position = CGPointZero;
            [self addChild:menu z:1];
        }
        else{
             CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%d_done.jpg",sceneIdx]];
             bg.position = ccp(screenSize.width/2,screenSize.height/2);
            [self addChild:bg z:1];
            
            self.touchEnabled = YES;
        }
       
        
	}
	return self;
}
-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];

	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	isBox2d = YES;
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(false);
	world->SetContinuousPhysics(true);
	
	
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	_contactListener = new MyContactListener();
    world->SetContactListener(_contactListener);
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	if (isBox2d) {
        ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
        
        kmGLPushMatrix();
        
        
        world->DrawDebugData();
        
        kmGLPopMatrix();
    }

}

-(void) addNewSpriteAtPosition:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	

	CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:sprite];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];

}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
	
	
	std::vector<MyContact>::iterator pos;
	for(pos = _contactListener->_contacts.begin();
		pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        b2Body *bodyB = contact.fixtureB->GetBody();
        b2Body *bodyA = contact.fixtureA->GetBody();
        CCSprite *sprA = (CCSprite*)(bodyA->GetUserData());
        CCSprite *sprB = (CCSprite*)(bodyB->GetUserData());
        NSString *fixtureIdA = (NSString*)(contact.fixtureA->GetUserData());
		NSString *fixtureIdB = (NSString*)(contact.fixtureB->GetUserData());
        if ([fixtureIdA isEqualToString:@"ball"] && [fixtureIdB isEqualToString:@"holl"] ) {
            CCLOG(@"inTheHoll");
            
            world->DestroyBody(bodyA);
            [sprA runAction:[CCSequence actions:[CCEaseBounceIn actionWithAction:[CCSpawn actions:[CCMoveTo actionWithDuration:0.3 position:sprB.position],[CCScaleTo actionWithDuration:0.3 scale:0],nil]],[CCCallBlock actionWithBlock:^{
                if (sceneIdx==3) {
                    guidCountBall++;
                    if (guidCountBall==2) {
                        [self showRealPage];
                    }
                }
                else
                {
                    [self showRealPage];
                }
            }],nil]];
            
            //[self unschedule:_cmd];
            break;
            
        }

        if ([fixtureIdB isEqualToString:@"ball"] && [fixtureIdA isEqualToString:@"holl"])
        {
            
            
            world->DestroyBody(bodyB);
            [sprB runAction:[CCSequence actions:[CCEaseBounceIn actionWithAction:[CCSpawn actions:[CCMoveTo actionWithDuration:0.3 position:sprA.position],[CCScaleTo actionWithDuration:0.3 scale:0],nil]],[CCCallBlock actionWithBlock:^{
                if (sceneIdx==3) {
                    guidCountBall++;
                    if (guidCountBall==2) {
                        [self showRealPage];
                    }
                }
                else
                {
                    [self showRealPage];
                }
            }],nil]];
            break;
        }
	}
}
-(void)showRealPage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:[NSString stringWithFormat:@"unlocked%d",(sceneIdx+1)/2]];
    [defaults synchronize];
    
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] init] autorelease];
    [scene addChild:layer ];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5 scene:scene]];
    
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
        if (unLocked) {
            [self nextPage];
        }
	}
}
-(void)nextPage
{
    sceneIdx+=2;
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] init] autorelease];
    [scene addChild:layer ];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene withColor:ccc3(255, 255, 255)]];
}
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity(accelX * 25, accelY * 25);
	
	world->SetGravity( gravity );
}
@end
