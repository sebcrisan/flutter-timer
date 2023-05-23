import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// provider scope
void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Timer App'),
    );
  }
}

// A list of names
const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ileana',
  'Joseph',
  'Kincaid',
  'Larry'
];

// Ticker provider which counts every second
final tickerProvider = StreamProvider((ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1,
    ));

// Maps the ticker to the names depending on count of ticker
final namesProvider = StreamProvider((ref) =>
    ref.watch(tickerProvider.stream).map((count) => names.getRange(0, count)));

// Home page screen
class MyHomePage extends ConsumerWidget {
  /// Init homepage
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  /// The title of the homepage
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// The names
    final names = ref.watch(namesProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Timer'),
        ),
        body: names.when(
          data: (names) {
            return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(names.elementAt(index)),
                  );
                });
          },
          error: (error, stacktrace) =>
              const Text('Reached the end of the list'),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }
}
