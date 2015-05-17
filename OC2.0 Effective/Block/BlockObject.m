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

-(void)loadImageWithBlock:(UIImageView* (^)(UIImage* image,CGSize size))block
{
    [aBlock release];
    //对于block语法可以调用copy，除了block作为返回值，赋值给__strong修饰符的变量，含有usingblock或GCD外，
    //推荐使用copy方法
    //会复制到堆上___调用copy，block作为返回值，block赋值给strong的对象，usingBlock或GCD的block
    //NSConcreteStackBlock，创建在栈上，从栈复制到堆
    //NSConcreteGlobalBlock, 创建在全局数据区域上，什么也不做，指向地址相同,计数为1
    //NSConcreteMallocBlock，创建在堆上，copy创建新对象当然是1，都是1
    aBlock=[[[block copy] retain] retain];
    
    UIImage* image=[UIImage imageNamed:@"照片.png"];
//    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView* xx= aBlock(image,image.size);
        

//    });
    
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
