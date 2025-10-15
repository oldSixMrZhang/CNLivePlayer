//
//  CNLiveStreamerController.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zCNLive on 2019/8/17.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveStreamerController.h"
#import "CNLivePlayer.h"

@interface CNLiveStreamerController ()<CNLivePlayerDelegate>
@property (nonatomic, strong) CNLivePlayer *player;
@property (nonatomic, strong) UILabel *state;

@end

@implementation CNLiveStreamerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 82_c8ff347048414b7295cef882f8361073    杨丞琳
    // 223_9855888ddc68402ca738bf302e535805   汤唯
    // 1066_716fabeaafb64236b60ecf74167c5c96  音频
    
//    http://tjzghuajiao.vods2.cnlive.com/1066/vod/2019/0517/1066_716fabeaafb642K36b60ecf74167c5c96/ff8080816a6816ca016ac3bee98b5fa7_128.mp4
//    self.player = [[CNLivePlayer alloc]initWithUrl:@"http://tjzghuajiao.vods2.cnlive.com/1066/vod/2019/0517/1066_716fabeaafb64236b60ecf74167c5c96/ff8080816a6816ca016ac3bee98b5fa7_128.mp4"];

    self.player = [[CNLivePlayer alloc]initVodPlayWithVideoId:@"223_9855888ddc68402ca738bf302e535805"];

//    self.player = [[CNLivePlayer alloc]initVodPlayWithVideoId:@"223_9855888ddc68402ca738bf302e535805" success:^{
//
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    _player.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16.0);
    _player.backgroundPlayEnable = YES;
    _player.delegate = self;
    [self.view addSubview:self.player.view];
    [_player play];
 

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 50);
    btn1.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitle:@"下一个" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnDidClicked1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 100, 50);
    btn2.center = CGPointMake(self.view.center.x-100, self.view.center.y+100);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"切换码率1" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnDidClicked2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0, 0, 100, 50);
    btn4.center = CGPointMake(self.view.center.x+100, self.view.center.y+100);
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitle:@"切换码率2" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btnDidClicked4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, 100, 50);
    btn3.center = CGPointMake(self.view.center.x, self.view.center.y+200);
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"返回" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnDidClicked3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    self.state = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.state.backgroundColor = [UIColor redColor];
    self.state.center = CGPointMake(self.view.center.x, self.view.center.y+300);
    [self.view addSubview:self.state];

}

- (void)dealloc{
    
}
- (void)btnDidClicked1{
    [_player switchVideo:@"82_c8ff347048414b7295cef882f8361073" type:CNLivePlayerDataTypeVod];
    [_player play];

}
- (void)btnDidClicked2{
    self.state.text = @"切换中";
    [_player switchRate:kCNLiveClarity_1080P];

}

- (void)btnDidClicked4{
    self.state.text = @"切换中";
    [_player switchRate:kCNLiveClarity_360P];
}
- (void)btnDidClicked3{
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
- (void)player:(nonnull CNLivePlayer *)player statusDidChange:(CNLivePlayerStatus)state{
    if(state == CNLivePlayerStatusOpen){
    
    }
}

- (void)player:(nonnull CNLivePlayer *)player seekToCompleted:(BOOL)isCompleted{

}
- (void)player:(nonnull CNLivePlayer *)player switchRateCompleted:(BOOL)isCompleted{
        self.state.text = isCompleted?@"切换完成":@"切换失败";
}
- (void)player:(nonnull CNLivePlayer *)player stoppedWithError:(nullable NSError *)error{

}


@end

