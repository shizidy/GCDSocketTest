//
//  ViewController.m
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/28.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "ViewController.h"
#import "GCDSocketManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[GCDSocketManager shareManager] connectToServer];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100 / 2, 200, 100, 50)];
    [self.view addSubview:button];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)buttonClick:(UIButton *)btn {
    [[GCDSocketManager shareManager] sendDataToServer];
}

@end
