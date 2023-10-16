import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

Widget bottomNavigation({
  required Function(int index) handleNavigationChange,
}) {
  return FluidNavBar(
    icons: [
      FluidNavBarIcon(
        icon: Icons.home,
        backgroundColor: Colors.grey,
        extras: {"label": "home"}),
      FluidNavBarIcon(
        icon: Icons.pets,
        backgroundColor: Colors.grey,
        extras: {"label": "pets"}),
      FluidNavBarIcon(
        icon: Icons.person,
        backgroundColor: Colors.grey,
        extras: {"label": "account"}),
    ],
    onChange: handleNavigationChange,
    style: const FluidNavBarStyle(iconUnselectedForegroundColor: Colors.white, iconSelectedForegroundColor: Colors.white),
    scaleFactor: 1.5,
    defaultIndex: 1,
    itemBuilder: (icon, item) => Semantics(
      label: icon.extras!["label"],
      child: item,
    ),
  );
}
