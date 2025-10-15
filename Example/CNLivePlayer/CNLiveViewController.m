//
//  CNLiveViewController.m
//  CNLivePlayer
//
//  Created by 153993236@qq.com on 07/26/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveViewController.h"
#import "CNLivePlayerController.h"
#import "CNLiveStreamerController.h"

@interface CNLiveViewController ()

@end

@implementation CNLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 50);
    btn1.center = CGPointMake(self.view.center.x, self.view.center.y-50);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"播放" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnDidClicked1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 100, 50);
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y+50);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"推流" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnDidClicked2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-80, CGRectGetWidth(self.view.frame), 30)];
    label.text = @"北京中投视讯文化传媒股份有限公司";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}

- (void)btnDidClicked1{
    [self presentViewController:[CNLivePlayerController new] animated:YES completion:nil];

}

- (void)btnDidClicked2{
    [self presentViewController:[CNLiveStreamerController new] animated:YES completion:nil];

}


@end
