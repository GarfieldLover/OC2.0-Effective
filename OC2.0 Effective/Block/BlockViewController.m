//
//  BlockViewController.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/29.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "BlockViewController.h"
#import "BlockObject.h"

typedef int (^blk_t)(int);



@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //带有自动变量（局部变量）的匿名函数,需要时机调用
    
    //普通c函数
    int result=func(10);
    
    int (*funcptr)(int)=&func;
    result=(*funcptr)(10);
    
    //编写不带名称的函数
    
    // ^ 返回值类型 参数列表 表达式
    ^int (int count){
        return count+1;
    };
    //省略返回值类型
    ^(int count){
        return count+1;
    };

    ^void (void){
        NSLog(@"xxx");
    };
    //省略返回值类型，参数列表
    ^{
        NSLog(@"xxx");
    };
    
    //声明block类型变量
    //int (^blk)(int)=^(int count){return count+1;};
    
    
    //typedef后类型
    //截获自动变量只能保存瞬间的值，保存后不能修改值，应该是copy了一份，__block能对变量在block内赋值
    //使用该对象没问题，但是要修改不行
    //创建的闭包会捕获在它的域中的任何涉及的变量，通过在内存中持有他们，能够在block的实现中对其进行访问。
    //在默认情况下，任何在block的域中被捕获的变量都不能被修改，除非这个变量已被给予了__block的标志
    //当block捕获了一个对象时，它会对其进行retain操作，并在block代码执行完毕完release对象，这样才能保证在block执行过程中，对象不会因引用计数为0而被释放掉
    //__block存储域说明符，static,auto,register,   加了后能修改的指针指向val变量。
    __block int num=4;
    __block NSString* string =@"ffff";
    //__block不改变变量的释放，如果是__weak，还是立即被释放
    __block NSMutableArray* array=[[NSMutableArray alloc] init];
    blk_t blk=^(int count){
        num=3;
        string=@"sss";
        [array addObject:string];
        array=[NSMutableArray new];
        return count+1;
    };
    //__NSStackBlock__
    blk(10);
    //1、当 block 写在全局作用域时，即为 global block；
    //2、当 block 不获取任何外部变量时，即为 global block；
    //除了上述描述的两种情况，其他形式创建的 block 均为 stack block
    
    
    //其实block就是oc对象，__NSGlobalBlock__，NSStackBlock，
    //内部作为C语言 结构体被编译，class结构体，runtime内容，
    //Block，栈上block的结构体，__block变量，__block变量的结构体
    //下列为__NSGlobalBlock__，因为没有获取任何外部变量
    //__block变量在复制block的同时复制到堆上，多个block使用同一个__block变量是增加其计数
    //配置在堆上的block被废弃，所使用的__block变量计数－1，到0释放
    //__block先在栈上，在block内复制到了堆上，栈的__forwarding指向了堆结构体，堆的__forwarding指向自身
    BlockObject* blockObject=[[BlockObject alloc] init];
    __block CGSize tempSize=CGSizeZero;
    //block结构体strong了blockArray， _Block_object_dispose release block
    NSMutableArray* blockArray=[NSMutableArray new];
    
    //__weak只能arc， mrc，__unsafe_unretained，计数为1
    id __unsafe_unretained temp=self;
    //也可以使用 打破循环，把对象设为nil，可以控制对象持有期，但是必须执行block
    __block id tmp=self;  //不会被retain,在mrc
    [blockObject loadImageWithBlock:^UIImageView* (UIImage* image,CGSize size){
        NSLog(@"传递进入，择时回调，delegate，需要copy block %@ , %f",image,size.width);
        UIImageView* imageView=[[UIImageView alloc] initWithImage:image];
        size=tempSize;
        [blockArray addObject:imageView];
        //block使用附有__strong的变量，当复制到堆上被block所持有，循环引用。self 默认__strong持有Block，block持有self，使得self得不到释放
        NSLog(@"self==%@",temp);
        tmp=nil;
        return imageView;
    }];
    
    [BlockObject loadImageWithBlock:^UIImageView* (UIImage* image,CGSize size){
        NSLog(@"代码块，代替delegate，及时调，不常用 %@ , %f",image,size.width);
        UIImageView* imageView=[[UIImageView alloc] initWithImage:image];
        return imageView;
    }];
    
    //NSConcreteStackBlock，创建在栈上
    //NSConcreteGlobalBlock, 创建在全局数据区域上
    //NSConcreteMallocBlock，创建在堆上
    //开辟在栈上的block，作用区域结束，block和变量被废弃，提供了复制到堆上的方法。
    //复制到堆上的__block变量和block在作用域结束不受影响
    //__block变量用block结构体成员变量__forwarding实现访问
    
    //在arc下，调用copy复制到堆上
    //tmp=_Block_copy(tmp);
    //return objc_autoreleaseRetrunValue(tmp);
    
}

-(void)dealloc
{
    NSLog(@"self==%@",self);
    [super dealloc];
}



int func(int count)
{
    return count;
}



@end
