//
//  Clover.m
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/27/13.
//  Copyright 2013 Jeehyung Lee. All rights reserved.
//

#import "Clover.h"


@implementation Clover

-(id) init {
    self = [super init];
    if (self) {
        self.position = [self randomPosition];
        self.gState = kUngrabbed;
        self.originalPosition = self.position;
    }
    return self;
}

-(id)initWithPosition:(CGPoint)p {
    self = [super init];
    if (self) {
        self.position = p;
        self.gState = kUngrabbed;
        self.originalPosition = self.position;
    }
    return self;
}

-(id)initWithBatchNode:(CCSpriteBatchNode *)batchNode rect:(CGRect)rect {
    self = [super initWithBatchNode:batchNode rect:rect];
    if (self) {
        self.position = [self randomPosition];
        self.rotation = arc4random()%360;
        self.gState = kUngrabbed;
        self.originalPosition = self.position;
    }
    return self;
    
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    self = [super initWithTexture:texture rect:rect];
    if (self) {
        self.position = [self randomPosition];
//        self.position = CGPointMake(100, 200);
        self.rotation = arc4random()%360;
//        self.rotation = 0;
        self.gState = kUngrabbed;
        self.originalPosition = self.position;
    }
    return self;
    
}
-(void) randomizePosition {
    [self setPosition:[self randomPosition]];
}

-(CGPoint) randomPosition {
    CGSize s = [[CCDirector sharedDirector] winSize];
    CGFloat xrand = arc4random()%(int)s.width; //s.width
    CGFloat yrand = arc4random()%(int)s.height; //s.height
    CGPoint temp = ccp(xrand, yrand);
    return temp;
}

@end
