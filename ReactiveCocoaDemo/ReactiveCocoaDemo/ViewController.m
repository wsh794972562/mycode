//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by wsh on 16/4/12.
//  Copyright © 2016年 wsh. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RedView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet RedView *redView;

@property (nonatomic, assign) int age;

@end


@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求最新商品");
        
        // 发送数据
        [subscriber sendNext:@"最新商品"];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 处理信号
        NSLog(@"请求最新商品");
        
        // 发送数据
        [subscriber sendNext:@"最新商品"];
        return nil;
    }];
    
    
    // RAC：就可以判断两个信号有没有都发出内容
    // SignalsFromArray:监听哪些信号的发出
    // 当signals数组中的所有信号都发送sendNext就会触发方法调用者（self）的Selector
    // 注意：selector方法的参数不能乱写，有几个信号就对应几个参数
    [self rac_liftSelector:@selector(updateUIWithHot:new:) withSignalsFromArray:@[signalA,signalB]];

}



- (void)updateUIWithHot:(NSString *)hot new:(NSString *)new {
    NSLog(@"更新UI");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age++;
}


// 5.监听文本框文字的改变
- (void)textChang {
    // 监听文本框
    // 获取文本框文字改变的信号
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// 4.监听通知
- (void)notification {
    
    // 监听通知
    // 只要发出这个通知，又会转换成一个信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"弹出键盘");
    }];
}


// 3.监听事件
- (void)event {
    // 监听事件
    // 只要产生UIControlEventTouchUpInside就会转换成信号
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了button");
    }];
}


// 2.RAC替换KVO
- (void)KVO {
    
    // 2.RAC替换KVO
    // 监听那个对象的属性改变
    // 方法调用者：就是被监听的对象
    // KeyPath:监听的属性
    
    // 把监听到的内容转换成信号
    [[self rac_valuesForKeyPath:@"age" observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


// 1.RAC替换代理
- (void)delegate {
    
    // 1.RAC替换代理
    // RAC:判断一个方法有没有被调用，如果调用了就自动发送一个消息给你
    
    [[_redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"控制器知道，点击了红色的view");
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
