// Flutter package imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('uz', null);
  await initializeDateFormatting('ru', null);
  await initializeDateFormatting('en', null);
  runApp(OnaBaxtiApp());
}

class OnaBaxtiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ona Baxti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      supportedLocales: [
        Locale('uz'), // Ўзбек тили
        Locale('ru'), // Рус тили
        Locale('en'), // Инглиз тили
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text('Onalik baxti dasturimizga xush kelibsiz!'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 100),
            SizedBox(height: 20),
            Column(
              children: [
                Text(
                  'Onalik baxti dasturimizga',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'xush kelibsiz!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Tilni tanlang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainMenuScreen(language: 'uz'),
                ),
              ),
              child: Text('Ozbekcha'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainMenuScreen(language: 'ru'),
                ),
              ),
              child: Text('Русский'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainMenuScreen(language: 'en'),
                ),
              ),
              child: Text('English'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _launchURL('https://t.me/doctorYakubjonov'),
            child: Text(
              'Loyiha hamkori: doctorYakubjonov',
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          InkWell(
            onTap: () => _launchURL('https://t.me/samdev28'),
            child: Text(
              'Dasturchi: SamDev',
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  final String language;

  MainMenuScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLocalizedText('main_menu', language)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OvulationCalculatorScreen(language: language),
                ),
              ),
              child: Text(_getLocalizedText('calculate_ovulation', language)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PregnancyWeekScreen(language: language),
                ),
              ),
              child: Text(_getLocalizedText('calculate_pregnancy_weeks', language)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DueDateCalculatorScreen(language: language),
                ),
              ),
              child: Text(_getLocalizedText('calculate_due_date', language)),
            ),
          ],
        ),
      ),
    );
  }
}

class OvulationCalculatorScreen extends StatefulWidget {
  final String language;

  OvulationCalculatorScreen({required this.language});

  @override
  _OvulationCalculatorScreenState createState() => _OvulationCalculatorScreenState();
}

class _OvulationCalculatorScreenState extends State<OvulationCalculatorScreen> {
  DateTime? selectedDate;
  final TextEditingController cycleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLocalizedText('calculate_ovulation', widget.language)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : DateFormat.yMMMMd(widget.language).format(selectedDate!),
              ),
              readOnly: true,
              decoration: InputDecoration(
                labelText: _getLocalizedText('last_period_date', widget.language),
                hintText: DateFormat.yMMMMd(widget.language).pattern,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: Locale(widget.language), // Localization applied
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
            ),
            TextField(
              controller: cycleController,
              decoration: InputDecoration(
                labelText: _getLocalizedText('cycle_length', widget.language),
                hintText: '28',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null || cycleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getLocalizedText('fill_all_fields', widget.language)),
                    ),
                  );
                  return;
                }

                DateTime lastPeriod = selectedDate!;
                int cycleLength = int.parse(cycleController.text);

                DateTime nextPeriod = lastPeriod.add(Duration(days: cycleLength));
                DateTime ovulationStart = nextPeriod.subtract(Duration(days: 17));
                DateTime ovulationEnd = nextPeriod.subtract(Duration(days: 12));
                DateTime mostLikelyOvulation = nextPeriod.subtract(Duration(days: 14));

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(_getLocalizedText('ovulation_results', widget.language)),
                    content: Text(
                      '${_getLocalizedText('ovulation_range', widget.language)}: ${DateFormat.yMMMMd(widget.language).format(ovulationStart)} - ${DateFormat.yMMMMd(widget.language).format(ovulationEnd)}\n\n${_getLocalizedText('most_likely_ovulation', widget.language)}: ${DateFormat.yMMMMd(widget.language).format(mostLikelyOvulation)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(_getLocalizedText('ok', widget.language)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(_getLocalizedText('calculate', widget.language)),
            ),
          ],
        ),
      ),
    );
  }
}

class PregnancyWeekScreen extends StatefulWidget {
  final String language;

  PregnancyWeekScreen({required this.language});

  @override
  _PregnancyWeekScreenState createState() => _PregnancyWeekScreenState();
}

class _PregnancyWeekScreenState extends State<PregnancyWeekScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLocalizedText('calculate_pregnancy_weeks', widget.language)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : DateFormat.yMMMMd(widget.language).format(selectedDate!),
              ),
              readOnly: true,
              decoration: InputDecoration(
                labelText: _getLocalizedText('last_period_date', widget.language),
                hintText: DateFormat.yMMMMd(widget.language).pattern,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: Locale(widget.language),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getLocalizedText('fill_all_fields', widget.language)),
                    ),
                  );
                  return;
                }

                DateTime lastPeriod = selectedDate!;
                DateTime adjustedDate = lastPeriod.add(Duration(days: 7));
                int weeks = DateTime.now().difference(adjustedDate).inDays ~/ 7;

                String trimester;
                if (weeks <= 13) {
                  trimester = _getLocalizedText('first_trimester', widget.language);
                } else if (weeks <= 27) {
                  trimester = _getLocalizedText('second_trimester', widget.language);
                } else {
                  trimester = _getLocalizedText('third_trimester', widget.language);
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(_getLocalizedText('pregnancy_weeks', widget.language)),
                    content: Text(
                      '${_getLocalizedText('pregnancy_weeks_label', widget.language)}: $weeks\n${_getLocalizedText('trimester', widget.language)}: $trimester',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(_getLocalizedText('ok', widget.language)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(_getLocalizedText('calculate', widget.language)),
            ),
          ],
        ),
      ),
    );
  }
}

