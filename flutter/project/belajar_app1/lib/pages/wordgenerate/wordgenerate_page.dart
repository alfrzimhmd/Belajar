import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

/// Halaman utama untuk fitur Word Generator.
/// Menggunakan Provider sebagai state management.
class WordgeneratePage extends StatelessWidget {
  const WordgeneratePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus konten dengan ChangeNotifierProvider
    // agar MyAppState bisa diakses di seluruh widget dalam subtree-nya.
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const _WordgenContent(),
    );
  }
}

/// Widget utama untuk menampilkan tampilan halaman Word Generator.
class _WordgenContent extends StatelessWidget {
  const _WordgenContent();

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Word Generator App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: const MyHomePage(),
      ),
    );
  }
}

/// State utama aplikasi untuk menyimpan logika dan data.
/// Menggunakan ChangeNotifier agar dapat memberi tahu widget saat terjadi perubahan data.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random(); // Kata acak yang sedang ditampilkan
  var history = <WordPair>[]; // Daftar kata yang telah di-generate sebelumnya
  GlobalKey? historyListKey; // Digunakan untuk animasi daftar riwayat

  /// Menghasilkan kata baru dan menambahkannya ke daftar riwayat.
  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners(); // Memberi tahu widget agar diperbarui
  }

  var favorites = <WordPair>[]; // Daftar kata favorit

  /// Menambahkan atau menghapus kata dari daftar favorit.
  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  /// Menghapus kata tertentu dari daftar favorit.
  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

/// Halaman utama dengan navigasi dua tab: Home dan Favorites.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State dari halaman utama yang menangani logika navigasi.
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // Menentukan tab yang aktif

  @override
  Widget build(BuildContext context) {
    Widget page;

    // Mengubah halaman berdasarkan tab yang dipilih
    switch (selectedIndex) {
      case 0:
        page = const _GeneratorPage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Menggunakan LayoutBuilder agar responsif terhadap lebar layar
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              backgroundColor: Colors.blue[100],
              selectedIconTheme: IconThemeData(color: Colors.blue[800]),
              selectedLabelTextStyle: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
              unselectedIconTheme: IconThemeData(color: Colors.blue[600]),
              unselectedLabelTextStyle: TextStyle(color: Colors.blue[600]),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: page,
          ),
        ],
      );
    });
  }
}

/// Halaman utama untuk menghasilkan kata acak dan tombol aksi.
class _GeneratorPage extends StatelessWidget {
  const _GeneratorPage();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Menentukan ikon favorit (penuh atau kosong)
    IconData icon = appState.favorites.contains(pair)
        ? Icons.favorite
        : Icons.favorite_border;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: HistoryListView(),
            ),
            const SizedBox(height: 20),
            BigCard(pair: pair),
            const SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => appState.toggleFavorite(),
                  icon: Icon(icon),
                  label: const Text('Like'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: appState.getNext,
                  child: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Tekan tombol Next untuk menghasilkan kata baru, dan Like untuk menambahkannya ke favorit.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget kartu besar untuk menampilkan kata utama yang dihasilkan.
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        pair.asLowerCase,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
        textAlign: TextAlign.center,
        semanticsLabel: "${pair.first} ${pair.second}",
      ),
    );
  }
}

/// Halaman daftar kata favorit pengguna.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.blue[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada favorit',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tekan tombol Like di halaman Home untuk menambahkan favorit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Kamu punya ${appState.favorites.length} favorit:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: appState.favorites.length,
              itemBuilder: (context, index) {
                final pair = appState.favorites[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          semanticLabel: 'Delete'),
                      color: Colors.red,
                      onPressed: () => appState.removeFavorite(pair),
                    ),
                    title: Text(
                      pair.asLowerCase,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                      semanticsLabel: pair.asPascalCase,
                    ),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget daftar riwayat kata yang telah digenerate.
class HistoryListView extends StatefulWidget {
  const HistoryListView({super.key});

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

/// State dari daftar riwayat kata.
/// Menggunakan AnimatedList agar setiap penambahan kata muncul dengan animasi halus.
class _HistoryListViewState extends State<HistoryListView> {
  final _key = GlobalKey<AnimatedListState>();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: const EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          final isFavorite = appState.favorites.contains(pair);

          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0, end: 1)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () => appState.toggleFavorite(pair),
                    icon: isFavorite
                        ? const Icon(Icons.favorite,
                        color: Colors.pink, size: 14)
                        : const SizedBox(),
                    label: Text(
                      pair.asLowerCase,
                      style: TextStyle(
                        color: isFavorite
                            ? Colors.pink.shade400
                            : Colors.blue[800],
                        fontWeight:
                        isFavorite ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}