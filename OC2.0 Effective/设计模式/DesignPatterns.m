//
//  DesignPatterns.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/5/3.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "DesignPatterns.h"

@implementation DesignPatterns

-(instancetype)init
{
    self=[super init];
    if(self){
        [self Observer];
    }
    return self;
}

#pragma mark --对象创建

//原型
-(void)prototype
{
    //类不容易创建，复制更容易，大量对象的情况也可以用
   
    //深拷贝，复制一份图像，或者游戏中的敌人
    
//    nscopying
//    copywithzone
    
}

//工厂方法模式，单例工厂——工厂类一般都是单例的
-(void)factoryCreator
{
    //想让类在运行时创建
    
    //内部调用，返回数组等
    //[[NSClassFromString(className) alloc] init];
    
    //＋－＊／，运行时生成不同的产品，根据表模式来写
}

//1。解决怎么样的问题，对象的粒度，对象的接口，
//2.模式的意图
//3.研究相似的模式
//4.考虑可变因素


//1.研究结构、参与者、协作者
//2.选择名字，定义类
//3.现实责任和协作操作


//1。意图：创建一系列相关对象的接口，无需指定具体的类
//2。别名：kit
//3。动机：调用者仅通过widgetFactory接口创建UI组件，编码过程并不知道哪些类实现了特定风格组建。调用者仅与抽象类接口交互，不使用具体类接口。
   //具体使用哪套工厂生成那套产品由服务端配置
//4。适用性：系统独立于产品的创建时，系统使用多个产品系列中的一个时
//5。结构：抽象工程《—具体工厂－》产品系列－》抽象产品
//6。参与者：抽象工厂类，具体工厂类，抽象产品类，具体产品类，调用者－》使用抽象工厂和抽象产品 声明的接口
//7。协作：使用不同的工厂，将对象的创建延迟到具体子类
//8。效果：分离了具体的类；易于交换产品系列；
//9。实现：创建工厂，单例，创建产品
//12。相关模式：抽象工厂用工厂方法实现，编码初始用工厂方法创建对象，后期重构为抽象工厂

//抽象工厂
-(void)abstractFactory
{
    //创建多系列产品
    
    //日用品工厂生产日用品，联合利华工厂继承于日用品厂，生产牙膏和洗发水，宝洁也继承与日用品厂，生产牙膏和洗发水，2个品牌的牙膏和洗发水都继承于牙膏和洗发水的抽象
    //抽象工厂返回抽象产品
    //一开始使用具体工厂，重构为使用多个具体工厂的抽象工厂
}

//生成器
-(void)builder
{
    //构建复杂对象，各个步骤装配各部件
    
    //构建游戏角色，builder负责生成角色，然后分步骤函数配置属性
    //力量，智力，玩家，敌人等
}

//单例
-(void)singleton
{
    //只有一个实例，从一个访问方法访问
    //静态全局变量保证类的实例的唯一性
    
    //copywithzone return self;
    
    //单例线程安全，同步块，lock，单例多线程同时读写有问题，
    //用once吧。。。
    //uiapplication nsfilemanager, nsbundle,nsobserver
    
}

#pragma mark --接口适配

//适配器
-(void)adapter
{
    //包装器，电源插头
    
    //已有类的接口与需求不匹配，统一接口
    //抽象get方法
    //OC中协议，作为存粹的抽象形式，类可以实现协议，同时可以继承与父类
}

//桥接
-(void)Bridge
{
    //抽象与实现间不希望耦合
    
    //子类调用方法 ［self  set ］－》［super set］－》［super。execute set］－》［subexeute set］
    
    //SFA使用，widget调用，发到了父类，父类再发到了baseVC，再到具体的VC
}

//外观
-(void)Facade
{
    //功能的各子系统复杂，提供个简单接口
    
    //子系统，car，计程器，封装到carDriver，driveToSomeWhere－》调用 car的方法，启动车等，调用计程器；
    
    //具体LOG系统，包括了纪录，文件系统存储，网络上传等
}



#pragma mark --对象去耦

//中介者
-(void)Mediator
{
    //用一个对象封装一系列对象的交互，使各对象不需要相互引用，使其松耦合
    
    //一组对象互相依赖，导致对象难以复用
   
    //中介者模式（Mediator），用一个中介对象来封装一系列的对象交互。
    
    //MVC框架，其中的C(controller)就是一个中介者，叫做前端控制器（Front Controller），它的作用就是把M和V隔离开，协调M和V协同工作，减少M和V的依赖关系，用M提取的数据和V视图生成展示的页面。
    //膨胀问题。大量的代码根本不分层
    //MVC是由各种设计模式组成的复合结构，不同控制器使用同一个模型，因此模型回向观察中的控制器广播更新，很少用。。  fentchVC是这个模式
}


