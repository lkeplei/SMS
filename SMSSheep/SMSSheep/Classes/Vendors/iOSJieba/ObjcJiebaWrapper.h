//
//  ObjcJiebaWrapper.h
//  SMSSheep
//
//  Created by ken.liu on 2019/4/18.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcJiebaWrapper : NSObject

- (void)objcJiebaCut:(NSString *)sentence toWords:(NSMutableArray *)words;

@end

NS_ASSUME_NONNULL_END
