//
//  CNLivePlayerModel.m
//  CNLivePlayer_Example
//
//  Created by CNLive-zxw on 2019/8/19.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLivePlayerModel.h"

@implementation CNLivePlayerModel
- (CNLivePlayerModel *)initWithID:(NSString *)ID url:(NSString *)url {
    self = [super init];
    if(self){
        self.ID = ID;
        self.url = url;
    }
    return self;
    
}

- (BOOL)isEmpty{
    BOOL result = NO;
    
    if(!self){
        result = YES;
        
    }
    
    if(!self.ID){
        result = YES;
        
    }
    
    if([self.ID isEqualToString:@""]){
        result = YES;
        
    }
    
    return result;
    
}


@end
