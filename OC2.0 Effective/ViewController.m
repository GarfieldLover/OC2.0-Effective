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



//continuation分类，定义在.m里，分类没有名字，runtime会检测
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
    
    //多个线程执行同一份代码，读写，使用锁实现同步，同步block
    NSLock* lock=[[NSLock alloc] init];
    [lock lock];
    id object=[[NSObject alloc] init];
    [lock unlock];
    [object release];

    
    @synchronized(self){
        object=[[NSObject new] autorelease];
    };
    
    //使用serial队列读取写入，并发队列也可以执行，使用栅栏barrier，
    
    //无序集合，多用enumerator，枚举器
    NSSet* set=[[NSSet alloc] initWithObjects:lock, name,nil];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL* stop){
        NSLog(@"%@",obj);
    }];
    [lock release];
    [set release];

    //VC内部啥也不干3个计数，self，superclass？
    //会引用self，找判断条件把timer失效，释放self
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runLoop:) userInfo:nil repeats:YES];
    
}

-(void)runLoop:(NSTimer*)timer
{
    if(1){
        [timer invalidate];
    }
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
        
        //加入数组肯定让引用计数加1，但是应该会有数组的标记，不会减到0就释放，除非remove了
        NSString* str=[[NSString alloc] initWithString:@"XXX"];
        NSMutableArray* aaaa=[NSMutableArray array];
        [aaaa addObject:str];
        [str release];
        
        //应该是2,alloc ,retain
        self.test=[[NSString alloc] init];
        //1，只有alloc
        _test=[[NSString alloc] init];
        
        if(_age.integerValue>25){
            //对象变化，而不是指针变化
            NSError* error=nil;
            [self error:&error];
            
            //*** Terminating app due to uncaught exception 'age', reason: '>20'，抛出异常，并崩溃
            @throw [NSException exceptionWithName:@"age" reason:@">20" userInfo:nil];
            
        }
        NSLog(@"_____ %@",str);
    }
    return self;
}

//readwrite：是可读可写特性，需要生成getter和setter方法；
//readonly是之都特性，只会生成getter方法，不会生成setter方法，不希望属性在类外改变时候使用；
//alloc 对象分配后引用计数为1retain 对象的引用计数+1
//
//copy 一个对象变成新的对象(新内存地址) 引用计数为1 原来对象计数不变
//
//assign：是赋值特性，setter方法将传入参数赋值给实例变量（一把钥匙，同进同出）；用于基础数据类型；
//weak：由ARC引入的对象变量的属性，比assign多了一个功能，对象消失后把指针置为nil，避免了野指针（不是null指针，是指向“垃圾”内存（不可用的内存）的指针）；
//retain：表示持有特性，setter方法将传入参数先保留，后赋值（两把钥匙，各自进出），传入参数的retaincount加1；
//strong：ARC引入，等同于retain，对象消失后把指针置为ni；
//copy：表示赋值特性，setter方法将传入对象复制一份；需要完全一个新的对象时候（两套房子，两把钥匙）；
//nonatomic：非原子操作，决定编译器生成setter和getter方法是否原子操作，不加同步，多线程访问提高性能，
//__unsafe_unretain：对象引用不会加1，对象释放后，不会置为nil，可能造成野指针，尽量少用。
//autorelease：对象引用计数不立即－1，在pool drain时－1， 如果为0不马上释放，最近一个个pool时释放

//ARC所做的只不过是在代码编译时为你自动在合适的位置插入release或autorelease，就如同之前MRC时你所做的那样
-(void)setTest:(NSString *)aTest
{
    if(_test!=aTest){
        [_test release];
        //传入值的retain，传入值的计数应该是2
        _test=[aTest retain];
    }
}

