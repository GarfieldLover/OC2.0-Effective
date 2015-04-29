//
//  NSPViewController.h
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/27.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSPViewController : UIViewController

//mrc,unsafe_unretained   arc,weak
@property (nonatomic,unsafe_unretained) id obj;

-(void)setobj:(id)object;

-(void)goHome;

@end
