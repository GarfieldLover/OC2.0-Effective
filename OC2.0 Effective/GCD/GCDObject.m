//
//  GCDObject.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/4/30.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "GCDObject.h"
#import <UIKit/UIKit.h>

@implementation GCDObject

-(instancetype)init
{
    self=[super init];
    if(self){
        //系统级的线程管理，开发者只需要将任务追加到适当的queue，
        //GCD就能生成必要的线程执行任务，因为统一管理所以比之前用的线程效率更高
        //代码明了简洁
        
        //多线程，操作系统在多条执行路径调度切换，看上去好像1个CPU能并列执行多个线程一样，
        //在真正多个核心CPU下，真实提供了并行执行多个线程技术，可以保证app的响应性能，不用会阻塞主线程，卡界面
        //更新相同资源导致数据竞争，多个线程相互持续等待，死锁，消耗内存
        
        //api
        //DISPATCH_QUEUE_SERIAL，串行队列，不要大量生成
        //DISPATCH_QUEUE_CONCURRENT，并行队列
        //追加block执行任务
        
        //有retainCount为1,NULL为serial
        dispatch_queue_t serialQueue=dispatch_queue_create("com.zhangke.serialDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
        
        //有引用技术管理内存，需要release
        //retainCount为2
        dispatch_retain(serialQueue);
        dispatch_release(serialQueue);
        
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 1 %@" ,[NSThread currentThread]);
        });
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 2 %@" ,[NSThread currentThread]);
        });
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 3 %@" ,[NSThread currentThread]);
        });
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 4 %@" ,[NSThread currentThread]);
        });
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 5 %@" ,[NSThread currentThread]);
        });
        dispatch_async(serialQueue, ^{
            NSLog(@"Queue 6 %@" ,[NSThread currentThread]);
        });
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69617] Queue 1 <NSThread: 0x7f83caf1b460>{number = 2, name = (null)}
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69623] Queue 5 <NSThread: 0x7f83cd000850>{number = 5, name = (null)}
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69624] Queue 6 <NSThread: 0x7f83caf0d1f0>{number = 7, name = (null)}
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69615] Queue 2 <NSThread: 0x7f83cd101a60>{number = 3, name = (null)}
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69616] Queue 3 <NSThread: 0x7f83caf19180>{number = 4, name = (null)}
//        2015-05-01 00:18:56.163 OC2.0 Effective[1906:69622] Queue 4 <NSThread: 0x7f83cd102b20>{number = 6, name = (null)}
        
//        2015-05-01 00:18:08.835 OC2.0 Effective[1880:69149] Queue 1 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
//        2015-05-01 00:18:08.836 OC2.0 Effective[1880:69149] Queue 2 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
//        2015-05-01 00:18:08.836 OC2.0 Effective[1880:69149] Queue 3 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
//        2015-05-01 00:18:08.837 OC2.0 Effective[1880:69149] Queue 4 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
//        2015-05-01 00:18:08.837 OC2.0 Effective[1880:69149] Queue 5 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
//        2015-05-01 00:18:08.837 OC2.0 Effective[1880:69149] Queue 6 <NSThread: 0x7fa46aa791e0>{number = 2, name = (null)}
        
        
        
        //mainQueue 主线程执行，只有一个，serialQueue
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        
        //globalQueue 优先级获取,retain不会有变化,并发的
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

        dispatch_async(globalQueue, ^(void){
            UIImage* image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"照片" ofType:@"png"]];
            dispatch_async(mainQueue, ^(void){
                UIImageView* view=[[UIImageView alloc] initWithImage:image];
                NSLog(@"%@",view);
            });
            
        });
        
        //1.变更第一个参数的执行优先级为第二个参数的。2.如果第二个参数是serial，则第一个参数的queue们顺序执行，相当于依赖？
        dispatch_set_target_queue(serialQueue, globalQueue);
        
    
    }
    return self;
}

@end
