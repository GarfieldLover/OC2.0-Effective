//
//  BlockObject.h
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UIImageView* (^imageBlock)(UIImage* image,CGSize size);

@interface BlockObject : NSObject{
    imageBlock aBlock;
}

-(void)loadImageWithBlock:(imageBlock)block;

+(void)loadImageWithBlock:(imageBlock)block;

@end
