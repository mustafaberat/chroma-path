import 'level_data.dart';
import 'model.dart';

abstract final class Levels {
  static final List<FlowLevel> all = List<FlowLevel>.generate(generatedSizes.length, (index) {
    return FlowLevel(id: index + 1, size: generatedSizes[index], flows: generatedFlows[index]);
  });
}
