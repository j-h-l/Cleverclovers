//
//  CloverfieldLayer.h
//  Cleverclovers
//
//  Created by Jeehyung Lee on 5/26/13.
//  Copyright Jeehyung Lee 2013. All rights reserved.
//

#import "cocos2d.h"
#import "CCTouchDelegateProtocol.h"
#import "Clover.h"
#import "Pouch.h"

@interface CloverfieldLayer : CCLayer <CCTouchAllAtOnceDelegate>
{
}
@property (nonatomic, strong) CCSpriteBatchNode *clovers;
@property (nonatomic, strong) NSMutableArray *touchArray;

+(CCScene *) scene;

@end
