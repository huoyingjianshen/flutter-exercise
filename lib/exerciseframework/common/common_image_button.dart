import 'package:flutter/material.dart';
import 'package:flutter_exercise/utils/resize_utils.dart';

class CommonImageButton extends StatefulWidget {
  final double width;
  final double height;
  //按钮类型
  final ButtonType buttonType;
  final BorderRadiusGeometry borderRadius;
  final Widget child;
  final Function onTapDown;
  final Function onTapUp;
  final Function onTapCancel;
  //置灰不可点击
  final bool disable;
  //按压蒙层颜色
  final Color pressColor;
  //置灰蒙层颜色
  final Color disableColor;

  CommonImageButton(
      {Key key,
      this.width,
      this.height,
      this.buttonType = ButtonType.DEFAULT,
      this.borderRadius,
      this.child,
      this.onTapDown,
      this.onTapUp,
      this.onTapCancel,
      this.disable = false,
      this.pressColor,
      this.disableColor,
      }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CommonImageButtonState();
}

class CommonImageButtonState extends State<CommonImageButton> {
  var isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        width: widget.width != null ? widget.width : resizeUtil(45),
        height: widget.height != null ? widget.height : resizeUtil(45),
        duration: Duration(milliseconds: 100),
        foregroundDecoration: BoxDecoration(
          color: widget.disable ? (widget.disableColor != null ? widget.disableColor : getDisableColor(widget.buttonType)) : 
                (isDown ? (widget.pressColor != null ? widget.pressColor : getPressColor(widget.buttonType)) : Colors.transparent),
          borderRadius: widget.borderRadius != null ? widget.borderRadius : BorderRadius.circular(resizeUtil(22.5)),
        ),
        child: widget.child != null ? widget.child : Image.asset(getButtonImage(widget.buttonType)),
      ),
      onTapDown: (d) => setState(() {
        if (!widget.disable) {
          this.isDown = true;
          if (widget.onTapDown != null) {
            widget.onTapDown();
          }
        }
      }),
      onTapUp: (d) => setState(() {
        this.isDown = false;
        if (widget.onTapUp != null) {
          widget.onTapUp();
        }
      }),
      onTapCancel: () => setState(() {
        this.isDown = false;
        if (widget.onTapCancel != null) {
          widget.onTapCancel();
        }
      }),
    );
  }
}

String getButtonImage(ButtonType buttonType) {
  switch (buttonType) {

    case ButtonType.SUBMIT:
      return 'assets/res/drawable/ic_submit_common_image_button.png';

    case ButtonType.TIP:
      return 'assets/res/drawable/ic_tip_common_image_button.png';

    case ButtonType.DELETE:
      return 'assets/res/drawable/ic_clear_common_image_button.png';

    case ButtonType.REVOKE:
      return 'assets/res/drawable/ic_revoke_common_image_button.png';

    case ButtonType.EXPLICATE:
      return 'assets/res/drawable/ic_explicate_common_image_button.png';

    case ButtonType.PAINT:
      return 'assets/res/drawable/ic_paint_common_image_button.png';

    case ButtonType.ERASER:
      return 'assets/res/drawable/ic_eraser_common_image_button.png';

    case ButtonType.DRAFT:
      return 'assets/res/drawable/ic_draft_common_image_button.png';

    default:
      return 'assets/res/drawable/ic_submit_common_image_button.png';
  }
}

Color getPressColor(ButtonType buttonType) {
  switch (buttonType) {

    case ButtonType.SUBMIT:
      return const Color(0x66006669);

    case ButtonType.TIP:
      return const Color(0x660017B4);

    case ButtonType.DELETE:
      return const Color(0x660043CC);

    case ButtonType.REVOKE:
      return const Color(0x668707FF);

    case ButtonType.EXPLICATE:
      return const Color(0x66D65D00);

    case ButtonType.PAINT:
      return const Color(0x66006269);

    case ButtonType.ERASER:
      return const Color(0x66FF47B4);

    case ButtonType.DRAFT:
      return const Color(0x66FF9700);

    default:
      return const Color(0x66006669);
  }
}

Color getDisableColor(ButtonType buttonType) {
  switch (buttonType) {

    case ButtonType.SUBMIT:
      return const Color(0x6600BB89);

    case ButtonType.TIP:
      return const Color(0x666D96EA);

    case ButtonType.DELETE:
      return const Color(0x662FB0F0);

    case ButtonType.REVOKE:
      return const Color(0x66C088F5);

    case ButtonType.EXPLICATE:
      return const Color(0x66E8B650);

    case ButtonType.PAINT:
      return const Color(0x6600B9B4);

    case ButtonType.ERASER:
      return const Color(0x66FFBFE5);

    case ButtonType.DRAFT:
      return const Color(0x66ffc859);

    default:
      return const Color(0x66006669);
  }
}

enum ButtonType {
  //确认
  SUBMIT,
  //提示
  TIP,
  //删除
  DELETE,
  //撤销
  REVOKE,
  //解释
  EXPLICATE,
  //书写
  PAINT,
  //橡皮
  ERASER,
  //草稿
  DRAFT,
  //默认
  DEFAULT,
}
