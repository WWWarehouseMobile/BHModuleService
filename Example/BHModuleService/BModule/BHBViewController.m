//
//  BHBViewController.m
//  BHModuleService_Example
//
//  Created by 汪志刚 on 2019/2/11.
//  Copyright © 2019 汪志刚. All rights reserved.
//

#import "BHBViewController.h"
#import "BHBProtocol.h"

#import <BHModuleService/BHModuleService.h>

@interface BHBViewController ()<BHBProtocol>

@end

@implementation BHBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"bVC";
    self.view.backgroundColor = [UIColor whiteColor];
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
