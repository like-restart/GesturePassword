//
//  LKGesturePasswordView.m
//  融贝网
//
//  Created by like on 2018/8/20.
//  Copyright © 2018年 No Company. All rights reserved.
//

#define GESTURE_SINGLE_BUTTON_TAG_START 1000

#import "LKGesturePasswordView.h"
#import "LKCodeTools.h"//tools

@interface LKGesturePasswordView ()
{
    NSInteger theLastButtonIndex;//保存被触摸的最后一次的按钮的下标值，用于排除连续多次在同一个按钮上游荡
}

@property (nonatomic, readwrite, strong) NSMutableArray *pointsArray;//存放路过的按钮的中心点，用于绘制连接线
@property (nonatomic, readwrite, strong) UIView *intervalGestureView;//layer放到了最上面，失去了基本的连线效果，所以添加一个中间的view层次来安放layer

//以下变量用于直线的绘制
@property (nonatomic, readwrite, strong) CAShapeLayer *lineShapeLayer;//承载绘制过程中产生的跟着手指改变的连线
@property (nonatomic, readwrite, strong) NSMutableArray *centerPointArray;//按钮中心点的保存数组
@end

@implementation LKGesturePasswordView

#pragma mark - - Create UI - -
/*!
 * 添加9个手势按钮
 */
- (void)layoutSingleButtonControls
{
    //x 和 y 之间的间隔值
    CGFloat interval_xy = 94*Standard;
    
    for (int i = 0; i < 9; i ++) {
        LKGesturePasswordSingleButton *gestureButton = [LKGesturePasswordSingleButton buttonWithType:UIButtonTypeCustom];
        gestureButton.frame = CGRectMake(i%3*interval_xy, i/3*interval_xy, 53*Standard, 53*Standard);
        gestureButton.tag = GESTURE_SINGLE_BUTTON_TAG_START + i;
        [gestureButton layoutSingleButtonControls];
        [self addSubview:gestureButton];
        [self bringSubviewToFront:gestureButton];
        
        //创建的时候保存一下中心点
        CGPoint centerPoint = CGPointMake(gestureButton.frame.origin.x+gestureButton.frame.size.width/2, gestureButton.frame.origin.y+gestureButton.frame.size.height/2);
        [self.centerPointArray addObject:[NSValue valueWithCGPoint:centerPoint]];
    }
}

/*!
 * 添加9个手势按钮-缩小版
 */
- (void)layoutLittleSingleButtonControls
{
    //x 和 y 之间的间隔值
    CGFloat interval_xy = 13*Standard;
    
    for (int i = 0; i < 9; i ++) {
        LKGesturePasswordSingleButton *gestureButton = [LKGesturePasswordSingleButton buttonWithType:UIButtonTypeCustom];
        gestureButton.frame = CGRectMake(i%3*interval_xy, i/3*interval_xy, 9*Standard, 9*Standard);
        gestureButton.tag = GESTURE_SINGLE_BUTTON_TAG_START + i;
        [gestureButton layoutSingleButtonControls];
        [self addSubview:gestureButton];
        [self bringSubviewToFront:gestureButton];
    }
}

