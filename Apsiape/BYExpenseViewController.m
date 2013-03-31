//
//  BYExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 17.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseViewController.h"
#import "BYExpenseInputView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "InterfaceConstants.h"
#import "BYQuickShotView.h"

@interface BYExpenseViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Expense *expense;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) BYExpenseInputView *expenseInputView;

@end

@implementation BYExpenseViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    return _scrollView;
}

- (BYExpenseInputView *)expenseInputView {
    if (!_expenseInputView) _expenseInputView = [[BYExpenseInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, EXPENSE_INPUT_VIEW_HEIGHT)];
    return _expenseInputView;
}

- (BYQuickShotView *)quickShotView {
    if (!_quickShotView) _quickShotView = [[BYQuickShotView alloc]init];
    return _quickShotView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return nil;
}

- (id)initWithExpense:(Expense *)expense
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.expense = expense;
        self.view.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.view addSubview:self.expenseInputView];
    [self.view addSubview:self.scrollView];
    
    CGSize contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.view.frame.size.height);
    self.scrollView.contentSize = contentSize;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor grayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.quickShotView.frame = CGRectMake(5, 5, 310, 310);
//    [self.scrollView addSubview:self.quickShotView];
    
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, 0, 320, 260)];
    [self.scrollView addSubview:keyboard];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
