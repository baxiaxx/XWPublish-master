//
//  XWPublishController.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWPublishController.h"

#import "PlaceholderTextView.h"

//默认最大输入字数为  kMaxTextCount  300
#define kMaxTextCount 300

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height//获取设备高度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width//获取设备宽度

@interface XWPublishController ()<UITextViewDelegate,UIScrollViewDelegate>{
 
    //备注文本View高度
    float noteTextHeight;
    float pickerViewHeight;
    float allViewHeight;
    PlaceholderTextView * noteTextView;
}




/**
 *  主视图-
 */
@property (weak, nonatomic) IBOutlet UIScrollView *mianScrollView;

////联系电话和邮件号码
@property(nonatomic,strong)UITextField *phoneAndMailTextFlied;



@end

@implementation XWPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mianScrollView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1 ];
    //收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [_mianScrollView setDelegate:self];
    self.showInView = _mianScrollView;
    
    [self initPickerView];
    
    [self initViews];
}
/**
 *  取消输入
 */
- (void)viewTapped{
    [self.view endEditing:YES];
}
/**
 *  初始化视图
 */
- (void)initViews{
    _noteTextBackgroudView = [[UIView alloc]init];
    _noteTextBackgroudView.backgroundColor = [UIColor whiteColor];
    

    
   noteTextView = [[PlaceholderTextView alloc]init];
    noteTextView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    noteTextView.placeholder = @"如果使用中有什么不好的地方请大声说出来!我们会每天关注您的反馈,为您提供更好的服务和产品体验!";
    noteTextView.font = [UIFont systemFontOfSize:15];
    noteTextView.maxLength = 300;
    noteTextView.layer.cornerRadius = 5.f;
        noteTextView.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3].CGColor;
    [noteTextView didChangeText:^(PlaceholderTextView *textView) {
        NSLog(@"%@",textView.text);
    }];
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:13];
    _textNumberLabel.textColor = [UIColor blackColor];
    _textNumberLabel.backgroundColor = [UIColor whiteColor];
    
    _explainLabel = [[UILabel alloc]init];
    _explainLabel.text = [NSString stringWithFormat:@"联系方式"];
    //发布按钮颜色
    _explainLabel.textColor = [UIColor blackColor];
    _explainLabel.textAlignment = NSTextAlignmentCenter;
    _explainLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    self.phoneAndMailTextFlied = [[UITextField alloc]init];
     self.phoneAndMailTextFlied.placeholder =@"手机号码/邮箱选填,便于联系您";
    self.phoneAndMailTextFlied.backgroundColor = [UIColor whiteColor];
    
    
    //发布按钮样式->可自定义!
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor blueColor]];
    
    //圆角
    //设置圆角
    [_submitBtn.layer setCornerRadius:4.0f];
    [_submitBtn.layer setMasksToBounds:YES];
    [_submitBtn.layer setShouldRasterize:YES];
    [_submitBtn.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [_mianScrollView addSubview:_noteTextBackgroudView];
    [_mianScrollView addSubview:noteTextView];
    [_mianScrollView addSubview:_textNumberLabel];
    [_mianScrollView addSubview:_explainLabel];
    [_mianScrollView addSubview:self.phoneAndMailTextFlied];
    [_mianScrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}
/**
 *  界面布局 frame
 */
- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = 130;
    }
    
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    
    //文本编辑框
    noteTextView.frame = CGRectMake(10, 0, SCREENWIDTH - 20, noteTextHeight);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, noteTextView.frame.origin.y + noteTextView.frame.size.height-15, SCREENWIDTH-10, 0);
    
    
    //photoPicker
    [self updatePickerViewFrameY:_textNumberLabel.frame.origin.y + _textNumberLabel.frame.size.height +10];
    
    
    //说明文字
//    _explainLabel.frame = CGRectMake(0, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+5, SCREENWIDTH, 40);
    _explainLabel.backgroundColor = [UIColor whiteColor];
    _explainLabel.frame = CGRectMake(5, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+5, 100, 44);
    self.phoneAndMailTextFlied.frame = CGRectMake(105, [self getPickerViewFrame].origin.y+[self getPickerViewFrame].size.height+5, SCREENWIDTH -110, 44);

    
    //发布按钮
    _submitBtn.bounds = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    _submitBtn.frame = CGRectMake(10, _explainLabel.frame.origin.y+_explainLabel.frame.size.height +30, SCREENWIDTH -20, 40);
    
    
    allViewHeight = noteTextHeight + [self getPickerViewFrame].size.height + 30 + 100;
    
    _mianScrollView.contentSize = self.mianScrollView.contentSize = CGSizeMake(0,allViewHeight);
}

/**
 *  恢复原始界面布局
 */
-(void)resumeOriginalFrame{
    _noteTextBackgroudView.frame = CGRectMake(0, 0, SCREENWIDTH, noteTextHeight);
    //文本编辑框
    noteTextView.frame = CGRectMake(15, 0, SCREENWIDTH - 30, noteTextHeight);
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(0, _noteTextView.frame.origin.y + _noteTextView.frame.size.height-15, SCREENWIDTH-10, 15);
}

- (void)pickerViewFrameChanged{
    [self updateViewsFrame];
}

/**
 *  发布按钮点击事件
 */
- (void)submitBtnClicked{
    //检查输入
//    if (![self checkInput]) {
        return;
//    }
    //输入正确将数据上传服务器->
    [self submitToServer];
}



#warning 在此处上传服务器->>
#pragma mark - 上传数据到服务器前将图片转data（上传服务器用form表单：未写）
- (void)submitToServer{
    
    // 可以选择上传大图数据或者小图数据->
    
    //大图数据
    NSArray *bigImageDataArray = [self getBigImageArray];
    
    //小图数组
    NSArray *smallImageArray = self.imageArray;
    
    //小图二进制数据
    NSMutableArray *smallImageDataArray = [NSMutableArray array];
    
    for (UIImage *smallImg in smallImageArray) {
        NSData *smallImgData = UIImagePNGRepresentation(smallImg);
        [smallImageDataArray addObject:smallImgData];
    }
    NSLog(@"上传服务器... +++ 文本内容:%@",_noteTextView.text);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"发布成功!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:actionCacel];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"内存警告...");
}
- (IBAction)cancelClick:(UIButton *)sender {

     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
//用户向上偏移到顶端取消输入,增强用户体验
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"偏移量 scrollView.contentOffset.y:%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < 0) {
        [self.view endEditing:YES];
    }
    //NSLog(@"scrollViewDidScroll");
}
@end
