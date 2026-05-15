import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarState {
  final bool isCollapsed;
  final int selectedIndex;
  SidebarState({this.isCollapsed = false, this.selectedIndex = 0});
}

class SidebarCubit extends Cubit<SidebarState> {
  SidebarCubit() : super(SidebarState());

  void toggleSidebar() => emit(
    SidebarState(
      isCollapsed: !state.isCollapsed,
      selectedIndex: state.selectedIndex,
    ),
  );
  void selectItem(int index) =>
      emit(SidebarState(isCollapsed: state.isCollapsed, selectedIndex: index));
}
