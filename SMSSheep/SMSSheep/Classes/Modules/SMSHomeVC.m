//
//  SMSHomeVC.m
//  SMSSheep
//
//  Created by ken.liu on 2019/4/17.
//  Copyright © 2019 ken.liu. All rights reserved.
//

#import "SMSHomeVC.h"
#import "SMSPredict.h"

@interface SMSHomeVC ()

@end

@implementation SMSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([SMSPredict predictSMS:@"hello,ni mei"]) {
        NSLog(@"predict = yes");
    } else {
        NSLog(@"predict = no");
    }
}

@end
