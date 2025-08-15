import 'dart:convert';

import 'package:covid_19_tracker/Model/WorldStatesModel.dart';
import 'package:covid_19_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen> with TickerProviderStateMixin{

  Future<WorldStatesModel> fetchWorldStatesRecords ()async{
    final response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));

    if(response.statusCode == 200){

      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);


    }else{
      throw{Exception('Error')};


    }
  }

  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this)..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorlist = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .01,),
              FutureBuilder(
                  future: fetchWorldStatesRecords(),
                  builder: (context , snapshot){
            
                if(!snapshot.hasData){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height *0.8,
                      child: SpinKitFadingCircle(color: Colors.white, size: 50, controller: _controller,));
            
            
                }else{
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        PieChart(dataMap:
                        {
                          "Total" : double.parse(snapshot.data!.cases.toString()),
                          "Recovered": double.parse(snapshot.data!.recovered.toString()),
                          "Deaths": double.parse(snapshot.data!.deaths.toString()),
                        },
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          colorList: colorlist,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,

                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .06),
                          child: Card(
                            child: Column(
                              children: [
                                ReUseableRow(title: 'Total' , value: snapshot.data!.cases.toString(),),
                                ReUseableRow(title: 'Deaths' , value: snapshot.data!.deaths.toString(),),
                                ReUseableRow(title: 'Recovered' , value: snapshot.data!.recovered.toString(),),
                                ReUseableRow(title: 'Active' , value: snapshot.data!.active.toString(),),
                                ReUseableRow(title: 'Critical' , value: snapshot.data!.critical.toString(),),
                                ReUseableRow(title: 'Today Deaths' , value: snapshot.data!.todayDeaths.toString(),),
                                ReUseableRow(title: 'Today Recoverd' , value: snapshot.data!.todayRecovered.toString(),),
                                ReUseableRow(title: 'Affected Countries' , value: snapshot.data!.affectedCountries.toString(),),

                              ],
                            ),
                          ),
                        ),
                         GestureDetector(
                           onTap:(){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesList() ));
                           },
                           child: Container(
                              height: 50,
                              decoration:  BoxDecoration(
                                color: Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                         ),


                      ],
                    ),
                  );
            
            
                }
            
              }),
            
            ],
                    ),
                  ),
          )),
    );
  }
}

class ReUseableRow extends StatelessWidget {
  String title , value;
   ReUseableRow({super.key , required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
        ],
      ),
    );
  }
}

