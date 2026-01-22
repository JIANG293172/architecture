#import <UIKit/UIKit.h>

@interface BViewController : UIViewController
// 定义两个嵌套的Block属性（模拟你的场景）
@property (nonatomic, copy) void (^innerBlock)(void);
@property (nonatomic, copy) void (^innerBlock2)(void);
@property (nonatomic, copy) void (^tempBlock)(void);
@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ========== 测试1：错误写法（会导致循环引用，dealloc不执行） ==========
    [self testWrongBlock];
    
    // ========== 测试2：正确写法（无循环引用，dealloc正常执行） ==========
    // 注释掉上面的 testWrongBlock，打开下面的 testCorrectBlock 测试
    // [self testCorrectBlock];
}

#pragma mark - 错误写法（循环引用，self无法释放）
- (void)testWrongBlock {
    __weak typeof(self) weakSelf = self;
        
        self.innerBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            NSLog(@"innerBlock 执行：%@", strongSelf);
            
            strongSelf.innerBlock2 = ^{
                NSLog(@"innerBlock2 执行：%@", weakSelf);
                [weakSelf makelog];
            };
            
            strongSelf.innerBlock2();
        };
        
        // 关键新增：让全局单例持有innerBlock（长期存活，不销毁）
        self.tempBlock = self.innerBlock;
        
        self.innerBlock();
}


- (void)makelog {
    
}
#pragma mark - 验证是否释放（关键：看dealloc是否打印）
- (void)dealloc {
    NSLog(@"BViewController 被释放了！");
}

@end
