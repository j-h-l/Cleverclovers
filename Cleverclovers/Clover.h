//
//  Clover.h
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/27/13.
//  Copyright 2013 Jeehyung Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kUngrabbed = 0,
    kGrabbed,
} GrabState;

@interface Clover : CCSprite

@property (nonatomic, assign) CGPoint originalPosition;
@property (nonatomic, assign) GrabState gState;
@property (nonatomic, assign) NSUInteger touchHash;

- (id)init;
- (id)initWithPosition:(CGPoint)p;
- (id)initWithBatchNode:(CCSpriteBatchNode *)batchNode rect:(CGRect)rect;
- (id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect;

- (void)randomizePosition;
- (CGPoint)randomPosition;

@end
