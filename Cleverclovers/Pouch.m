//
//  Pouch.m
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/27/13.
//  Copyright 2013 Jeehyung Lee. All rights reserved.
//

#import "Pouch.h"


@implementation Pouch


+ (Pouch *)sharedPouch {
    static Pouch *sharedPouch = nil;
    if (!sharedPouch) {
        sharedPouch = [[Pouch alloc] init];
    }
    return sharedPouch;
}

- (id) init {
    self = [super init];
    if (self) {
        CGSize s = [[CCDirector sharedDirector] winSize];
        CCSprite *pouchTiles = [CCSprite spriteWithFile:@"cloverfield_wpouch.png" rect:CGRectMake(25, 0, 125, 50)];
        pouchTiles.position = ccp(s.width+(125/2), s.height/2);
        self.hidden = true;
        [self addChild:pouchTiles];
        
        // TODO Use 2 rows of Array to check for "shaped item" later
        self.itemsInInventory = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}
@end
