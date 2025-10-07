import 'package:xmlapp/data/models/layanan/layanan_model.dart';

import '../../../core/helper/dynamic_app_page.dart';

class FlowStateModel {
  final int flow;
  final IconItem layananItem;
  final int currentIndex;
  final List<AppPage> sequence;

  const FlowStateModel({
    required this.flow,
    required this.layananItem,
    required this.currentIndex,
    required this.sequence,
  });

  FlowStateModel copyWith({
    int? flow,
    IconItem? layananItem,
    int? currentIndex,
    List<AppPage>? sequence,
  }) {
    return FlowStateModel(
      flow: flow ?? this.flow,
      layananItem: layananItem ?? this.layananItem,
      currentIndex: currentIndex ?? this.currentIndex,
      sequence: sequence ?? this.sequence,
    );
  }
}
