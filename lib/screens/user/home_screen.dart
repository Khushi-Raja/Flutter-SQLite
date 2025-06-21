import 'package:brainybeam/screens/admin/add_event_screen.dart';
import 'package:brainybeam/authentication/login_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:brainybeam/services/db_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../components/event_card.dart';
import '../../model/event_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Event> _events = [];
  String _selected = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _dbHelper.fetchEvents();
    setState(() {
      _events = data;
    });
  }

  List<String> get _categories =>
      ['All', ..._events.map((e) => e.category).toSet()];

  List<Event> get _visible => _selected == 'All'
      ? _events
      : _events.where((e) => e.category == _selected).toList();

  // Seed a sample event so you can see something right away
  Future<void> _seedDemo() async {
    await _dbHelper.addEvent(
      Event(
        title: 'Flutter Workshop',
        category: 'Tech',
        description: 'Hands‑on intro to widgets & state.',
        banner:
            'https://picsum.photos/800/300?${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now().add(const Duration(days: 2)),
      ),
    );
    _load();
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Events"),
          actions: [
            IconButton(
              onPressed: () {
                _logout(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Event',
          child: const Icon(Icons.add),
          onPressed: () async {
            // push the form; wait for a result
            final added = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const AddEventScreen()),
            );
            if (added == true) _load();          // refresh only if we actually saved
          },
        ),
        body: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: EdgeInsets.only(bottom: 3.h),
            children: [
              if (_visible.isNotEmpty)
                CarouselSlider(
                  options: CarouselOptions(
                      height: 23.h,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9),
                  items: _visible
                      .take(5)
                      .map(
                        (e) => Image.network(
                          e.banner,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      .toList(),
                ),
              SizedBox(height: 1.3.h),
              SizedBox(
                height: 5.h,
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final sel = cat == _selected;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: sel,
                        onSelected: (value) => setState(() => _selected = cat),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              ..._visible.map((e) => EventCard(event: e)),
              if (_visible.isEmpty)
                Padding(
                  padding: EdgeInsets.all(4.h),
                  child: Center(child: Text('No events')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
