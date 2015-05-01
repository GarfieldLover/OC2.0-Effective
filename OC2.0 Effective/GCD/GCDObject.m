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
        
        [serialQueue release];
        
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
        
        //想在指定时间后执行处理，使用
        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
        dispatch_after(time, globalQueue, ^{
            NSLog(@"after 3 sec");
        });
        
        
        //追加到group里多个处理结束后执行其他处理，在并发队列结束后执行mainQueue
        dispatch_queue_t groupQueue=dispatch_queue_create("com.groupQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group=dispatch_group_create();
        
        dispatch_group_async(group, groupQueue, ^{
            NSLog(@"group1");
        });
        dispatch_group_async(group, groupQueue, ^{
            NSLog(@"group2");
        });
        dispatch_group_async(group, groupQueue, ^{
            NSLog(@"group3");
        });
        
        //dispatch_group_notify在处理全部执行完了，将执行的block追加到queue中
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"done");
        });
        //一直等待该线程处理结束，不能做其他事，推荐使用dispatch_group_notify追加处理到mainQueue
        long result= dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"result  %ld",result);
        [group release];
        
        //数据库或文件，写入不能与其它处理并行执行，读取写入，可以追加到serial中，但是写入结束前不能读取
        //直接插入不能实现，并发执行了
        //dispatch_barrier_async，因为等待前边并行执行全部结束后，再将读取操作加入到queue，处理完毕后，queue再恢复原来的并行执行
        //栅栏异步执行
        
        dispatch_async(groupQueue, ^{
            NSLog(@"reading1");
        });
        dispatch_async(groupQueue, ^{
            NSLog(@"reading2");
        });
        dispatch_async(groupQueue, ^{
            NSLog(@"reading3");
        });
        dispatch_barrier_async(groupQueue, ^{
            NSLog(@"____writing");
        });
        dispatch_async(groupQueue, ^{
            NSLog(@"reading4");
        });
        dispatch_async(groupQueue, ^{
            NSLog(@"reading5");
        });
        dispatch_async(groupQueue, ^{
            NSLog(@"reading6");
        });
        
        //同步，在主线程会死锁，
        //dispatch_sync在等待block语句执行完成，而block语句需要在主线程里执行，所以dispatch_sync如果在主线程调用就会造成死锁
        //同步等block执行，但是block又需要在主线程执行，所以block执行不到，所以就执行不到。后续的代码都不会执行
//        dispatch_sync(mainQueue, ^{
//            NSLog(@"___sync");
//        });
//        NSLog(@"finish");
        
        //dispatch_apply，指定数量的block追加到queue中，等待全部处理结束，推荐在dispatch_async中异步执行dispatch_apply
        dispatch_async(globalQueue, ^{
            dispatch_apply(10, globalQueue, ^(size_t index){
                NSLog(@"____%ld",index);
            });
            
            dispatch_async(mainQueue, ^{
                NSLog(@"____apply done");
            });
        });
        
        //线程挂起和恢复，继续执行未完成的，是不是和线程休眠有关？
        dispatch_suspend(globalQueue);
        dispatch_resume(globalQueue);
        
        
        //内部错误
        //信号量，技术为0时等待，大于1操作，计数－1
        dispatch_semaphore_t semaphore=dispatch_semaphore_create(1);
        
        NSMutableArray* array=[[NSMutableArray alloc] init];
        for(int i=0;i<10;i++){
            dispatch_async(globalQueue ,^{
                //等待计数>=1，所以－1
                //dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1
                //对于处理操作更细粒度控制，根据信号量计数，决定是否执行操作，如果计数为0，则wait
                //是不是又和线程无事做休眠，有事唤醒有关？唤醒应该还是通知到的
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                //恒为0，访问安全
                [array addObject:[NSNumber numberWithInt:i]];
                //dispatch_semaphore_signal 发送一个信号，将计数＋1
                dispatch_semaphore_signal(semaphore);
            });
        }
        //1可能到这还没完全执行完
        [semaphore release];
        
        
        //dispatch_once，在多线程环境下只执行一次，生成单例使用，内部肯定使用静态数据管理单次
        static int init=NO;
        if(init==NO){
            static dispatch_once_t pred;
            dispatch_once(&pred, ^{
                init=YES;
            });
        }
        
        //dispatch io.h
        //分割读取，再合并，提高文件读取速度
//        dispatch_io_create(DISPATCH_IO_STREAM, fd, <#dispatch_queue_t queue#>, <#^(int error)cleanup_handler#>)
//        dispatch_io_read(<#dispatch_io_t channel#>, <#off_t offset#>, <#size_t length#>, <#dispatch_queue_t queue#>, ^(BOOL done,dispatch_data_t data,inte err){
//            dispatch_data_get_size(data);
//            const char* bytes=NULL;
//            dispatch_data_create_map(data, (const void**)&bytes, &len);
//        });
        
        
        //用于管理追加的block 的c语言实现的是FIFO队列
        //GCD是系统级内核上实现的，可以集中处理实现内容，不用过多管理线程
        //XNU内核生成和管理线程，调用追加到线程中的block，结束后通知线程结束，准备处理下一个block
        //queue无法取消，放弃取消，或使用NSOperationQueue
        
    }
    return self;
}

@end
