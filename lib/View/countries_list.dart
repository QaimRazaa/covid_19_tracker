import 'dart:convert';

import 'package:covid_19_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> with TickerProviderStateMixin{


  TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> countriesListApi ()async{

    var data ;
    final response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries'));

    if(response.statusCode == 200){

      data = jsonDecode(response.body);
      return data;


    }else{
      throw{Exception('Error')};


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value){
                setState(() {

                });
              },
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                hintText: 'Search country name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                )
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: countriesListApi(),
                builder: (context , snapshot){

                  if(!snapshot.hasData){
                    return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context , index){
                          return Shimmer.fromColors(
                              baseColor: Colors.grey.shade700,
                              highlightColor: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Container(height: 10, width: 80,color: Colors.white,),
                                    subtitle: Container(height: 10, width: 80,color: Colors.white,),
                                    leading: Container(height: 50, width: 50,color: Colors.white,),
                                  )
                                ],
                              ),
                          );
                    });;


                  }else{
                    return ListView.builder(
                        itemCount:snapshot.data!.length,
                        itemBuilder: (context , index){
                          String name = snapshot.data![index]['country'];

                          if(searchController.text.isEmpty){
                            return Column(
                              children: [
                                InkWell(
                                  onTap:(){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => DetailScreen(
                                          name: snapshot.data![index]['country'],
                                          image:snapshot.data![index]['countryInfo']['flag'],
                                          cases:snapshot.data![index]['cases'],
                                          deaths:snapshot.data![index]['deaths'],
                                          recovered:snapshot.data![index]['recovered'],
                                          active:snapshot.data![index]['active'],
                                          critical:snapshot.data![index]['critical'],
                                          population:snapshot.data![index]['population'],
                                          tests:snapshot.data![index]['tests'],

                                        )));
                            },
                                  child: ListTile(
                                    title: Text(snapshot.data![index]['country'],),
                                    subtitle: Text(snapshot.data![index]['cases'].toString(),),
                                    leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]['countryInfo']['flag']
                                        )),
                                  ),
                                )
                              ],
                            );


                          }else if(name.toLowerCase().contains(searchController.text.toLowerCase())){
                            return Column(
                              children: [
                                InkWell(
                                  onTap:(){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => DetailScreen(
                                    name: snapshot.data![index]['country'],
                                    image:snapshot.data![index]['countryInfo']['flag'],
                                    cases:snapshot.data![index]['cases'],
                                    deaths:snapshot.data![index]['deaths'],
                                    recovered:snapshot.data![index]['recovered'],
                                    active:snapshot.data![index]['active'],
                                    critical:snapshot.data![index]['critical'],
                                    population:snapshot.data![index]['population'],
                                    tests:snapshot.data![index]['tests'],

                                  )));
                            },
                                  child: ListTile(
                                    title: Text(snapshot.data![index]['country'],),
                                    subtitle: Text(snapshot.data![index]['cases'].toString(),),
                                    leading: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            snapshot.data![index]['countryInfo']['flag']
                                        )),
                                  ),
                                )
                              ],
                            );


                          }else{
                            return Container();



                          }


                    });

                  }



                }),
          )
        ],
      )),

    );
  }
}
