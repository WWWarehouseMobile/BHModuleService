//
//  BHViewController.m
//  BHModuleService
//
//  Created by 汪志刚 on 01/29/2019.
//  Copyright (c) 2019 汪志刚. All rights reserved.
//

#import "BHViewController.h"
#import "BHAProtocol.h"

#import <BHModuleService/BHModuleService.h>

@interface BHViewController ()

@end

@implementation BHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"RootVC";
    self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 45);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:@"AModule" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToAModule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (void)goToAModule {
    UIViewController *aVC = [BHServiceManager createServiceWithProtocol:@protocol(BHAProtocol)];
    [self.navigationController pushViewController:aVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
