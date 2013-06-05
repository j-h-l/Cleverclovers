//
//  CloverfieldLayer.m
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/26/13.
//  Copyright Jeehyung Lee 2013. All rights reserved.
//


// Import the interfaces
#import "CloverfieldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#define TOUCH_RADIUS 20
#define OVERLAP_RADIUS 15
#define NUMBER_OF_TOUCHABLES 100 // 100 for full screen does well (for now)
//Think about enum-ing these tags
#define kBatchNode 1
#define kClovers 2

#define POUCHTAG 9
#define kSelectedLayer 10

#pragma mark - CloverfieldLayer

// CloverfieldLayer implementation
@implementation CloverfieldLayer

// Helper class method that creates a Scene with the CloverfieldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CloverfieldLayer *layer = [CloverfieldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    self = [super init];
	if (self) {
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Cloverfield" fontName:@"Marker Felt" fontSize:64];
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		// add the label as a child to this Layer
		[self addChild: label];
		
        // Cloverfield
        self.clovers = [CCSpriteBatchNode batchNodeWithFile:@"cloverfield_wpouch.png"];
        [self addChild:self.clovers z:1 tag:kBatchNode];
        
        self.touchArray = [[NSMutableArray alloc] initWithCapacity:2];
        [self setTouchEnabled:YES];
        
        [self initTouchables];
        [self addInventoryButton];
	}
	return self;
}

-(void) initTouchables{
    for (int i = 0 ; i < NUMBER_OF_TOUCHABLES ; i++) {
//        Clover *tempclove = [[Clover alloc] initWithBatchNode:self.clovers rect:CGRectMake(0, 25, 49, 50)];
//        CGImageRef image = CGImageCreateWithPNGDataProvider(@"cloverfield_wpouch.png", NULL, NO, kCGRenderingIntentDefault);
//        CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"cloverfield_wpouch.png"];
        CCSpriteBatchNode *batch = self.clovers;
        NSLog(@"Size of texture: %f by %f", batch.contentSize.width, batch.contentSize.height);
        Clover *tempclove = [[Clover alloc] initWithTexture:batch.texture rect:CGRectMake(0,12,25,25)];
        tempclove = [self fixOverlap:tempclove within:self.clovers];
        [self.clovers addChild:tempclove z:1 tag:kClovers];
    }
}

-(BOOL)checkForOverlap:(Clover *)temp within:(CCSpriteBatchNode *)fieldInQuestion {
    BOOL positive = false;
    if ([fieldInQuestion.children count] >= 2) {
        for (Clover *check in fieldInQuestion.children) {
//            CGFloat dist = [self calculateDistance:temp.position wrtOther:check.position];
            CGFloat dist = ccpDistance(temp.position, check.position);
//            NSLog(@"My function vs provided function. Dist: %f, Quicker: %f", dist, quicker);
            if (dist < OVERLAP_RADIUS) {
                positive = true;
            }
        }
    }
    
    return positive;
}

-(Clover *)fixOverlap:(Clover *)toFix within:(CCSpriteBatchNode *)fieldInQuestion {
    BOOL positive = [self checkForOverlap:toFix within:fieldInQuestion];
    if (positive) {
        [toFix randomizePosition];
        [self fixOverlap:toFix within:fieldInQuestion];
    }
    return toFix;
}

// Do not need, just use ccpDistance provided by cocos2d - exactly the same
//- (CGFloat) calculateDistance:(CGPoint)aPoint wrtOther:(CGPoint)other{
//    CGFloat dx, dy;
//    dx = aPoint.x - other.x;
//    dy = aPoint.y - other.y;
//    return sqrt(dx*dx + dy*dy);
//}

