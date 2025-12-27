
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/seller/presentation/seller_dashboard_screen.dart';
import '../../features/seller/presentation/store_profile_screen.dart';
import '../../features/seller/presentation/add_product_screen.dart';
import '../../features/buyer/presentation/buyer_home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/seller-dashboard',
      builder: (context, state) => const SellerDashboardScreen(),
    ),
    GoRoute(
      path: '/store-profile',
      builder: (context, state) => const StoreProfileScreen(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/buyer-home',
      builder: (context, state) => const BuyerHomeScreen(),
    ),
    // TODO: Add other routes here
  ],
);
