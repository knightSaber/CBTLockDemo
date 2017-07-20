//
//  ViewController.m
//  CBTLockDemo
//
//  Created by 陈波涛 on 2017/7/20.
//  Copyright © 2017年 microfastup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self producerFunc];
    [self consumerFunc];
}

//生产者
- (void)producerFunc{
    
    __block int count = 0;
    
    //生产者生成数据
    dispatch_queue_t t = dispatch_queue_create("222222", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(t, ^{
        while (YES) {
            count++;
            int t = random()%10;
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            [self.array addObject:[NSString stringWithFormat:@"%zd",t]];
            dispatch_semaphore_signal(self.semaphore);
            NSLog(@"生产了%zd",count);
            
        }
    });
}

//消费者
- (void)consumerFunc{
    
    __block int count = 0;
    
    //消费者消费数据
    
    dispatch_queue_t t1 = dispatch_queue_create("11111", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(t1, ^{
        
        while (YES) {
            if (self.array.count > 0) {
                count++;
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
                [self.array removeLastObject];
                dispatch_semaphore_signal(self.semaphore);
                NSLog(@"消费了%zd",count);
            }
        }
    });
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return  _array;
}

- (dispatch_semaphore_t)semaphore{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}


@end
