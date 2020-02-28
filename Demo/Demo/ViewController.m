//
//  ViewController.m
//  Demo
//
//  Created by TS-CBin on 2019/7/2.
//  Copyright © 2019 CBin. All rights reserved.
//

#import "ViewController.h"
#import "PackagMet.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [PackagMet showHUDWithKeyWindowWithString:@"我是提示信息"];
//    [PackagMet initAlertViewShowStr:@"弹窗提示"];
}

@end