-(id)copyWithZone:(NSZone *)zone
{
    ViewController* vc= [ViewController alloc];
    
    //如果是系统的
    //copy->   1.如果object是不可变的，那么就是浅拷贝，引用计数＋1
    //2.如果object是mutable的，那么就是深拷贝，新对象引用计数＋1
    //得到的对象是不可变的
    //mutablecopy->  不管object是可变还是不可变，都是深拷贝，新对象引用计数＋1
    //得到的对象是可变的
    
    //如果是自己创建继承于nsobject的，在这会创建新的对象返回，所以肯定是新对象
    
    
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
    //使用@autoreleasepool降低内存峰值
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
    //arc下创建的对象默认所有权修饰符为__strong,
    //属性内  assign unsafe_unretained __unsafe_unretained ,  copy retain strong  __strong ,  weak  __weak
    //strong , weak ,废弃时将变量设置为nil
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
    //循环引用最后一个对象需要是weak，这样第一个release计数为0，后续都能得到释放。
    NSPViewController* pv=[[NSPViewController alloc] init];
    self.obj=pv;
    pv.obj=self;
    
    
    //NSRunLoop能随时释放注册到@autoreleasepool中的对象
    
    id __weak obj4=obj1;
//    objc_initWeak()
//    objc_release
//    objc_destroyWeak
//    arc destroyWeak(&obj4);  立即被释放
}


-(void)dealloc
{
    //应该是copy出来的
    //解除监听Observer，清除套接字socket，大块内存，文件内存等
    //清除KVO
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
    if(retainCount>1)
        retainCount--;
    else
    {dealloc();}
}

#endif


-(void)aftermemory
{
    while (0) {
        NSLog(@"self.obj retainCount %ld",[self.obj retainCount]);
        sleep(3);
    }
}


-(void)CoreFoundation
{
    //Core Foundation框架和Foundation框架紧密相关，它们为相同功能提供接口，但Foundation框架提供Objective-C接口。如果您将Foundation对象和Core Foundation类型掺杂使用，则可利用两个框架之间的 “toll-free bridging”。免费桥
    //
    
    CFArrayRef cfObject=NULL;
    
    id obj=[[NSMutableArray alloc] init];
    [obj addObject:[[NSObject new] autorelease]];
    
    //__bridge来做objectc对象和corefoundtion结构体转化
//    cfObject=(__bridge CFArrayRef)obj;
    cfObject=CFBridgingRetain(obj);

    NSLog(@"CoreFoundation  %ld",CFGetRetainCount(cfObject));

    CFShow(cfObject);

    CFRelease(cfObject);
    NSLog(@"CoreFoundation  %ld",CFGetRetainCount(cfObject));
    [obj release];
    
    //根据网上查阅的资料，也许可以得出以下结论，事实上label的确已经被dealloc了，保留计数器的值也已经变成0了，其原来占用的内存也已经不可用 了，但是原来这块内存中的内容还没有变(标记删除)，将会在未来某个不确定的时间上被清理 ，这就是为什么NSLog输出的label保留计数器的值仍为1，而如果在此 之前再加上一个NSLog，则改变了原来这块内存的内容，于是发送给label的消息不再会被响应，于是程序crash。
    //所以说，两种情况都是有可能发生的，至于到底发生哪种情况，完全取决于合适系统清理掉label占用的内存，也可以说取决于“运气”，因为这个时间是不确定的。由于苹果源码非开源,所以究竟是什么样的都知识猜测,以上内容皆网上结果,本人认为retaincount最后为1.永远不可能为0.具体论证如下:
    //retaincount可能永远不返回0，系统会优化对象的释放，在计数是1时就回收了
    //如果是大的，13443243284098，是字面量语法，单例对象
    

    /*
    Student *stu=[Studentnew];//retainCount=1
    
    [stu retain];  //retainCount=2;
    
    [stu release];//执行如 release(){if(retainCount>1)retainCount--;else{dealloc();}}的操作   retainCount=1
    
    [stu release];//执行如 release()内部的else中的操作 调用dealloc()方法,外部实现了重写,故:调用dealloc();  此时retainCount=1 .
    */
    
    NSLog(@"obj  %ld",[obj retainCount]);

    
}

//委托模式
-(void)protocol
{
    //给代理者增加了接口，类之间通信，需要打破循环引用
    
    //将类的实现代码按照功能分成几个部分，生成分类，给系统类增加功能
    
    //分类中声明属性，需要用runtime的关联对象
    
    //@dynamic，的setter和getter方法需要到运行时再提供，编译时看不到
    
    //通过协议提供匿名对象，只关注与协议的接口，不关注内部，适配器模式？
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

-(void)down:(downImage)image
{
    image(nil);
}

@end