-(void) addInventoryButton {
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenu *inventoryMenu = [CCMenu menuWithItems:nil];
    CCSprite *red = [CCSprite spriteWithFile:@"cloverfield_wpouch.png" rect:CGRectMake(12, 0, 12, 12)];
    CCSprite *blue = [CCSprite spriteWithFile:@"cloverfield_wpouch.png" rect:CGRectMake(0, 0, 12, 12)];
    //red.position = ccp(s.width - 24, 24/2);
    CCMenuItemImage *redbutton = [CCMenuItemImage itemWithNormalSprite:red selectedSprite:blue target:self selector:@selector(toggleInventory)];
    //redbutton.position = ccp(s.width - 50, 24/2);
    inventoryMenu.position = ccp(0,0); // needed so that button can be placed in the corner
    redbutton.position = ccp(size.width - 12, 12); // bottom right corner
    [inventoryMenu addChild:redbutton];
    [self addChild:inventoryMenu z:5];
    if ([self getChildByTag:POUCHTAG] == nil) {
        Pouch *p = [Pouch sharedPouch];
        [self addChild:p z:4 tag:POUCHTAG];
    }
}

-(void) toggleInventory {
    id showpouch = [CCMoveBy actionWithDuration:.5 position:ccp(-125,0)];
    id hidepouch = [CCMoveBy actionWithDuration:.5 position:ccp(125,0)];
    Pouch *childPouch = (Pouch *)[self getChildByTag:POUCHTAG];
    
    if (childPouch.hidden == true) {
        [childPouch runAction:showpouch];
        childPouch.hidden = false;
    }
    else {
        [childPouch runAction:hidepouch];
        childPouch.hidden = true;
    }
}


#pragma mark - Touch Delegate methods
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // TODO Look into "time-delayed" touches - consolidating events and their contained touches
    NSSet *touchesFromEvent = [event allTouches];
    NSArray *arrayTouches = [touchesFromEvent allObjects];
    
    // firstPoint is not used, just learning how to pick out touches
//    UITouch *firstTouch = [arrayTouches objectAtIndex:0];
//    CGPoint firstPoint = [firstTouch locationInView:[firstTouch view]];
//    firstPoint = [[CCDirector sharedDirector] convertToGL:firstPoint];
    
    // TODO Use triple touch to move the field
    if ([arrayTouches count] == 3) {
        for (Clover *c in self.clovers.children) {
            c.touchHash = 0;     // when there are 3 or more touches we do not keep track of each touch
            c.gState = kUngrabbed;
            // will need to process "plucking" later
        }
    }
    if ([arrayTouches count] < 3) {
        for (UITouch *t in arrayTouches) {
            CGPoint point = [t locationInView:[t view]];
            point = [[CCDirector sharedDirector] convertToGL:point];
            // for each touch t figure out which is grabbed
            for (Clover *c in self.clovers.children) {
                CGFloat dist = ccpDistance(c.position, point);
                if (dist < TOUCH_RADIUS) {
                    c.touchHash = [t hash];  // hash returns unique integer used to keep track of each touch
                    c.gState = kGrabbed;
                    NSNumber *cInt = [NSNumber numberWithUnsignedInteger:[self.clovers.children indexOfObject:c]];
                    [self.touchArray addObject:cInt];
                }
            }
        }
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] < 3) {
        for (UITouch *touch in touches) {
            for (NSNumber *h in self.touchArray) {
                // grab clover indexed in touchArray and update its position
                Clover *clover = [self.clovers.children objectAtIndex:[h unsignedIntValue]];
                if (clover.touchHash == [touch hash]) {
                    CGPoint point = [touch locationInView:[touch view]];
                    point = [[CCDirector sharedDirector] convertToGL:point];
                    // Continually setting the point is faster than
                    // using "action" to move - animation delays the movement
                    clover.position = point;
                }
            }
        }
    }
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (NSNumber *n in self.touchArray) {
        Clover *clover = [self.clovers.children objectAtIndex:[n unsignedIntValue]];
        clover.gState = kUngrabbed;
        clover.touchHash = 0;
    }
    [self.touchArray removeAllObjects];
    
}

#pragma mark - Dealloc
- (void) dealloc
{
	[super dealloc];
}

@end
