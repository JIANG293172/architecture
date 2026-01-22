//
//  ViewController.m
//  Demo
//
//  Created by CQCA202121101_2 on 2025/12/5.
//

#import "ViewController.h"
#import "BViewController.h"

@interface ViewController ()
@property (nonatomic ,strong) UIViewController *vc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.vc = [BViewController new];
//    [self.navigationController pushViewController:self.vc  animated:YES];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.navigationController pushViewController:[BViewController new]  animated:YES];

    
}

@end
