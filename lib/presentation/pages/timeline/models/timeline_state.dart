import 'anniversary_item.dart';

class TimelineState {
  final List<AnniversaryItem> anniversaries;
  final Set<String> generatedKeys;
  final String? myName;
  final String? myBirthday;
  final String? partnerName;
  final String? partnerBirthday;
  final bool initialScrollDone;

  TimelineState({
    List<AnniversaryItem>? anniversaries,
    Set<String>? generatedKeys,
    this.myName,
    this.myBirthday,
    this.partnerName,
    this.partnerBirthday,
    this.initialScrollDone = false,
  })  : anniversaries = anniversaries ?? [],
        generatedKeys = generatedKeys ?? {};

  TimelineState copyWith({
    List<AnniversaryItem>? anniversaries,
    Set<String>? generatedKeys,
    String? myName,
    String? myBirthday,
    String? partnerName,
    String? partnerBirthday,
    bool? initialScrollDone,
  }) {
    return TimelineState(
      anniversaries: anniversaries ?? this.anniversaries,
      generatedKeys: generatedKeys ?? this.generatedKeys,
      myName: myName ?? this.myName,
      myBirthday: myBirthday ?? this.myBirthday,
      partnerName: partnerName ?? this.partnerName,
      partnerBirthday: partnerBirthday ?? this.partnerBirthday,
      initialScrollDone: initialScrollDone ?? this.initialScrollDone,
    );
  }
}
