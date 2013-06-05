//
//  Pouch.h
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/27/13.
//  Copyright 2013 Jeehyung Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Pouch : CCLayer {
    
}
@property (nonatomic, strong) NSMutableArray *itemsInInventory; // initialize with desired inventory size
@property (assign) BOOL hidden;

+ (Pouch *)sharedPouch;
- (id) init;

@end
