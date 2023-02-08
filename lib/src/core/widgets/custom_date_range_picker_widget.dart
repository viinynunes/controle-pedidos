import 'package:flutter/material.dart';

class CustomDateRangePickerWidget extends StatelessWidget {
  const CustomDateRangePickerWidget(
      {Key? key,
      required this.iniDate,
      required this.endDate,
      required this.afterSelect,
      required this.onLongPress,
      required this.text})
      : super(key: key);

  final DateTime iniDate;
  final DateTime endDate;
  final Function(DateTime iniDate, DateTime endDate) afterSelect;
  final VoidCallback onLongPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await showDateRangePicker(
            context: context,
            initialDateRange: DateTimeRange(
              start: iniDate,
              end: iniDate,
            ),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050),
            builder: ((context, child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.blue,
                    onPrimary: Colors.black,
                    surface: Colors.blue,
                    onSurface: Colors.white,
                  ),
                  textTheme: const TextTheme(overline: TextStyle(fontSize: 16)),
                  dialogBackgroundColor: Colors.black54,
                ),
                child: child!,
              );
            })).then(
          (result) {
            if (result != null) {
              afterSelect(result.start, result.end);
            }
          },
        );
      },
      onLongPress: onLongPress,
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
