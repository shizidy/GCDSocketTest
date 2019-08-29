//
//  ViewController.m
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/28.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "ViewController.h"
#import "TCPViewController.h"
#import "UDPViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100 / 2, 200, 100, 50)];
    [self.view addSubview:button];
    [button setTitle:@"TCP" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100 / 2, 280, 100, 50)];
    [self.view addSubview:button2];
    [button2 setTitle:@"UDP" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)buttonClick:(UIButton *)btn {
    TCPViewController *viewController = [[TCPViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)buttonClick2:(UIButton *)btn {
    UDPViewController *viewController = [[UDPViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
