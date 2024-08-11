// ignore_for_file: file_names

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_app/APP/additional_information.dart';
//import 'package:second_app/APP/location.dart';
//import 'package:second_app/APP/get_currentlocation.dart';
import 'package:second_app/APP/private.dart';
import 'package:second_app/APP/weather_forecast.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  get data => null;
  TextEditingController zipcode = TextEditingController();

  //double value = 0;
  @override
  void initState() {
    super.initState();
    try {
      //determinePosition();
      weather = getCurrentWeather();
      //determinePosition();
    } catch (e) {
      e.toString();
    }
  }

  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    // setState(() {});
    print("city ${zipcode.text}");
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?zip=523113,in&APPID=$apiKey&units=metric'));
      //print(res.body);
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw "ERROR OCCUR IN 200";
      }
      return data;
      // setState(() {
      //value = (data['list'][0]['main']['temp']);
      // });

      // print("${data['list'][0]['main']['temp']} temperature");
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugDisableShadows = false;
    return MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Weather_app",
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              // InkWell(
              //   child:  Icon(Icons.refresh),
              //   onTap: () {
              //     print("refresh");
              //   },),

              IconButton(
                  onPressed: () {
                    setState(() {
                      weather = getCurrentWeather();
                    });
                  },
                  icon: const Icon(Icons.refresh)),
            ],
          ),
          body: FutureBuilder(
            future: weather,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              final data = snapshot.data!;
              //final currentWeatherData = data['list'][0];

              final currentWeatherData = data['list'][0];
              final currentSky = currentWeatherData['main']['temp'];
              final skycondition = currentWeatherData['weather'][0]['main'];
              final mainPressure = currentWeatherData['main']['pressure'];
              final mainHumidity = currentWeatherData['main']['humidity'];
              final mainWindspeed = currentWeatherData['wind']['speed'];

              // print("condition$currentWeatherData");

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: zipcode,
                            decoration: InputDecoration(
                              hintText: "ENTER ZIP CODE",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    weather = getCurrentWeather();
                                  });
                                },
                                icon: const Icon(Icons.search_outlined),
                                iconSize: 30,
                              ),
                            ),
                          ),
                        ),
                        //main card
                        SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Card(
                            elevation: 150,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      Text(
                                        "$currentSky C",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      const SizedBox(height: 15),
                                      Icon(
                                        skycondition == 'Clouds' ||
                                                skycondition == 'Rain'
                                            ? Icons.cloud
                                            : Icons.sunny,
                                        size: 60,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "$skycondition",
                                        style: const TextStyle(fontSize: 30),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text("WEATHER FORECAST",
                        //       style:
                        //           TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                        // ),
                        const Text("WEATHER FORECAST",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                        //Weather forecast Cards
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: [
                        //       for (int i = 0; i < 5; i++)
                        //         WeatherForecast(
                        //             date: data['list'][i + 1]['dt'].toString(),
                        //             icon: data['list'][i + 1]['weather'][0]
                        //                             ['main'] ==
                        //                         'Clouds' ||
                        //                     data['list'][i + 1]['weather'][0]
                        //                             ['main'] ==
                        //                         'Rain'
                        //                 ? Icons.cloud
                        //                 : Icons.sunny,
                        //             value: data['list'][i + 1]['main']['temp']
                        //                 .toString()),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                final hourlyForecast = data['list'][index + 1];
                                final time =
                                    DateTime.parse(hourlyForecast['dt_txt']);
                                final hourlySky = data['list'][index + 1]
                                    ['weather'][0]['main'];
                                final hourlyTemp =
                                    hourlyForecast['main']['temp'].toString();
                                final date =
                                    ((DateTime.parse(hourlyForecast['dt_txt'])
                                            .toString())
                                        .substring(5));
                                final time_ = DateFormat.j().format(time);

                                // final time_ =
                                //     ((DateTime.parse(hourlyForecast['dt_txt'])
                                //             .toString())
                                //         .substring(5));
                                // print("time${(time.toString()).substring(5)}");
                                return WeatherForecast(
                                    date: date.toString(),
                                    icon: hourlySky == 'Clouds' ||
                                            hourlySky == 'Rain'
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    value: hourlyTemp,
                                    time: time_);
                              }),
                        ),

                        const SizedBox(height: 20),

                        //CONDITIONS
                        const Text("ADDITIONAL INFORMATION",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20)),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AdditionalInformation(
                              icon: Icons.water_drop,
                              condition: "HUMIDITY",
                              digit: mainHumidity.toString(),
                            ),
                            AdditionalInformation(
                              icon: Icons.air,
                              condition: "WINDSPEED",
                              digit: mainWindspeed.toString(),
                            ),
                            AdditionalInformation(
                              icon: Icons.beach_access,
                              condition: "PRESSURE",
                              digit: mainPressure.toString(),
                            )
                          ],
                        )
                      ]),
                ),
              );
            },
          ),
        ));
  }
}
