import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:restaurant/restaurant_list.dart';

Future<dynamic> fetchRestaurantDetail(String id) async {
  print('asd $id');
  final response = await http
      .get(Uri.parse("https://restaurant-api.dicoding.dev/detail/" + id));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("Resp Bdy: " + response.body);
    return jsonDecode(response.body)['restaurant'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({Key? key, required this.restaurantId})
      : super(key: key);

  final String restaurantId;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Future<dynamic> futureRestaurantDetail;
  @override
  void initState() {
    super.initState();
    futureRestaurantDetail = fetchRestaurantDetail(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: futureRestaurantDetail,
          builder: (context, snapshotDetail) {
            if (snapshotDetail.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(snapshotDetail.data!['name']),
                      Image.network(
                          'https://restaurant-api.dicoding.dev/images/small/' +
                              snapshotDetail.data!['pictureId']),
                      Text(snapshotDetail.data!['city']),
                      Text(snapshotDetail.data!['address']),
                      Text(snapshotDetail.data!['description']),
                      Text(snapshotDetail.data!['rating'].toString()),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: snapshotDetail.data!['categories'].length,
                          itemBuilder: (context, idx) {
                            return Text(snapshotDetail.data!['categories'][idx]
                                ['name']);
                          },
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount:
                            snapshotDetail.data!['menus']['foods'].length,
                        itemBuilder: (context, idx) {
                          return Text(snapshotDetail.data!['menus']['foods']
                              [idx]['name']);
                        },
                      ))
                    ]),
              );
            } else if (snapshotDetail.hasError) {
              return Text('${snapshotDetail.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }),
    );
  }
}
