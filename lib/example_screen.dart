import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/MainObject.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  Future<MainObject> getMainObject() async {
    final response = await http.get(
        Uri.parse('https://webhook.site/356934d7-f60c-45bd-96b3-ad4a97f371e2'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return MainObject.fromJson(data);
    } else {
      return MainObject.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complex Json API"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<MainObject>(
                  future: getMainObject(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.data![0].products!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(snapshot.data!.data![0].products![index].shop.toString()),
                                  subtitle: Text(snapshot.data!.data![0].products![index].description.toString()),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!.data![0].image.toString()),
                                    backgroundColor: Colors.teal,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * .4,
                                    width: MediaQuery.of(context).size.width * 1,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.data![0].products![index].images!.length,
                                        itemBuilder: (context, position) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * .25,
                                              width: MediaQuery.of(context).size.width * .5,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot.data!.data![0].products![index].images![position].url.toString()),
                                                  fit: BoxFit.cover
                                                ),
                                                color: Colors.grey.withOpacity(.1),
                                                border: Border.all(color: Colors.grey, width: 1.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(position.toString()),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Icon(snapshot.data!.data![0].products![index].inWishlist == false ? Icons.favorite : Icons.favorite_border),
                                ),
                              ],
                            );
                          });
                    } else {
                      return Text("Loading");
                    }
                  })),
        ],
      ),
    );
  }
}
