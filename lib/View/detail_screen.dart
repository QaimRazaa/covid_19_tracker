import 'package:covid_19_tracker/View/world_states.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  String image;
  String name;
  int cases,deaths,recovered,active,critical,population,tests;

  DetailScreen({super.key ,
    required this.name,
    required this.image,
    required this.cases,
    required this.deaths,
    required this.recovered,
    required this.active,
    required this.critical,
    required this.population,
    required this.tests,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .067),
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height* .06,),
                        ReUseableRow(title: 'Cases', value: widget.cases.toString()),
                        ReUseableRow(title: 'Deaths', value: widget.deaths.toString()),
                        ReUseableRow(title: 'Recovered', value: widget.recovered.toString()),
                        ReUseableRow(title: 'Active', value: widget.active.toString()),
                        ReUseableRow(title: 'Critical', value: widget.critical.toString()),
                        ReUseableRow(title: 'Population', value: widget.population.toString()),
                        ReUseableRow(title: 'Tests', value: widget.tests.toString()),
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.image),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
