export 'injection.dart';

import 'network_di.dart';
import '../../features/feed/feed_di.dart';
import '../../features/location/location_di.dart';

Future<void> initDependencies() async {
  await initNetworkDependencies();
  await initLocationDependency();
  await initFeedDependency();
}
