import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late WeatherFactory wf;
  late Future<Weather> _getWeather;

   Map<String, IconData> weatherIcons = {
    '01d': WeatherIcons.day_sunny,
    '01n': WeatherIcons.night_clear,
    '02d': WeatherIcons.day_cloudy,
    '02n': WeatherIcons.night_cloudy,
    '03d': WeatherIcons.cloud,
    '03n': WeatherIcons.cloud,
    '04d': WeatherIcons.cloudy,
    '04n': WeatherIcons.cloudy,
    '09d': WeatherIcons.showers,
    '09n': WeatherIcons.showers,
    '10d': WeatherIcons.rain,
    '10n': WeatherIcons.rain,
    '11d': WeatherIcons.thunderstorm,
    '11n': WeatherIcons.thunderstorm,
    '13d': WeatherIcons.snow,
    '13n': WeatherIcons.snow,
    '50d': WeatherIcons.fog,
    '50n': WeatherIcons.fog,
  };


  @override
  void initState() {
    super.initState();

    wf = WeatherFactory(
      "de92591a98dea437f95642b0fe92bf17",
      language: Language.ROMANIAN,
    );
    _getWeather = wf.currentWeatherByCityName("Bucharest");
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Weather>(
      future: _getWeather,
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Weather weather = snapshot.data!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weather.temperature!.celsius!.toStringAsFixed(0)}°C',
                style: TextStyle(fontSize: 40),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    weatherIcons[weather.weatherIcon],
                    size: 64,
                  ),
                  Text(
                    weather.weatherDescription!.toUpperCase(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
