import 'package:flutter/material.dart';
import 'package:shrink_wrap/shrink_wrap.dart';

import 'Screen.dart';

class HomePage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  HomePage(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState(scaffoldKey);
}

class HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey;

  HomePageState(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("widget.title")),
      backgroundColor: Colors.grey.shade300,
      endDrawer: new Drawer(
        width: 250,
      ),
      body: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.all(8),
        separatorBuilder: (_, __) => const SizedBox(height: 6),
        itemBuilder: (ctx, index) => Item(scaffoldKey),
      ),
    );
  }

  void clickClose() {
    print("有诶有到home????");
    Navigator.pop(context);
  }
}

class Item extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  Item(this.scaffoldKey, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('images/luckin.png'),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    this.scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: Text("打开策划"),
                ),
                const Text('瑞辛咖啡',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(children: const [
                  Text('4.7分',
                      style: TextStyle(color: Colors.deepOrangeAccent)),
                  SizedBox(width: 4),
                  Text('月售7000', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('人均￥19', style: TextStyle(color: Colors.grey)),
                  Spacer(),
                  Text('某团专送',
                      style: TextStyle(color: Colors.deepOrangeAccent)),
                ]),
                Row(children: const [
                  Text('起送￥15', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('配送 约￥4', style: TextStyle(color: Colors.grey)),
                  Spacer(),
                  Text('30分钟', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 4),
                  Text('1.3km', style: TextStyle(color: Colors.grey)),
                ]),
                LabelWidget(
                  children: List.generate(tags.length, (i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border:
                              Border.all(width: 1, color: Colors.redAccent)),
                      child: Text(tags[i],
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 10)),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static List<String> tags = [
    '新客立减3元',
    '28减2',
    '50减3',
    '80减5',
    '110减8',
    '9折起',
    '收藏领2元券',
    '下单送赠品',
  ];
}

class LabelWidget extends StatefulWidget {
  final List<Widget> children;
  final double spacing, runSpacing;
  final int maxLines;

  const LabelWidget(
      {Key? key,
      required this.children,
      this.spacing = 3,
      this.runSpacing = 2,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  GlobalKey wrapUniqueKey = GlobalKey();
  final ValueNotifier<int> totalRowCount = ValueNotifier(0);
  bool expand = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var renderObject = wrapUniqueKey.currentContext?.findRenderObject();
      if (renderObject == null) return;
      totalRowCount.value = (renderObject as RenderShrinkWrap).totalRowCount;
    });
  }

  @override
  void dispose() {
    totalRowCount.dispose();
    super.dispose();
  }

  static const Widget spacerButton = SizedBox(width: 14);

  // static const Widget upButton = Icon(Icons.arrow_drop_up_rounded, color: Colors.black54, size: 14);
  // static const Widget downButton = Icon(Icons.arrow_drop_down_rounded, color: Colors.black54, size: 14);
  static const Widget upButton =
      Icon(Icons.keyboard_arrow_up, color: Colors.black54, size: 14);
  static const Widget downButton =
      Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 14);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (totalRowCount.value <= widget.maxLines) return;
        setState(() => expand = !expand);
      },

      // height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("data"),
              ValueListenableBuilder(
                valueListenable: totalRowCount,
                builder: (_, __, ___) {
                  if (totalRowCount.value <= widget.maxLines)
                    return spacerButton;
                  return expand ? upButton : downButton;
                },
              )
            ],
          ),

          Row(
            children: [
              Expanded(
                child: ShrinkWrap(
                  key: wrapUniqueKey,
                  spacing: widget.spacing,
                  runSpacing: widget.runSpacing,
                  maxLines: expand ? 0 : widget.maxLines,
                  children: widget.children,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
