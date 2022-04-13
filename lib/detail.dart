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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<dynamic>(
              future: futureRestaurantDetail,
              builder: (context, snapshotDetail) {
                print(snapshotDetail);
                if (snapshotDetail.hasData) {
                  return Column(children: [
                    Text(snapshotDetail.data!['name']),
                    Text(snapshotDetail.data!['city']),
                    Text(snapshotDetail.data!['address']),
                    Text(snapshotDetail.data!['description']),
                    Text(snapshotDetail.data!['categories'][0]['name']),
                    // Flexible(
                    //   child: ListView.builder(
                    //     itemCount: 2,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         title: Text(snapshotDetail.data!['categories']
                    //             [index]['name']),
                    //       );
                    //     },
                    //   ),
                    // ),
                    //Double(doublesnapshotDetail.data!['rating']),
                  ]);
                } else if (snapshotDetail.hasError) {
                  return Text('${snapshotDetail.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}
