import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // 桌面端防闪退核心锁
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UltimateManifestationApp());
}

class UltimateManifestationApp extends StatelessWidget {
  const UltimateManifestationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '全息显化与能量操控台',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFF0F172A), // 深邃午夜蓝底色
      ),
      home: const EnergyDashboard(),
    );
  }
}

// ==========================================
// 数据模型定义
// ==========================================

class ManifestGoal {
  String title;
  String identity;
  List<String> affirmations;
  Color color;

  ManifestGoal({
    required this.title,
    required this.identity,
    required this.affirmations,
    required this.color,
  });
}

class InspirationOrder {
  String title;
  String details;
  String status;

  InspirationOrder({
    required this.title,
    required this.details,
    this.status = "处理中",
  });
}

// ==========================================
// 主操控台主页
// ==========================================

class EnergyDashboard extends StatefulWidget {
  const EnergyDashboard({super.key});

  @override
  State<EnergyDashboard> createState() => _EnergyDashboardState();
}

class _EnergyDashboardState extends State<EnergyDashboard> with TickerProviderStateMixin {
  late List<ManifestGoal> _goals;
  int _selectedIndex = 0;

  late String _currentAffirmation;
  int _vibeHz = 1024;

  // 自定义/TXT文本直灌控制器
  final TextEditingController _customAffInputController = TextEditingController();

  // 圣多纳释放引导流状态 (纯内在引导，无输入)
  int _sedonaStep = 0;
  String _selectedRootCause = "";

  // MD 潜意识防线引导流状态 (分为三大实操版本引导)
  int _mdActiveVersion = 0; // 0: 初始待选, 1: 暴力版, 2: 进阶版, 3: 崩溃版

