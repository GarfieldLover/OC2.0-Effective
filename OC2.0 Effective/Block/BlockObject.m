//
//  BlockObject.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "BlockObject.h"

@implementation BlockObject

-(instancetype)init
{
    self=[super init];
    if(self){
        //block回调
        [self performSelector:@selector(callBack) withObject:nil afterDelay:4];
    }
    return self;
}

-(void)loadImageWithBlock:(imageBlock)block
{
    [aBlock release];
    aBlock=[block copy];
}

-(void)callBack
{
    UIImage* image=[UIImage imageNamed:@"照片.png"];
    aBlock(image,image.size);
}

+(void)loadImageWithBlock:(imageBlock)block
{
    UIImage* image=[UIImage imageNamed:@"照片.png"];
    UIImageView* imageView= block(image,image.size);
    
}



@end
