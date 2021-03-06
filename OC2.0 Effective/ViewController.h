//
//  ViewController.h
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/27.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const Notification;

typedef void (^downImage)(UIImage* image);

@interface ViewController : UIViewController<NSCopying>{
@protected
    NSString* _test;
}

@property (nonatomic,strong) id obj;


@property (nonatomic,readonly,copy) NSString* name;

@property (nonatomic,readonly,copy) NSString* age;

@property (nonatomic,readonly,copy) NSArray* valueArray;

@property (nonatomic,strong) NSString* test;

-(void)goHome;

-(instancetype)init;

-(instancetype)initWithName:(NSString*)aName;

-(instancetype)initWithName:(NSString*)aName age:(NSString*)aAge;

-(void)memory;

-(void)aftermemory;

-(void)CoreFoundation;

-(void)down:(downImage)image;


@end


