import 'package:equatable/equatable.dart';

enum NavItem {
  homeView,
  profileView,
 
}


class NavDrawerState extends Equatable {
  final NavItem selectedItem;

  const NavDrawerState(this.selectedItem);

  @override
  List<Object?> get props => [
        selectedItem,
      ];
}