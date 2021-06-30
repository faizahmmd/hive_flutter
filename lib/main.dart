import 'package:flutter/material.dart';
import 'package:flutter_app/data_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String dataBoxName = "myHiveBox";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<DataModel>("myHiveBox");
  Hive.registerAdapter(DataModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HiveSample(),
    );
  }
}

class HiveSample extends StatefulWidget {
  @override
  _HiveSampleState createState() => _HiveSampleState();
}

class _HiveSampleState extends State<HiveSample> {
  TextEditingController textEditingController = TextEditingController();
  Box<DataModel> dataBox;
  String fetchedData = "";

  @override
  void initState() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: 300,
              height: 50,
              child: TextField(
                controller: textEditingController,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {
                DataModel dataModel = DataModel(
                    title: textEditingController.text,
                    description: "Flutter Developer",
                    complete: true);
                dataBox.put("key", dataModel);
                print("data saved successfully");
                textEditingController.clear();
              },
              child: Container(
                color: Colors.green,
                width: 200,
                height: 50,
                child: Center(child: Text("Save")),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  fetchedData = dataBox.get("key").title;
                });
              },
              child: Container(
                color: Colors.green,
                width: 200,
                height: 50,
                child: Center(child: Text("Fetch")),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              color: Colors.white,
              width: 200,
              height: 50,
              child: Center(child: Text(fetchedData)),
            )
          ],
        ),
      ),
    );
  }
}
