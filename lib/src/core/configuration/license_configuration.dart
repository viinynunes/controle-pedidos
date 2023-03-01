
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LicenseConfiguration {
  static void config(){
     LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);

    final imgLicense = await rootBundle
        .loadString('<a href="https://www.freepik.com/free-vector/'
            'neon-purple-lights-background-arrow-style_8152351'
            '.htm#page=4&query=background&position=31&from_view=search&track='
            'sph">Image by starline</a> on Freepik');

    yield LicenseEntryWithLineBreaks(['freepick'], imgLicense);
  });
  }
}