#pragma mark - - UITouch Event - -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    theLastButtonIndex = 9;//每次重新触摸屏幕的时候，重置此值
    [self.pointsArray removeAllObjects];//每次重新触摸屏幕的时候，清空数组
    UITouch *touch = [touches anyObject];
    //touch的坐标
    CGPoint touchPoint = [touch locationInView:self];
    [self setHighlightedStateWithPoint:touchPoint withIsTouchesEnded:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //touch的坐标
    CGPoint touchPoint = [touch locationInView:self];
    [self setHighlightedStateWithPoint:touchPoint withIsTouchesEnded:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //结束绘制，且不可继续绘制，然后进行数据验证
    self.userInteractionEnabled = NO;
    
    UITouch *touch = [touches anyObject];
    //touch的坐标
    CGPoint touchPoint = [touch locationInView:self];
    [self setHighlightedStateWithPoint:touchPoint withIsTouchesEnded:YES];
}

/*!
 * 根据坐标值来寻找frame相接触的button，并设置stateType
 *
 * @param touchPoint Touch事件所获得的坐标值
 * @param isTouchesEnded Touch事件-ended:密码绘制完成，需要进行其他额外操作
 */
- (void)setHighlightedStateWithPoint:(CGPoint)touchPoint withIsTouchesEnded:(BOOL)isTouchesEnded
{
    self.lineShapeLayer = nil;//每次执行此方法的时候，都需要先移出临时的连线，否则会出现重合的情况
    NSInteger button_index = [self getButtonTagWithPoint:touchPoint];
    LKGesturePasswordSingleButton *gestureButton = (LKGesturePasswordSingleButton *)[self viewWithTag:GESTURE_SINGLE_BUTTON_TAG_START+button_index];
    if (button_index < 9 && (gestureButton.stateType != GesturePasswordButtonStateType_Highlighted || isTouchesEnded)) {//初始值为9，避免没有任何接触的情况
        
        /*!
         * if语句判断说明：
         * 1. gestureButton 必须存在
         * 2. CGRectIntersectsRect 手指直接碰触到了按钮，判断frame有接触
         * 3. button_index 保证前后两次不是同一个按钮，排除在同一个按钮上来回处理
         * 4. highlighted 排除已被设置为高亮的按钮，防止一个按钮被多次设置
         */
        if (gestureButton && CGRectIntersectsRect(gestureButton.frame, CGRectMake(touchPoint.x, touchPoint.y, 1, 1))) {
            theLastButtonIndex = button_index;//设置新的下标值，用于下一次判断
            gestureButton.stateType = GesturePasswordButtonStateType_Highlighted;
            
            //take the line
            [self layoutShapeLayerWithButton:gestureButton];
            
            //protocol
            if ([self.gestureInputProtocol respondsToSelector:@selector(gesturePasswordWithButtonIndex:withInputState:)]) {
                [self.gestureInputProtocol gesturePasswordWithButtonIndex:button_index withInputState:isTouchesEnded];
            }
        }
    }else if (isTouchesEnded) {//最后TouchesEnded函数触发一定会出现不在按钮范围内，所以要排除此种情况
        //protocol
        if ([self.gestureInputProtocol respondsToSelector:@selector(gesturePasswordWithButtonIndex:withInputState:)]) {
            [self.gestureInputProtocol gesturePasswordWithButtonIndex:button_index withInputState:isTouchesEnded];
        }
    }else if (!isTouchesEnded && theLastButtonIndex < 9) {
        gestureButton = (LKGesturePasswordSingleButton *)[self viewWithTag:GESTURE_SINGLE_BUTTON_TAG_START+theLastButtonIndex];
        if (gestureButton) {
            //1. 获取中心点-即开始点
            CGPoint startPoint = CGPointMake(gestureButton.frame.origin.x+gestureButton.frame.size.width/2, gestureButton.frame.origin.y+gestureButton.frame.size.height/2);
            CGPoint endPoint = touchPoint;
            //在绘制直线的过程中，处理与直线相交且手指未直接接触按钮的按钮，从而设置Highlighted
            [self getPossibleButtonWithStartPoint:startPoint withEndPoint:endPoint];
            
            //添加连线
            CAShapeLayer *shapeLayer = [self getShapeLayerWithStartPoint:startPoint withEndPoint:endPoint];
            self.lineShapeLayer = shapeLayer;
            
            //当然在这里，也可以选择DrawRect方式 进行直线的不断重绘，CGShapeLayer虽然也是通过CPU进行了处理然后交与了GPU进行绘制，但也会比直接CPU绘制节约了一些资源
        }
    }
}

/*!
 * 查找最大可能相接触到的按钮，只是为了实现更精准查找，替代了（subviews 子视图遍历一一进行重叠判断），此方法最终在寻找出按钮的index之后，需要进行二次验证
 *
 * @param touchPoint Touch事件所获得的坐标值
 * @return 按钮的下标值
 */
- (NSInteger)getButtonTagWithPoint:(CGPoint)touchPoint
{
    //1. 获取x和y的实际值
    CGFloat touchPoint_x = touchPoint.x;
    CGFloat touchPoint_y = touchPoint.y;
    
    //2. 按钮之间的间隔为41，按钮的高宽为53
    CGFloat interval_wh = 41*Standard;
    CGFloat button_wh = 53*Standard;
    
    //3. 首先计算x有几个interval_wh+button_wh的间距，并且去掉相同个数的间距值
    NSInteger interval_wh_x = touchPoint_x/(interval_wh+button_wh);
    CGFloat index_x_tmp = touchPoint_x-interval_wh_x*(interval_wh+button_wh);
    
    //4. 其次计算y有几个interval_wh+button_wh的间距，并且去掉相同个数的间距值
    NSInteger interval_wh_y = touchPoint_y/(interval_wh+button_wh);
    CGFloat index_y_tmp = touchPoint_y-interval_wh_y*(interval_wh+button_wh);
    
    //3.4.可以把x和y的值缩放到第一个按钮的有效范围内，从而和第一个按钮的区间值进行比较
    
    NSInteger button_index = 9;//无效值
    if (index_x_tmp <= button_wh && index_y_tmp <= button_wh) {
        //5. x 和 y均在与button的重合范围内，计算出button_index的值
        button_index = interval_wh_x + interval_wh_y*3;
    }
    return button_index;
}

/*!
 * 绘制两两中心点之间的连线
 *
 * @param gestureButton touch事件触摸到的按钮
 */
- (void)layoutShapeLayerWithButton:(LKGesturePasswordSingleButton *)gestureButton
{
    //1. 获取中心点
    CGPoint centerPoint = CGPointMake(gestureButton.frame.origin.x+gestureButton.frame.size.width/2, gestureButton.frame.origin.y+gestureButton.frame.size.height/2);
    //2. 处理中心点数据，数组保存CGpoint数据，转换为NSValue
    NSValue *pointValue = [NSValue valueWithCGPoint:centerPoint];
    //3. 添加至数组，但是数组中不能同时包含两个相同的坐标点，防止自己给自己连线
    if (![self.pointsArray containsObject:pointValue]) {
        [self.pointsArray addObject:pointValue];
    }
    //4. 准备添加连线，当数组中有两个点的时候，可以进行绘制
    if ([self.pointsArray count] == 2) {
        //5. BezierPath 添加point | shapeLayer 设置颜色宽度等，并承载bezierpath
        CAShapeLayer *shapeLayer = [self getShapeLayerWithStartPoint:[self.pointsArray[0] CGPointValue] withEndPoint:[self.pointsArray[1] CGPointValue]];
        //7. 添加至view的layer层
        [self.intervalGestureView.layer addSublayer:shapeLayer];
        //8. 最重要的一步，删除数组中的第一个，1-2，2-3，3-4：所以每次删除firstobject
        [self.pointsArray removeObjectAtIndex:0];
    }
}

/*!
 * 根据起点和结束点来初始化获取ShapeLayer对象，调用此方法来获取并添加至view的layer层
 *
 * @param startPoint 起点
 * @param endPoint 结束点
 */
- (CAShapeLayer *)getShapeLayerWithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addLineToPoint:endPoint];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    UIColor *color_stroke = [UIColor colorWithHex:0x5FAFFC];
    shapeLayer.strokeColor = color_stroke.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = nil;
    return shapeLayer;
}

