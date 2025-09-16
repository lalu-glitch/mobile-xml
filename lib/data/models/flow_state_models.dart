import '../../core/helper/dynamic_app_page.dart';
import 'icon_models/icon_data.dart';

class FlowStateModel {
  final int flow;
  final IconItem iconItem;
  final int currentIndex;
  final List<AppPage> sequence;

  const FlowStateModel({
    required this.flow,
    required this.iconItem,
    required this.currentIndex,
    required this.sequence,
  });

  FlowStateModel copyWith({
    int? flow,
    IconItem? iconItem,
    int? currentIndex,
    List<AppPage>? sequence,
  }) {
    return FlowStateModel(
      flow: flow ?? this.flow,
      iconItem: iconItem ?? this.iconItem,
      currentIndex: currentIndex ?? this.currentIndex,
      sequence: sequence ?? this.sequence,
    );
  }
}
