//
//  SMSPredict.m
//  SMSSheep
//
//  Created by ken.liu on 2019/4/18.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import "SMSPredict.h"
#import "PredictSMS.h"
#import "ObjcJiebaWrapper.h"

@interface SMSPredict ()

@property (nonatomic, strong) ObjcJiebaWrapper *jiebaWrapper;
@property (nonatomic, strong) NSArray *featureNameList;

@end

@implementation SMSPredict
- (BOOL)predictSMS:(NSString *)message {
    NSError *error;
    PredictSMS *preSMS = [[PredictSMS alloc] init];
    PredictSMSOutput *output = [preSMS predictionFromMessage:[self getSMSMultiArray:message] error:&error];
    
    return output.predict;
}

- (MLMultiArray *)getSMSMultiArray:(NSString *)msg {
    if (self.featureNameList == nil) {
        return nil;
    }
    
    NSMutableArray *words = [NSMutableArray array];
    [self.jiebaWrapper objcJiebaCut:msg toWords:words];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [words count]; i++) {
        NSUInteger index = [self.featureNameList indexOfObject:[words objectAtIndex:i]];
        if (index != NSNotFound) {
            BOOL contain = NO;
            for (int j = 0; j < [array count]; j++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:j]];
                if ([[dic objectForKey:@"index"] doubleValue] == index) {
                    [dic setObject:[NSNumber numberWithDouble:[[dic objectForKey:@"count"] doubleValue] + 1] forKey:@"count"];
                    break;
                }
            }
            
            if (!contain) {
                [array addObject:@{@"index": [NSNumber numberWithDouble:index], @"count": @(1)}];
            }
        }
    }
    
    NSError *error;
    MLMultiArray *mlarray = [[MLMultiArray alloc] initWithShape:@[[NSNumber numberWithUnsignedInteger:self.featureNameList.count]]
                                                       dataType:MLMultiArrayDataTypeDouble error:&error];
    
    for (NSUInteger i = 0; i < [self.featureNameList count]; i++) {
        [mlarray setObject:@(0) atIndexedSubscript:i];
    }
    
    for (int i = 0; i < [array count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
        [mlarray setObject:[dic objectForKey:@"count"] atIndexedSubscript:[[dic objectForKey:@"index"] unsignedIntegerValue]];
    }
    
    return mlarray;
}

#pragma mark - getter setter
- (NSArray *)featureNameList {
    if (_featureNameList == nil) {
        NSError *error;
        NSString *textFieldContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"feature" ofType:@"txt"]
                                                                encoding:NSUTF8StringEncoding error:&error];
        
        if (textFieldContents == nil) {
            NSLog(@"---error--%@", [error localizedDescription]);
        } else {
            NSMutableArray *names = [NSMutableArray arrayWithArray:[textFieldContents componentsSeparatedByString:@"\n"]];
            [names removeLastObject];
            
            _featureNameList = [NSArray arrayWithArray:names];
        }
    }
    return _featureNameList;
}

- (ObjcJiebaWrapper *)jiebaWrapper {
    if (_jiebaWrapper == nil) {
        _jiebaWrapper = [[ObjcJiebaWrapper alloc] init];
    }
    return _jiebaWrapper;
}
@end