class DueDateCalculatorScreen extends StatefulWidget {
  final String language;

  DueDateCalculatorScreen({required this.language});

  @override
  _DueDateCalculatorScreenState createState() => _DueDateCalculatorScreenState();
}

class _DueDateCalculatorScreenState extends State<DueDateCalculatorScreen> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getLocalizedText('calculate_due_date', widget.language)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : DateFormat.yMMMMd(widget.language).format(selectedDate!),
              ),
              readOnly: true,
              decoration: InputDecoration(
                labelText: _getLocalizedText('last_period_date', widget.language),
                hintText: DateFormat.yMMMMd(widget.language).pattern,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: Locale(widget.language),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_getLocalizedText('fill_all_fields', widget.language)),
                    ),
                  );
                  return;
                }

                DateTime lastPeriod = selectedDate!;
                DateTime dueDate = lastPeriod.add(Duration(days: 280));

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(_getLocalizedText('due_date', widget.language)),
                    content: Text(
                      '${_getLocalizedText('due_date_label', widget.language)}: ${DateFormat.yMMMMd(widget.language).format(dueDate)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(_getLocalizedText('ok', widget.language)),
                      ),
                    ],
                  ),
                );
              },
              child: Text(_getLocalizedText('calculate', widget.language)),
            ),
          ],
        ),
      ),
    );
  }
}

String _getLocalizedText(String key, String language) {
  final Map<String, Map<String, String>> localizedTexts = {
    'main_menu': {'uz': 'Asosiy menyu', 'ru': 'Главное меню', 'en': 'Main Menu'},
    'calculate_ovulation': {'uz': 'Ovulyatsiyani hisoblash', 'ru': 'Рассчитать овуляцию', 'en': 'Calculate Ovulation'},
    'last_period_date': {'uz': 'Oxirgi hayz sanasi', 'ru': 'Дата последней менструации', 'en': 'Last Period Date'},
    'cycle_length': {'uz': 'Hayz davri (kun)', 'ru': 'Длина цикла (дней)', 'en': 'Cycle Length'},
    'calculate': {'uz': 'Hisoblash', 'ru': 'Рассчитать', 'en': 'Calculate'},
    'ovulation_results': {'uz': 'Ovulyatsiya natijalari', 'ru': 'Результаты овуляции', 'en': 'Ovulation Results'},
    'ovulation_range': {'uz': 'Ovulyatsiya kunlari', 'ru': 'Дни овуляции', 'en': 'Ovulation Range'},
    'most_likely_ovulation': {'uz': 'Ko‘proq ehtimol bilan ovulyatsiya kuni', 'ru': 'Наиболее вероятный день овуляции', 'en': 'Most Likely Ovulation Day'},
    'calculate_pregnancy_weeks': {'uz': 'Homiladorlik haftalarini hisoblash', 'ru': 'Рассчитать недели беременности', 'en': 'Calculate Pregnancy Weeks'},
    'pregnancy_weeks': {'uz': 'Homiladorlik haftalari', 'ru': 'Недели беременности', 'en': 'Pregnancy Weeks'},
    'pregnancy_weeks_label': {'uz': 'Homiladorlik haftasi', 'ru': 'Неделя беременности', 'en': 'Pregnancy Week'},
    'trimester': {'uz': 'Trimester', 'ru': 'Триместр', 'en': 'Trimester'},
    'first_trimester': {'uz': '1-trimester', 'ru': '1-й триместр', 'en': '1st Trimester'},
    'second_trimester': {'uz': '2-trimester', 'ru': '2-й триместр', 'en': '2nd Trimester'},
    'third_trimester': {'uz': '3-trimester', 'ru': '3-й триместр', 'en': '3rd Trimester'},
    'calculate_due_date': {'uz': 'Taxminiy tug‘ruq vaqtini hisoblash', 'ru': 'Рассчитать предполагаемую дату родов', 'en': 'Calculate Due Date'},
    'due_date': {'uz': 'Taxminiy tug‘ruq sanasi', 'ru': 'Предполагаемая дата родов', 'en': 'Estimated Due Date'},
    'due_date_label': {'uz': 'Tug‘ruq sanasi', 'ru': 'Дата родов', 'en': 'Due Date'},
    'ok': {'uz': 'OK', 'ru': 'ОК', 'en': 'OK'},
    'fill_all_fields': {'uz': 'Barcha maydonlarni to‘ldiring', 'ru': 'Заполните все поля', 'en': 'Fill all fields'},
  };

  return localizedTexts[key]?[language] ?? key;
}