  final List<InspirationOrder> _orders = [
    InspirationOrder(title: "极佳灵感爆发", details: "新章节高潮剧情自动浮现，毫无卡顿", status: "已发货"),
    InspirationOrder(title: "意外丰盛进账", details: "毫无逻辑的巨额财富顺利流入账户", status: "处理中"),
  ];
  final TextEditingController _orderTitleController = TextEditingController();
  final TextEditingController _orderDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goals = [
      ManifestGoal(
        title: "💰 亿万财富",
        identity: "我本身即是宇宙提款机，极度富足状态就绪",
        color: const Color(0xFFFFD700),
        affirmations: [
          "进账对我来说就像呼吸一样简单纯粹",
          "花出去的钱总是成倍且不可思议地流回我身边",
          "我的账户余额每天都在毫无逻辑地疯狂暴涨",
          "金钱死死追逐着我，我对此极度从容且习以为常",
        ],
      ),
      ManifestGoal(
        title: "👑 巅峰事业",
        identity: "文字直击灵魂，绝对成功的名家版图已彻底成型",
        color: const Color(0xFFC084FC),
        affirmations: [
          "灵感如核爆般涌现，我是无情的爆款制造机",
          "新机会源源不断为我打开，毫不费力达成巅峰",
          "我写的每一段话都在潜意识层面死死锁定精准受众",
        ],
      ),
      ManifestGoal(
        title: "✨ 顶级神颜",
        identity: "躯体新陈代谢处于完美巅峰，顶级神颜能量满溢",
        color: const Color(0xFFFB7185),
        affirmations: [
          "每一个细胞都在散发绝对迷人的高频光泽",
          "我越是彻底放松，长得越是惊艳绝伦",
          "绝对气场压制，容貌处于完美且无可挑剔的状态",
        ],
      ),
    ];
    _currentAffirmation = _goals[0].affirmations[0];
  }

  @override
  void dispose() {
    _customAffInputController.dispose();
    _orderTitleController.dispose();
    _orderDetailsController.dispose();
    super.dispose();
  }

  void _executePump() {
    HapticFeedback.mediumImpact();
    setState(() {
      _vibeHz += Random().nextInt(40) + 10;
      final list = _goals[_selectedIndex].affirmations;
      _currentAffirmation = list[Random().nextInt(list.length)];
    });
  }

  // 执行 TXT/多句文本批量直灌
  void _executeBatchAffirmationImport() {
    final text = _customAffInputController.text.trim();
    if (text.isEmpty) return;

    // 按换行符自动切片为独立语句
    List<String> newLines = text
        .split(RegExp(r'\r?\n'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (newLines.isEmpty) return;

    HapticFeedback.heavyImpact();
    setState(() {
      _goals[_selectedIndex].affirmations.addAll(newLines);
      _currentAffirmation = newLines.first; // 瞬间高亮展示导入的第一句
      _vibeHz += newLines.length * 20;
      _customAffInputController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("⚡ 成功汇入 ${newLines.length} 条高频信念！已永久注入当前轨道。"),
        backgroundColor: _goals[_selectedIndex].color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetSedona() {
    setState(() {
      _sedonaStep = 0;
      _selectedRootCause = "";
    });
  }

  void _submitNewOrder() {
    if (_orderTitleController.text.trim().isEmpty) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _orders.insert(0, InspirationOrder(
        title: _orderTitleController.text.trim(),
        details: _orderDetailsController.text.trim().isEmpty ? "宇宙全权高效安排" : _orderDetailsController.text.trim(),
        status: "处理中",
      ));
      _orderTitleController.clear();
      _orderDetailsController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✨ 订单已极速发送至宇宙后台！正在无缝调配实相..."),
        backgroundColor: Color(0xFFC084FC),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddGoalDialog() {
    String titleInput = "";
    String identityInput = "";
    String affInput = "";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("✨ 开启新显化轨道", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "轨道名称 (例: 🚗 顺畅通关)",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (v) => titleInput = v,
              ),
              const SizedBox(height: 12),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "终点身份宣言 (例: 尽在掌控)",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (v) => identityInput = v,
              ),
              const SizedBox(height: 12),
              TextField(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "首条核心真言 (例: 极其丝滑)",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF0F172A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (v) => affInput = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("取消", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleInput.trim().isNotEmpty && identityInput.trim().isNotEmpty) {
                HapticFeedback.heavyImpact();
                setState(() {
                  _goals.add(ManifestGoal(
                    title: titleInput.trim(),
                    identity: identityInput.trim(),
                    color: Colors.tealAccent,
                    affirmations: [affInput.trim().isNotEmpty ? affInput.trim() : "一切顺遂，绝对显化"],
                  ));
                  _selectedIndex = _goals.length - 1;
                  _currentAffirmation = _goals[_selectedIndex].affirmations[0];
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC084FC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("立即载入潜意识", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentGoal = _goals[_selectedIndex];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 掐死高度拉伸防御闪退
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶栏标识与振频指示器
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("SCAVENGER DASHBOARD //", style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: currentGoal.color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: currentGoal.color.withOpacity(0.3))),
                    child: Text("能量流速: ${_vibeHz}Hz", style: TextStyle(color: currentGoal.color, fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // 轨道横向切换与添加模块
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("焦点显化轨道", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: _showAddGoalDialog,
                    child: const Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Color(0xFFC084FC), size: 16),
                        SizedBox(width: 4),
                        Text("添加轨道", style: TextStyle(color: Color(0xFFC084FC), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _goals.length,
                  itemBuilder: (ctx, i) {
                    final isSel = i == _selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _selectedIndex = i;
                          _currentAffirmation = _goals[i].affirmations[0];
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: isSel ? currentGoal.color : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: isSel ? Colors.white : Colors.transparent),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _goals[i].title,
                          style: TextStyle(color: isSel ? Colors.black : Colors.white70, fontWeight: isSel ? FontWeight.w900 : FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 常驻终点身份宣言
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF1E293B).withOpacity(0.7), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("终点身份宣言 (3D无关真假，此想法才是唯一真实)", style: TextStyle(color: Colors.white38, fontSize: 11)),
                    const SizedBox(height: 6),
                    Text(currentGoal.identity, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ====================================
              // 狂 A 爆发交互画板 + 能量文本直灌舱
              // ====================================
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: currentGoal.color.withOpacity(0.5), width: 1.5),
                  boxShadow: [BoxShadow(color: currentGoal.color.withOpacity(0.05), blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 狂A点按区
                    GestureDetector(
                      onTap: _executePump,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [currentGoal.color.withOpacity(0.15), Colors.transparent]),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(top: 0, left: 0, child: Text("✨ 快速敲击上方区域狂A注入", style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                            Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
                                child: Text(
                                  _currentAffirmation,
                                  key: ValueKey(_currentAffirmation),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.4, letterSpacing: 1.2),
                                ),
                              ),
                            ),
                            Positioned(bottom: 0, right: 0, child: Text(">>> PUMP FORCE", style: TextStyle(color: currentGoal.color.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ),

                    // 新增：无缝输入/导入多句真言直灌舱
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _customAffInputController,
                                maxLines: 3,
                                minLines: 1,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: "+ 粘贴多句TXT或输入专属真言 (自动按回车汇入)...",
                                  hintStyle: TextStyle(color: Colors.white24),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send_rounded, color: currentGoal.color),
                              onPressed: _executeBatchAffirmationImport,
                              tooltip: "立即切片灌入底层库",
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 宇宙灵感订单专属操控区
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.3))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, color: Color(0xFFC084FC), size: 20),
                        SizedBox(width: 8),
                        Text("宇宙灵感订单 (随心下单，极速调配)", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _orderTitleController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: InputDecoration(hintText: "输入所需灵感/资源 (例: 绝妙高潮剧情)", hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: const Color(0xFF0F172A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _orderDetailsController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: InputDecoration(hintText: "具体细节要求 (选填，默认宇宙完美安排)", hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: const Color(0xFF0F172A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitNewOrder,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC084FC), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: const Text("发送\n订单", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("后台实相调配跟踪：", style: TextStyle(color: Colors.white54, fontSize: 11)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _orders.length,
                      itemBuilder: (ctx, i) {
                        final order = _orders[i];
                        final isDone = order.status == "已发货";
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(order.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text(order.details, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: isDone ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                                child: Text(order.status, style: TextStyle(color: isDone ? Colors.greenAccent : Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ====================================
              // 彻底重构：MD 潜意识防线（纯引导思考/无输入版）
              // ====================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.tealAccent.withOpacity(0.3))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.psychology_outlined, color: Colors.tealAccent, size: 20),
                        SizedBox(width: 8),
                        Text("MD 潜意识防线 (不给对立面半点注意力)", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("底层认知锁：\n• 3D无关真假，你的想法才是唯一真实\n• 旧故事毫无用处，不良情绪只是小我在阿巴阿巴\n• 你有能力创造不想要的，就绝对有能力创造想要的", style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.5)),
                    const SizedBox(height: 16),

                    const Text("选择当下的实操截断版本：", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // 版本切换选项卡
                    Row(
                      children: [
                        Expanded(child: _mdVersionBtn("暴力版", 1)),
                        const SizedBox(width: 8),
                        Expanded(child: _mdVersionBtn("进阶版", 2)),
                        const SizedBox(width: 8),
                        Expanded(child: _mdVersionBtn("情绪崩溃版", 3)),
                      ],
                    ),

                    // 根据选择展开全内在引导思考流
                    if (_mdActiveVersion > 0) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getMdGuidanceText(_mdActiveVersion, currentGoal), style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6)),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.heavyImpact();
                                  setState(() => _mdActiveVersion = 0);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✨ 思想频率已彻底对齐！"), behavior: SnackBarBehavior.floating));
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(0, 36)),
                                child: const Text("已完成转念思考", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ====================================
              // 彻底重构：圣多纳情绪释放舱（纯引导思考/无输入版）
              // ====================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFFB7185).withOpacity(0.3))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.waves_rounded, color: Color(0xFFFB7185), size: 20),
                        SizedBox(width: 8),
                        Text("圣多纳释放舱 2.0 (全内在沉浸引导)", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_sedonaStep == 0) ...[
                      const Text("请在脑海中明确此时死死卡住你的负面感受，\n然后直接点击它背后的核心心魔开启极速卸载：", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _rootCauseBtn("想要控制")),
                          const SizedBox(width: 8),
                          Expanded(child: _rootCauseBtn("想要认可")),
                          const SizedBox(width: 8),
                          Expanded(child: _rootCauseBtn("想要安全")),
                        ],
                      )
                    ],

                    if (_sedonaStep >= 1 && _sedonaStep <= 5) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("锁定根源心魔: 【$_selectedRootCause】", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFB7185), fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Text(
                              _getSedonaQuestion(_sedonaStep),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                setState(() => _sedonaStep++);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFB7185), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
                              child: Text(_sedonaStep == 4 ? "现在！立刻放下" : "是的，允许/可以/愿意", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              setState(() => _sedonaStep = 5);
                            },
                            child: const Text("放不下！直接摆烂", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          )
                        ],
                      )
                    ],

                    if (_sedonaStep == 6) ...[
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 48),
                            const SizedBox(height: 10),
                            const Text("✨ 情绪垃圾与执念已彻底粉碎烧光 ✨\n爱咋咋地，老娘不伺候了！绝对轻松！", textAlign: TextAlign.center, style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14, height: 1.5)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _resetSedona,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
                              child: const Text("回归清净观察者"),
                            )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // MD 辅助按键
  Widget _mdVersionBtn(String title, int version) {
    final isSel = _mdActiveVersion == version;
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        setState(() => _mdActiveVersion = version);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSel ? Colors.tealAccent : const Color(0xFF0F172A),
        foregroundColor: isSel ? Colors.black : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.tealAccent.withOpacity(0.3))),
      ),
      child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  // 获取MD不同版本的思考引导语
  String _getMdGuidanceText(int version, ManifestGoal goal) {
    switch(version) {
      case 1: // 暴力版
        return "⚡ 【暴力版实操指令】\n\n"
            "1. 脑海中锁定目标：不管途径，只认结果。\n"
            "2. 当不符念头出现，立刻让它滚并强制打断！\n"
            "3. 反驳回路：如果打不断，一条条反驳它小我在哪搅屎。\n"
            "4. 终极覆盖：告诉自己，唯一的真实想法是：\n"
            "『${goal.identity}』\n\n"
            "*(注：在此期间焦虑烦躁不用管，小我在阿巴阿巴而已)*";
      case 2: // 进阶版
        return "✨ 【进阶版实操指令】\n\n"
            "大道至简，仅此一步：\n"
            "每时每刻，只要有跟显化目标相关的想法冒出，毫不犹豫，全部选择与目标绝对一致的想法！\n\n"
            "你当下的绝对意志：\n"
            "『${goal.affirmations.first}』";
      case 3: // 情绪崩溃版
        return "🌊 【情绪崩溃期极简指引】\n\n"
            "1. 清楚觉察：这纯粹是小我的情绪垃圾，与我真正的实相无关。\n"
            "2. 放松机制：先去重复任何让你快乐放松的事（打游戏/睡觉），完全不管它。\n"
            "3. 终极对齐：对结果有影响的只有想法，而我的真实想法永远是：\n"
            "『${goal.identity}』";
      default:
        return "";
    }
  }

  Widget _rootCauseBtn(String title) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedRootCause = title;
          _sedonaStep = 1;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: const Color(0xFFFB7185),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: const Color(0xFFFB7185).withOpacity(0.4)),
        ),
      ),
      child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  String _getSedonaQuestion(int step) {
    switch (step) {
      case 1:
        return "提问 1/4：\n你现在能允许这种『$_selectedRootCause』的抗拒感充分地存在吗？";
      case 2:
        return "提问 2/4：\n仅仅从能力上讲，你能把脑海里这坨沉重的情绪放手吗？";
      case 3:
        return "提问 3/4：\n抛开一切结果不谈，你愿意把这个执念彻底放下吗？";
      case 4:
        return "终极拷问：\n你打算什么时候把它彻底扔进马桶冲走？";
      case 5:
        return "💥 毁灭摆烂判定触发 💥\n控制不了？放不下？\n没关系，那就彻底毁灭吧！拉倒吧！滚蛋！\n(摆烂的尽头一定是绝对的放松)";
      default:
        return "";
    }
  }
}