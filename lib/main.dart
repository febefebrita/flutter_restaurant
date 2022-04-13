import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant/detail.dart';
import 'dart:convert';

import 'package:restaurant/restaurant_list.dart';

Future<List<dynamic>> fetchRestaurant() async {
  final response =
      await http.get(Uri.parse("https://restaurant-api.dicoding.dev/list"));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['restaurants'];
  } else {
    throw Exception('Failed to load data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant VB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Restaurant VB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> futureRestaurant;
  late Future<RestaurantDetail> futureRestaurantDetail;

  @override
  void initState() {
    super.initState();
    futureRestaurant = fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Text(
            'Restaurant',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 4.0),
          Text(
            'Recommended restaurant for you!',
          ),
          FutureBuilder<List<dynamic>>(
            future: futureRestaurant,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return Text(snapshot.data![0]['name']);
                return Flexible(
                  child: ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]['name']),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RestaurantDetailScreen(
                                restaurantId: snapshot.data![index]['id']);
                          }));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
