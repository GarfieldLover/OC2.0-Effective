//
//  ViewController.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/27.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "ViewController.h"
#import "NSPViewController.h"


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



@interface ViewController (){

}

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


-(void)memory
{
//    NSDeallocateObject(self);
//    NSAllocateObject([ViewController class], 0, nil);
    
    //引用计数表管理技术，纪录存有内存块地址和计数，能够追溯到内存，为0，择机把内存清空合并成大块内存
    //autorelease,如果有在使用obj1，则不会释放。在retainCount为0，runloop会回收
    //使用@autoreleasepool，在作用域外会被释放。
    //NSAutoreleasePool，具体内部方法见下列
    
//    NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
    while (0) {
        @autoreleasepool {
            //地址没有几个，释放了立马就能重用，内存控制的很低，其实应该也是调用了drain
            //__autoreleasing,在arc中不显示的掉，在自动释放池内肯定加，在mrc无作用
            UIImage* __autoreleasing image=[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"照片" ofType:@"png"]];
            NSLog(@"%p,%ld",image,image.retainCount);
            [image autorelease];
            sleep(5);
            //autorelease不直接减retainCount，而只是加到了待释放数组中
            NSLog(@"-----%p,%ld",image,image.retainCount);
        }
    }
//    [pool drain];
    
    //arc下，超出作用区域自动释放，至为nil
    id __strong obj1=[[NSObject alloc] init];  //A
    
    id __strong obj2=[[NSObject alloc] init];  //B

    id __strong obj3=nil;
    
    obj1=obj2; //A被释放
    obj2=obj3; //B被释放
    
    //转换
    void* p=(__bridge void*)obj1;
    obj1=(__bridge id)p;
    
    
    //循环引用，引用环，谁也释放不了，形成内存孤岛
    //如果都是strong，或者在arc下自动是strong，则引用计数为2，都得不到释放，在arc必须有一方为weak，mrc或者不增加计数
    //__weak 只能在arc 计数不加1，为0，创建出即被释放，mrc不管用,用unsafe_unretained
    NSPViewController* pv=[[NSPViewController alloc] init];
    self.obj=pv;
    pv.obj=self;
    
    //NSRunLoop能随时释放注册到@autoreleasepool中的对象
    
}



-(void)dealloc
{
    //应该是copy出来的
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}



#if 0
-(instancetype)autorelease
{
    [NSAutoreleasePool addObject:self];
}

+(void)addObject:(id)anObject
{
    [array addObject:anObject];
}

-(void)drain
{
    [self dealloc];
}

-(void)dealloc
{
    [self emptyPool];
    [self release];
}

-(void)emptyPool
{
    for(id obj in array){
        [obj1 release];
    }
}

-(void)release
{
    如果计数-- > 0,则不dealloc，
    计数＝＝0，dealloc，调free
}

#endif


-(void)aftermemory
{
    NSLog(@"self.obj retainCount %ld",[self.obj retainCount]);
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
