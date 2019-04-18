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
    
    SMSPredict *predict = [[SMSPredict alloc] init];
    [predict predictSMS:@"欢迎致电创业人家置业发展有限公司，本公司从事房地产开发、二手房销售、物业管理，欢迎新老客户前来惠顾，我们将竭诚为您服务，电话：xxxx"];
}

@end
