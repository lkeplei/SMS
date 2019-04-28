//
//  SMSPredict.h
//  SMSSheep
//
//  Created by ken.liu on 2019/4/18.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMSPredict : NSObject

/**
 预测短信是否为垃圾短信

 @param message 信息内容
 @return 返回是否为垃圾短信
 */
+ (BOOL)predictSMS:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
