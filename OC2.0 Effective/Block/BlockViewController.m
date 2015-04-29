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
    //__block存储域说明符，static,auto,register,加了后有能修改的指针指向val变量。
    __block int num=4;
    __block NSString* string =@"ffff";
    __block NSMutableArray* array=[[NSMutableArray alloc] init];
    blk_t blk=^(int count){
        num=3;
        string=@"sss";
        [array addObject:string];
        array=[NSMutableArray new];
        return count+1;
    };
    
    blk(10);

    
    //其实block就是oc对象，__NSGlobalBlock__，NSStackBlock，
    //内部作为C语言 结构体被编译，class结构体，runtime内容，
    BlockObject* blockObject=[[BlockObject alloc] init];
    [blockObject loadImageWithBlock:^UIImageView* (UIImage* image,CGSize size){
        NSLog(@"传递进入，择时回调，delegate，需要copy block %@ , %f",image,size.width);
        UIImageView* imageView=[[UIImageView alloc] initWithImage:image];
        return imageView;
    }];
    
    [BlockObject loadImageWithBlock:^UIImageView* (UIImage* image,CGSize size){
        NSLog(@"代码块，代替delegate，及时调，不常用 %@ , %f",image,size.width);
        UIImageView* imageView=[[UIImageView alloc] initWithImage:image];
        return imageView;
    }];
    
    
}




int func(int count)
{
    return count;
}



@end
