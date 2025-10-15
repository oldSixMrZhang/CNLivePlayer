//
//  CNLiveBaseController.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/8/31.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveBaseController.h"

@interface CNLiveBaseController ()

@end

@implementation CNLiveBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;

}

@end
