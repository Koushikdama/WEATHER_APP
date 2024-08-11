import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  final String date;
  final IconData icon;
  final String value;
  final String time;
  const WeatherForecast(
      {super.key,
      required this.date,
      required this.icon,
      required this.value,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      width: 100,
      child: Card(
          elevation: 30,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.clip),
                    maxLines: 1,
                  ),
                  Icon(
                    icon,
                    size: 30,
                  ),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(time,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600))
                ],
              ),
            ),
          )),
    );
  }
}
