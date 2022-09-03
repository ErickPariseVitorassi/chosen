import 'package:chosen/components/chosen_controller.dart';
import 'package:flutter/material.dart';

class ChosenContainer extends StatefulWidget {
  final String? text;
  final String hintText;
  final double buttonHeight;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final InputBorder disabledBorder;
  final double? dropdownMaxHeight;
  final ChosenController? controller;
  final Widget child;

  const ChosenContainer({
    Key? key,
    this.text,
    this.hintText = '',
    this.buttonHeight = 34,
    this.enabledBorder = InputBorder.none,
    this.focusedBorder = InputBorder.none,
    this.disabledBorder = InputBorder.none,
    this.dropdownMaxHeight = 400,
    this.controller,
    required this.child,
  }) : super(key: key);

  factory ChosenContainer.border(
    BuildContext context, {
    String? text,
    String hintText = '',
    double buttonHeight = 34,
    double? dropdownMaxHeight = 400,
    ChosenController? controller,
    required Widget child,
  }) {
    return ChosenContainer(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffECEDF2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffC4C9D6)),
      ),
      text: text,
      hintText: hintText,
      buttonHeight: buttonHeight,
      dropdownMaxHeight: dropdownMaxHeight,
      controller: controller,
      child: child,
    );
  }

  @override
  State<ChosenContainer> createState() => _ChosenContainerState();
}

class _ChosenContainerState extends State<ChosenContainer>
    with TickerProviderStateMixin {
  late GlobalKey _actionKey;
  late OverlayEntry _floatingDropdown;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late ChosenController _controller;

  @override
  void initState() {
    super.initState();

    _actionKey = LabeledGlobalKey(widget.text);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));

    _controller = widget.controller ?? ChosenController();
    _controller.addListener(() {
      if (_controller.isOpened) {
        _animationController.forward();
        setState(() {
          _floatingDropdown = _createFloatingDropdown();
          Overlay.of(context)?.insert(_floatingDropdown);
        });
      } else {
        _animationController.reverse().then(
              (_) => setState(() {
                _floatingDropdown.remove();
              }),
            );
      }
    });
  }

  _WidgetInfo _getDropdownInfo() {
    final renderBox =
        _actionKey.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return _WidgetInfo(offset: offset, size: renderBox.size);
  }

  OverlayEntry _createFloatingDropdown() {
    final parentInfo = _getDropdownInfo();

    return OverlayEntry(builder: (context) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => _controller.isOpened = false,
            behavior: HitTestBehavior.opaque,
          ),
          Container(
            width: parentInfo.size.width,
            margin: EdgeInsets.only(
              top: parentInfo.offset.dy + parentInfo.size.height,
              left: parentInfo.offset.dx,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SizeTransition(
              sizeFactor: _expandAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.dropdownMaxHeight ?? double.infinity,
                    minWidth: double.infinity,
                  ),
                  child: SingleChildScrollView(child: widget.child),
                  //width: double.maxFinite,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTextNull = widget.text == null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: _actionKey,
        onTap: () => _controller.isOpened = true,
        child: SizedBox(
          height: widget.buttonHeight,
          child: InputDecorator(
            decoration: InputDecoration(
              enabledBorder: widget.enabledBorder,
              disabledBorder: widget.disabledBorder,
              focusedBorder: widget.focusedBorder,
              contentPadding: EdgeInsets.zero,
              suffixIcon: RotationTransition(
                turns: _rotateAnimation,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _controller.isOpened ? const Color(0xff014C8B) : null,
                ),
              ),
            ),
            isFocused: _controller.isOpened,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Text(
                widget.text ?? widget.hintText,
                maxLines: 1,
                style: Theme.of(context).textTheme.caption?.copyWith(
                      height: 1.4,
                      color: isTextNull
                          ? const Color(0xffA1A9BA)
                          : const Color(0xff697081),
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WidgetInfo {
  final Offset offset;
  final Size size;

  _WidgetInfo({required this.offset, required this.size});
}
