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
        _name=aName;
        _age=aAge;
        
//        NSLog(@"aName %p, _name %p, %lu, %lu",aName,_name,aName.retainCount ,_name.retainCount);
        _valueArray=[NSArray arrayWithObjects:_name, _age, nil];
        
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
    ViewController* vc= [ViewController alloc];
    
    //copy->   1.如果object是不可变的，那么就是浅拷贝，引用计数＋1
    //2.如果object是mutable的，那么就是深拷贝，新对象引用计数＋1
    //得到的对象是不可变的
    //mutablecopy->  不管object是可变还是不可变，都是深拷贝，新对象引用计数＋1
    //得到的对象是可变的
    
    vc->_name=[_name mutableCopy];
    vc->_age=[_age mutableCopy];
    

    //数组浅拷贝
    vc->_valueArray=[_valueArray mutableCopy];
    /*
    (lldb) p [vc->_valueArray firstObject]
    (id) $0 = 0x00000001054440c0
    (lldb) p _name
    (NSString *) $1 = 0x00000001054440c0 @"zhangke"
    */
    
    //数组深拷贝,自定义,把原来数组里的元素深拷贝了加到数组里

    [(NSMutableArray*)vc->_valueArray removeAllObjects];
    [(NSMutableArray*)vc->_valueArray addObject:vc->_name];
    [(NSMutableArray*)vc->_valueArray addObject:vc->_age];
    
    vc->_valueArray=[NSArray arrayWithObjects:vc->_name, vc->_age, nil];


    //系统深拷贝
    NSArray* trueDeepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:
                                    [NSKeyedArchiver archivedDataWithRootObject: _valueArray]];
    /*
    (lldb) p [trueDeepCopyArray firstObject]
    (id) $6 = 0x00007fd110c0bc90
    (lldb) p [_valueArray firstObject]
    (id) $7 = 0x00000001070da0c0
    */
    
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