/*!
 * 根据手指绘制的起点（按钮的中心点）和结束点（手指接触屏幕的点）来计算出与所绘制直线相交的按钮（使用垂线的计算方式）
 *
 * @param startPoint 起点
 * @param endPoint 结束点
 */
- (void)getPossibleButtonWithStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint
{
    //遍历中心点坐标数组，找到与直线会相交的按钮
    for (int i = 0; i < [self.centerPointArray count]; i ++) {
        NSValue *pointValue = self.centerPointArray[i];
        CGPoint centerPoint = [pointValue CGPointValue];
        //我也不知道到底应该叫什么名字合适，暂且ABCDEF...吧
        CGFloat A = endPoint.y - startPoint.y;
        CGFloat B = startPoint.x - endPoint.x;
        CGFloat C = endPoint.x*startPoint.y - startPoint.x*endPoint.y;
        
        //中心点到直线的距离，俗称垂线，fabs 取正数
        CGFloat centerPointToLine = fabs((A*centerPoint.x+B*centerPoint.y+C)/sqrt(A*A+B*B));
        //计算垂足坐标值，用于来判断垂足在线段之内，否则会出现混乱
        CGFloat footPoint_x = (B*B*centerPoint.x-A*B*centerPoint.y-A*C)/(A*A+B*B);
        CGFloat footPoint_y = (-A*B*centerPoint.x+A*A*centerPoint.y-B*C)/(A*A+B*B);
        //超级恶心的判断，我自己想到的比较繁琐的比较，用于四种线段（以原点为基准，向↘|向↗|向↖|向↙）
        BOOL isValid_f = footPoint_x>startPoint.x && footPoint_x<endPoint.x && footPoint_y>startPoint.y && footPoint_y<endPoint.y;//向↘
        BOOL isValid_s = footPoint_x>startPoint.x && footPoint_x<endPoint.x && footPoint_y>endPoint.y && footPoint_y<startPoint.y;//向↗
        BOOL isValid_t = footPoint_x>endPoint.x && footPoint_x<startPoint.x && footPoint_y>endPoint.y && footPoint_y<startPoint.y;//向↖
        BOOL isValid_n = footPoint_x>endPoint.x && footPoint_x<startPoint.x && footPoint_y>startPoint.y && footPoint_y<endPoint.y;//向↙
        //取其一即可
        BOOL isValid_footPoint = isValid_f || isValid_s || isValid_t || isValid_n;
        
        //判断垂直距离是否小于圆的半径，如果小于，则证明相交了
        CGFloat radius = (53*Standard)/2;
        if (centerPointToLine > 0 && centerPointToLine <= radius && isValid_footPoint) {
            //1. 获取相交的按钮
            LKGesturePasswordSingleButton *gestureButton = (LKGesturePasswordSingleButton *)[self viewWithTag:GESTURE_SINGLE_BUTTON_TAG_START+i];
            //2. 判断state是否为highlighted
            if (gestureButton) {
                if (gestureButton.stateType != GesturePasswordButtonStateType_Highlighted) {
                    //3. 如果不是此状态，则标记为此状态
                    [self setHighlightedStateWithPoint:centerPoint withIsTouchesEnded:NO];
                    //只要出现一个即可break，尽可能的避免过多的循环（哭脸）
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - - Highlighted Gesture View - -
/*!
 * 改变传递参数数组内的按钮下标值所指向的按钮的图片
 * @param state_type 将要改变的按钮的状态
 * @param buttonIndex_array 存放按钮下标值的数组
 */
- (void)changeButtonStateWithStateType:(GesturePasswordButtonStateType)state_type withArray:(NSArray *)buttonIndex_array
{
    if (buttonIndex_array) {
        //快速枚举
        for (NSNumber *indexNumber in buttonIndex_array) {
            if (indexNumber) {
                NSInteger button_index = [indexNumber integerValue];
                LKGesturePasswordSingleButton *gestureButton = (LKGesturePasswordSingleButton *)[self viewWithTag:GESTURE_SINGLE_BUTTON_TAG_START+button_index];
                if (gestureButton) {
                    gestureButton.stateType = state_type;
                }
            }
        }
    }
}

#pragma mark - - Error Gesture View - -
/*!
 * 改变手势里面所有连接线的颜色（红色：error）
 */
- (void)changeErrorColorWithShapeLayerLine
{
    //快速枚举，改变颜色
    for (CAShapeLayer *shapeLayer in self.intervalGestureView.layer.sublayers) {
        if (shapeLayer) {
            UIColor *color_stroke = [UIColor colorWithHex:0xFC5F5F];
            shapeLayer.strokeColor = color_stroke.CGColor;
        }
    }
}

/*!
 * 改变手势里面被选中的按钮的图片（图片：error）
 */
- (void)changeErrorStateTypeWithGestureButton
{
    //快速枚举
    for (id object in self.subviews) {
        //排除其他类型的控件
        if (object && [object isKindOfClass:[LKGesturePasswordSingleButton class]]) {
            LKGesturePasswordSingleButton *singleButton = (LKGesturePasswordSingleButton *)object;
            if (singleButton.stateType == GesturePasswordButtonStateType_Highlighted) {//满足type_Highlighted
                singleButton.stateType = GesturePasswordButtonStateType_Error;
            }
        }
    }
}

#pragma mark - - Clear Gesture View - -
/*!
 * 移除所有的Layer（绘制的所有线段）
 */
- (void)removeShapeLayerFromView
{
    /*!
     * while语句，每次均会去判断数组的count值，只要不为零会一直循环，方法内使用firstObject来进行删除，说到底，只要不是代码错误导致获取了下标不存在的对象，就不会有问题
     * for-in快速枚举sublayers数组，会出现crash的问题，因为把layer从super中移除，同时也导致了正在进行枚举的layer数组发生了改变，也就是容器发生了改变，使得遍历器抛出异常，从而导致了crash问题，网络上有很多说是因为layer数组是不可变的，所以移除会发生crash，其实是不准确的，只是因为和for-in的结合使用相互作用的结果；
     */
    while (self.intervalGestureView.layer.sublayers.count) {
        [self.intervalGestureView.layer.sublayers.firstObject removeFromSuperlayer];
    }
    
    //2. 不会出现crash的现象，但是会出现遗漏，for循环的数组发生了改变，但是i 值是一直增长
//    for (int i = 0; i < [self.intervalGestureView.layer.sublayers count]; i ++) {
//        [self.intervalGestureView.layer.sublayers[i] removeFromSuperlayer];
//    }
    
    //3. for-in : <CALayerArray: 0x6040008504d0> was mutated while being enumerated
//    for (CAShapeLayer *layer in self.intervalGestureView.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
}

/*!
 * 改变手势里面被选中的按钮的图片（图片：normal）
 */
- (void)changeNormalStateTypeWithGestureButton
{
    //快速枚举
    for (id object in self.subviews) {
        //排除其他类型的控件
        if (object && [object isKindOfClass:[LKGesturePasswordSingleButton class]]) {
            LKGesturePasswordSingleButton *singleButton = (LKGesturePasswordSingleButton *)object;
            if (singleButton.stateType == GesturePasswordButtonStateType_Highlighted || singleButton.stateType == GesturePasswordButtonStateType_Error) {//非normal 转变为normal
                singleButton.stateType = GesturePasswordButtonStateType_Normal;
            }
        }
    }
    //解除不可点击的限制
    self.userInteractionEnabled = YES;
}

#pragma mark - - Setter and Getter - -
/*!
 * 承载layer的中间view，放到最底层，从而避免遮盖按钮
 */
- (UIView *)intervalGestureView
{
    if (!_intervalGestureView) {
        _intervalGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _intervalGestureView.backgroundColor = [UIColor clearColor];
        [self addSubview:_intervalGestureView];
        [self sendSubviewToBack:_intervalGestureView];
    }
    return _intervalGestureView;
}

/*!
 * 存放所有连接点的数组
 */
- (NSMutableArray *)pointsArray
{
    if (!_pointsArray) {
        _pointsArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _pointsArray;
}

- (void)setLineShapeLayer:(CAShapeLayer *)lineShapeLayer
{
    //因为会跟着手指位置的改变来绘制连线，所以多次重新绘制，需要先移出之前绘制的
    if (_lineShapeLayer) {
        [_lineShapeLayer removeFromSuperlayer];
        _lineShapeLayer = nil;
    }
    //赋值新的
    _lineShapeLayer = lineShapeLayer;
    if (_lineShapeLayer) {
        //添加至view的layer层
        [self.intervalGestureView.layer addSublayer:_lineShapeLayer];
    }
}

/*!
 * 创建一个保存九个按钮中心点的数组，用于计算点到直线的垂直距离，距离是否小于圆的半径，也就是按钮宽度的一半长度
 */
- (NSMutableArray *)centerPointArray
{
    if (!_centerPointArray) {
        _centerPointArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    return _centerPointArray;
}
@end
