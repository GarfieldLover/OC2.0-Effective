//
//  ViewController.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/27.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"

static const float pointY=0.43f;

NSString* const Notification=@"not";

typedef NS_ENUM(NSUInteger, NetConntion){
    NotConntion = 1,
    G3 = 3,
    WIFI = 4
};

typedef NS_OPTIONS(NSUInteger, DeviceFace){
    UP = 1<<0,
    DOWN = 1<<1,
    LEFT = 1<<2,
    RIGHT = 1<<3,
};



@interface ViewController ()

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* string=@"zhangke";
    
    NSNumber* number=@1.5f;

    NSNumber* boolNumber=@YES;
    
    NSNumber* charNumber=@'a';
    
    int x=5;
    float y=6.32f;
    NSNumber* exNumber=@(x * pointY);
    
    
    NSArray* array=@[@"1",@"2"];
    
    NSString* aNumber=array[0];

    NSDictionary* dic=@{@"name":@"zhangke",@"age":@"22"};
    
    NSString* name=dic[@"name"];
    

    NetConntion conntion=G3;
    switch (conntion) {
        case NotConntion:
            break;
        case G3:
            break;
        case WIFI:
            break;
        default:
            break;
    }
    
    DeviceFace face=DOWN | UP | RIGHT;
    
}

-(instancetype)init
{
    return [self initWithName:@"zhangke" age:@"22"];
}

-(instancetype)initWithName:(NSString*)aName
{
    return [self initWithName:aName age:@"22"];
}

-(instancetype)initWithName:(NSString*)aName age:(NSString*)aAge
{
    self=[super init];
    if(self){
        _name=[aName copy];
        _age=[aAge copy];
        
        _valueArray=[NSArray arrayWithObjects:_name,_age, nil];
        
        if(_age.integerValue>25){
            //对象变化，而不是指针变化
            NSError* error=nil;
            [self error:&error];
            
            @throw [NSException exceptionWithName:@"age" reason:@">20" userInfo:nil];
            
        }
        
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    ViewController* vc= [[ViewController alloc] initWithName:_name age:_age];
    //数组浅拷贝
    vc->_valueArray=[_valueArray copy];
    //数组浅拷贝
    vc->_valueArray=[_valueArray mutableCopy];
    [(NSMutableArray*)vc->_valueArray addObject:_name];
    //数组深拷贝
    vc->_valueArray=[NSArray arrayWithObjects:vc.name,vc.age, nil];
    
    return vc;
}



-(void)error:(NSError**)error
{
    *error=[NSError errorWithDomain:@"age" code:20 userInfo:nil];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ : %p, \n<name=%@, age=%@>",[self class],self,_name,_age];
}


-(void)goHome
{
    NSLog(@"ok");
}



@end
