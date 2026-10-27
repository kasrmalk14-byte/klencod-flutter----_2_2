
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const KaserApp());
}

const purple = Color(0xFF7657FF);
const gold = Color(0xFFFFD477);
const bg = Color(0xFF090B14);
const panel = Color(0xFF171A29);

class KaserApp extends StatelessWidget {
  const KaserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الكاسر - الدردشة العالمية',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}

class Chat {
  String name;
  String message;
  Color color;
  List<String> messages;

  Chat(this.name, this.message, this.color,
      [List<String>? initial])
      : messages = initial ?? [];
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    fade = Tween<double>(begin: 0.25, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    controller.repeat(reverse: true);

    timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF17112D), bg, Color(0xFF101827)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 100,
              right: -70,
              child: glowCircle(purple),
            ),
            Positioned(
              bottom: 80,
              left: -70,
              child: glowCircle(gold),
            ),
            Center(
              child: AnimatedBuilder(
                animation: fade,
                builder: (context, child) => Opacity(
                  opacity: fade.value,
                  child: child,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: const LinearGradient(
                          colors: [gold, purple],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: purple.withValues(alpha: 0.45),
                            blurRadius: 45,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        size: 85,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'الكاسر',
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'الدردشة العالمية',
                      style: TextStyle(
                        fontSize: 23,
                        color: gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'عالمك • تواصلك • قوتك',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'THE KASER EXPERIENCE',
                  style: TextStyle(
                    color: Colors.white30,
                    letterSpacing: 4,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget glowCircle(Color color) {
  return Container(
    width: 180,
    height: 180,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: 0.08),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.12),
          blurRadius: 100,
          spreadRadius: 35,
        ),
      ],
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  String search = '';

  final List<Chat> chats = [
    Chat('أحمد', 'أهلًا بك في الكاسر 👑', Colors.blue,
        ['مرحبًا أحمد!', 'أهلًا بك في الكاسر 👑']),
    Chat('محمد', 'نراك لاحقًا 👋', Colors.orange,
        ['السلام عليكم', 'نراك لاحقًا 👋']),
    Chat('الأصدقاء', 'مرحبًا بالجميع', Colors.green,
        ['مرحبًا بالجميع']),
  ];

  void addChat() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panel,
        title: const Text('محادثة جديدة'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'اسم الشخص أو المجموعة',
            prefixIcon: Icon(Icons.person_add_alt_1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              setState(() {
                chats.insert(
                  0,
                  Chat(name, 'ابدأ المحادثة الآن', purple),
                );
              });

              Navigator.pop(dialogContext);
              openChat(chats.first);
            },
            child: const Text('إنشاء'),
          ),
        ],
      ),
    );
  }

  void openChat(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(chat: chat),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleChats = chats
        .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 78,
          title: const Row(
            children: [
              Icon(Icons.bolt_rounded, color: gold, size: 38),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الكاسر',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'الدردشة العالمية',
                    style: TextStyle(color: gold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: addChat,
              icon: const Icon(Icons.add_comment_outlined),
            ),
          ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5438B8), Color(0xFF25204A)],
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبًا بك في عالم الكاسر',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'مساحة جديدة لمحادثاتك وأصدقائك',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) => setState(() => search = value),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن محادثة...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: panel,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 22, 18, 10),
                  child: Text(
                    'المحادثات',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: visibleChats.isEmpty
                      ? const Center(child: Text('لا توجد محادثات'))
                      : ListView.builder(
                          itemCount: visibleChats.length,
                          itemBuilder: (_, index) {
                            final chat = visibleChats[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 7,
                              ),
                              leading: CircleAvatar(
                                radius: 27,
                                backgroundColor:
                                    chat.color.withValues(alpha: 0.2),
                                child: Text(
                                  chat.name.characters.first,
                                  style: TextStyle(
                                    color: chat.color,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                chat.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                chat.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 16,
                                color: gold,
                              ),
                              onTap: () => openChat(chat),
                            );
                          },
                        ),
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'الأشخاص',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...chats.map(
                  (chat) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: chat.color,
                      child: Text(chat.name.characters.first),
                    ),
                    title: Text(chat.name),
                    subtitle: const Text('محادثة محلية تجريبية'),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat, color: gold),
                      onPressed: () => openChat(chat),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: gold),
                  title: const Text('إضافة شخص جديد'),
                  onTap: addChat,
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 25),
                const Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: purple,
                    child: Icon(Icons.person, size: 55),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'الكاسر',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'الدردشة العالمية',
                    style: TextStyle(color: gold),
                  ),
                ),
                const SizedBox(height: 35),
                const ListTile(
                  leading: Icon(Icons.palette_outlined, color: gold),
                  title: Text('المظهر'),
                  subtitle: Text('التصميم الداكن'),
                ),
                const ListTile(
                  leading: Icon(Icons.lock_outline, color: gold),
                  title: Text('الخصوصية'),
                  subtitle: Text('واجهة إعدادات تجريبية'),
                ),
                const ListTile(
                  leading: Icon(Icons.notifications_outlined, color: gold),
                  title: Text('الإشعارات'),
                ),
                const ListTile(
                  leading: Icon(Icons.info_outline, color: gold),
                  title: Text('حول التطبيق'),
                  subtitle: Text('الكاسر - الإصدار الأولي'),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: tab == 0
            ? FloatingActionButton(
                backgroundColor: purple,
                onPressed: addChat,
                child: const Icon(Icons.add_comment),
              )
            : null,
        bottomNavigationBar: NavigationBar(
          backgroundColor: panel,
          indicatorColor: purple.withValues(alpha: 0.3),
          selectedIndex: tab,
          onDestinationSelected: (value) => setState(() => tab = value),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble, color: gold),
              label: 'الدردشات',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people, color: gold),
              label: 'الأشخاص',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: gold),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.chat.messages.add(text);
      widget.chat.message = text;
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.chat.color,
                child: Text(widget.chat.name.characters.first),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'دردشة محلية',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('المكالمات غير مفعلة في النسخة المحلية'),
                ),
              ),
              icon: const Icon(Icons.call_outlined),
            ),
            IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('إعدادات المحادثة'),
                ),
              ),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: widget.chat.messages.isEmpty
                  ? const Center(
                      child: Text('ابدأ أول رسالة في هذه المحادثة 👑'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.chat.messages.length,
                      itemBuilder: (_, index) => Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7657FF),
                                Color(0xFF5538B8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            widget.chat.messages[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'إرفاق الملفات يحتاج إلى إضافة ميزة مستقلة',
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.attach_file, color: gold),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onSubmitted: (_) => send(),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك...',
                          filled: true,
                          fillColor: panel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: purple,
                      child: IconButton(
                        onPressed: send,
                        icon: const Icon(Icons.send, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}