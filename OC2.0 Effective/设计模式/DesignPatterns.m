//
//  DesignPatterns.m
//  OC2.0 Effective
//
//  Created by zhangke on 15/5/3.
//  Copyright (c) 2015年 zhangke. All rights reserved.
//

#import "DesignPatterns.h"

@implementation DesignPatterns

/* 创建型模式 */

//原型
-(void)prototype
{
    //类不容易创建，复制更容易，大量对象的情况也可以用
   
    //深拷贝，复制一份图像，或者游戏中的敌人
    
//    nscopying
//    copywithzone
    
}

//工厂方法模式
-(void)factoryCreator
{
    //想让类在运行时创建
    
    //＋－＊／，运行时生成不同的产品，根据表模式来写
}

//抽象工厂模式
-(void)abstractFactory
{
    //创建多系列产品
    
    //日用品工厂生产日用品，牙膏厂继承于日用品厂，生产联合利华和宝洁的牙膏，洗发水厂生产联合利华和宝洁的洗发水，2个品牌的牙膏和洗发水都继承于牙膏和洗发水的抽象
    //抽象工厂返回抽象产品
    //一开始使用具体工厂，重构为使用多个具体工厂的抽象工厂
}

//生成器模式
-(void)builder
{
    //构建复杂对象，各个步骤装配各部件
    
    //构建游戏角色，builder负责生成角色，然后分步骤函数配置属性
    //力量，智力，玩家，敌人等
}

//生成器模式
-(void)singleton
{
    //只有一个实例，从一个访问方法访问
    //静态全局变量保证类的实例的唯一性
    
    //copywithzone return self;
    
    //单例线程安全，同步块，lock，单例多线程同时读写有问题，
    //用once吧。。。
    //uiapplication nsfilemanager, nsbundle,nsobserver
    
}



@end