//pull-request。
//Key-Value Coding
//[object valueForKey:@"name"]
//[object setValue:@"Daniel" forKey:@"name"]
//- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;


//观察者
-(void)Observer
{
    //一对多的依赖关系，当对象的状态发生变化，依赖于它的对象都得到通知更新
    [self addObserver:self forKeyPath:@"design" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.design=@"zhangke";
    self.design=@"xxxx";
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //我们不推荐把 KVO 和多线程混起来。如果我们要用多个队列和线程，我们不应该在它们互相之间用 KVO。KVO 是同步运行的这个特性非常强大，只要我们在单一线程上面运行
    
    if([keyPath isEqualToString:@"design"]){
        id oldValue = change[NSKeyValueChangeOldKey];
        id newValue = change[NSKeyValueChangeNewKey];
    }
}

#if 0
- (void)setLComponent:(double)lComponent
{
//    我们关闭了 -willChangeValueForKey: 和 -didChangeValueForKey: 的自动调用，然后我们手动调用他们。我们只应该在关闭了自动调用的时候我们才需要在 setter 方法里手动调用 -willChangeValueForKey: 和 -didChangeValueForKey:。大多数情况下，这样优化不会给我们带来太多好处。
    if (_lComponent == lComponent) {
        return;
    }
    //变化开始调用willchange
    [self willChangeValueForKey:@"lComponent"];
    _lComponent = lComponent;
    //变化完后调用didChange
    [self didChangeValueForKey:@"lComponent"];
}
#endif



#pragma mark --对象集合

//组合
-(void)Composite
{
    //部分－整体，树形结构
    
    //点＋线＋符号组成了矢量图形
    //UIView，各子view，一起组成了视图，addsubview
    //self.view.subviews
    
    //内部不暴露给调用
}

//迭代器
-(void)Iterator
{
    //对list遍历其中的元素并将其返回，有index变量纪录当前位置，用来遍历各种类型的组合对象
    
    //NSEnumerator，cocoa框架提供迭代器
    NSEnumerator* ator=[[NSEnumerator alloc] init];
    [ator nextObject];
    
    NSArray* array=[NSArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
        
    }];
//    if(stop){
//        break;
//    }
    
    //自己做iterator，就是遍历对象数组
}


#pragma mark --行为扩展

//访问者
-(void)Visitor
{
    //让管道工进门修水管
    
    //让visitor来访问和完成具体的操作
    //操作具体组合内的各子类，生成想要的组合后的东西
}

//装饰
-(void)Component
{
    //相框，可以动态增加和删除
    //动态地给一个对象添加额外的职责
    
    //就是类别，uiimage＋transform，uiimage＋shadow
    //向类添加行为，实现装饰模式，
    //动态绑定，objc_runtime，动态添加，seletor
}

//响应链
-(void)ResponsChain
{
    //多个对象处理请求，在运行时才能确定那个类处理
    
    //delegate，当前类能够处理改请求才处理，不能处理就传递给下一个响应者
    
    //widget，view，viewcontoller发出，action类
    
    //盾，盔甲，玩家
}


#pragma mark --算法封装

//模版方法
-(void)Template
{
    //父类实现不可变部分，子类实现可变，配合工厂方法使用
    
    //labelWidget 只创建个label，子labelW，可以添加textfield
    
    //经常调用［super xxxx］
}

//策略
-(void)Strategy
{
    //算法的封装，独立于调用者而变化
    
    //运用策略模式，把输入验证抽象出来，写成一个单独的类，在需要的地方调用岂不是很方便。

    //数字和字母验证
}

//命令
-(void)Command
{
    //执行 execute action
    //支持撤销和恢复，支持事务
    
    //栈操作，恢复栈

    NSMethodSignature* met=[self methodSignatureForSelector:@selector(Strategy)];
    NSInvocation* ai=[NSInvocation invocationWithMethodSignature:met];
    
    NSUndoManager* undo=[[NSUndoManager alloc] init];
    [undo prepareWithInvocationTarget:self];
    
    
}


#pragma mark --性能与对象访问

//享元
-(void)Flyweight
{
    //会有很多对象，同类的，在内存中全部保存影响性能
    
    //明显就是 ios的重用机制，不显示的不创建出对象
    
    //通过重用减少对象数量，
}

//代理
-(void)Proxy
{
    //为不同地址空间提供本地代表
    
    //作为占位或代替对象
    NSProxy* xx= [NSProxy alloc];
    
    [xx forwardInvocation:nil];
    [xx methodSignatureForSelector:@selector(go)];
    
    //懒加载
    //zk
}


#pragma mark --对象状态

//备忘录
-(void)Memento
{
    //app保存自身状态，游戏退出，保存等级，装备，金币等
    
    //点保存，备忘录取得数据对象，writetofile
    
    //直接归档对象到文件
    //[NSKeyedArchiver archiveRootObject:self toFile:afile];
}




@end
