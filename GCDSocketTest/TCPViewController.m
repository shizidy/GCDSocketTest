//
//  TCPViewController.m
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/29.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "TCPViewController.h"
#import "GCDSocketManager.h"

@interface TCPViewController ()

@end

@implementation TCPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100 / 2, 200, 100, 50)];
    [self.view addSubview:button];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    [[GCDSocketManager shareManager] connectToServer];
    // Do any additional setup after loading the view.
}

- (void)buttonClick:(UIButton *)btn {
    [[GCDSocketManager shareManager] sendDataToServer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[GCDSocketManager shareManager] cutOffSocket];
    [self dismissViewControllerAnimated:YES completion:nil];
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
