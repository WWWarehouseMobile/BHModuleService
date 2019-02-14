//
//  BHAViewController.m
//  BHModuleService_Example
//
//  Created by 汪志刚 on 2019/2/11.
//  Copyright © 2019 汪志刚. All rights reserved.
//

#import "BHAViewController.h"
#import "BHAProtocol.h"
#import "BHBProtocol.h"

#import <BHModuleService/BHModuleService.h>
@interface BHAViewController ()<BHAProtocol>

@end

@implementation BHAViewController

//+ (void)load {
//    [BHServiceManager registerServiceWithProtocol:@protocol(BHAProtocol) service:[self class]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"aVC";
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 45);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"BModule" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToAModule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)goToAModule {
    UIViewController *bVC = [BHServiceManager createServiceWithProtocol:@protocol(BHBProtocol)];
    [self.navigationController pushViewController:bVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
